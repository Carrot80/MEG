function patients ()
   
PatientFolder = '/home/kh/ShareWindows/data/patients/patients_SAM';
ControlsFolder = '/home/kh/ShareWindows/data/controls/controls_SAM';

forAll (PatientFolder, 'Patients')
forAll (ControlsFolder, 'Controls')

end


function forAll(Folder, group)

% dies für alle Patienten nutzen und umbauen
ControlsFolder = '/home/kh/ShareWindows/data/patients/patients_SAM';

DIR = dir (Folder)
isub = [DIR(:).isdir]; %  returns logical vector
nameFolds = {DIR(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

for i= 1:size(nameFolds)
    
   kh_SAM_TimeInt( strcat(Folder, filesep, nameFolds{i,1}), nameFolds{i}, .405, group)
   
   
end


end

function kh_SAM_TimeInt (SubjectPath, SubjectName, Time, group)


if 1==strcmp(SubjectName,'Pat_02_13008rh') || 1==strcmp(SubjectName,'Pat_03_13014bg') 

    return
end

SAMPath = strcat(SubjectPath, filesep, 'SAM');
cd (SAMPath)

% to multiply weights with avgBL, read weights :


% load avg:
if 1==strcmp(group, 'Patients')
PathAVG = strcat(SubjectPath, filesep, 'avgBL');
[SAMHeader, ActIndex, ActWgts]=readWeights('M400,1-50Hz,VGa.wts');
else
    PathAVG = strcat(SubjectPath, filesep, 'SAM', filesep, 'Workspace_SAM.mat');
end

load(PathAVG)

vs=ActWgts*avgBL.avg;
ns=mean(abs(ActWgts),2); % am 23.5.14 hinzugefügt, nachdem Ergebnisse Bias to the Center aufwiesen
vs=vs./repmat(ns,1,size(vs,2)); % am 23.5.14 hinzugefügt, nachdem Ergebnisse Bias to the Center aufwiesen

fs = 1017.25;
size_vs=size(vs);
offset_samples = 509;
vs_1_1000ms = vs(:,offset_samples:size_vs(2));
size_vs_1_1000ms=size(vs_1_1000ms);
time_samples=1:size_vs_1_1000ms(2);
time_sec=time_samples./fs;
% I could have used function nearest, too.


if 1==strcmp(group, 'Patients')
    PathNewDir = strcat(SubjectPath, filesep, 'TimeIntervalls');
    cd(PathNewDir)
end


% figure
% plot(time_sec,max(abs(vs_1_1000ms)));
% axis tight;
% Title=strcat(num2str(TimeBeg), '_', num2str(TimeEnd), 's_', SubjectName);
% title(Title)
% print (Title); 
% close all

nearest(time_sec, Time)

vs_IntOfIn=vs_1_1000ms(:,nearest(time_sec, Time));
% sum_vs_IntOfIn = sum(abs(vs_IntOfIn')); % dies ist richtig!  (hier nicht
% benötigt)


% Save it to load it in afni
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
str_timeInt= strcat('ERF_noise', '_', num2str(Time), 's_', SubjectName);
cfg.prefix = str_timeInt; % change prefix
% cfg.torig=-500;   %  comment if you want to sum up activity of specific time intervall
% cfg.TR=1/1.01725; % comment if you want to sum up activity of specific time intervall
% VS2Brik(cfg,vs);
% max(max(vs))
VS2Brik(cfg,1e+13*(vs_IntOfIn)); % =>creates ERF+orig.Brik+Head 

NewFileName = strcat(str_timeInt,'+orig');
disp(['!@auto_tlrc -apar ', strcat(SubjectPath, filesep, 'keptTrials', filesep, 'orthoMNI_avg152T+tlrc'), ' -input ', NewFileName,' -dxyz 5']) % 
eval(['!@auto_tlrc -apar ', strcat(SubjectPath, filesep, 'keptTrials', filesep, 'orthoMNI_avg152T+tlrc'), ' -input ', NewFileName,' -dxyz 5']) % 

kh_reduceERF2Brain (SubjectPath, SubjectName, Time)
kh_z_transform (SubjectPath, SubjectName, Time)

end


function kh_reduceERF2Brain (SubjectPath, SubjectName, Time)

% if 1 == strcmp (SubjectPath, '/home/kh/data/controls_SAM/zzz_ca') || 1 == strcmp (SubjectPath, '/home/kh/data/controls_SAM/zzz_ht')
%     return
% end


FileNameOld = strcat('ERF_noise_', num2str(Time), 's', '_', SubjectName, '+tlrc');

disp(['!3dcalc -a /home/kh/ShareWindows/data/mniBrain01+tlrc -b ', FileNameOld, ' -prefix ', strcat('brain01', FileNameOld), ' -exp ', 'b*a'])
eval(['!3dcalc -a /home/kh/ShareWindows/data/mniBrain01+tlrc -b ', FileNameOld, ' -prefix ', strcat('brain01', FileNameOld), ' -exp ', 'b*a'])


end


function kh_z_transform (SubjectPath, SubjectName, Time)


    % (X-MEAN(X)) ./ STD(X)
    %  Vzscore = (V-mean(V)./std(V);
    
    FileName = strcat('brain01ERF_noise_', num2str(Time), 's', '_', SubjectName, '+tlrc');   

    [V, Info] = BrikLoad (FileName);


    Vz=(V-mean(V(:)))/std(V(:));
    


    OptTSOut.Scale = 1;
    OptTSOut.Prefix = strcat('z_transf_', FileName);
    OptTSOut.verbose = 1;
    OptTSOut.View = '+tlrc'
    %Vsymm=double(Vlr+V>0);

    WriteBrik (Vz, Info, OptTSOut);

%     Vdif=V-Vlr;
%     Vdif(1:16,:,:)=0;
%     InfoNewTSOut = Info;
%     InfoNewTSOut.RootName = '';
%     InfoNewTSOut.BRICK_STATS = [];
%     InfoNewTSOut.BRICK_FLOAT_FACS = [];
%     InfoNewTSOut.IDCODE_STRING = '';
%     InfoNewTSOut.BRICK_TYPES=3*ones(1,1); % 1 short, 3 float.
%     InfoNewTSOut.DATASET_RANK(2)=1;


FileNameNew = OptTSOut.Prefix;   
   
eval(['!3dcalc -a /home/kh/ShareWindows/data/mniBrain01+tlrc -b ', FileNameNew,  ' -prefix ', strcat('br_', FileNameNew),' -exp ' , 'b*a'])

PathERF = strcat('br_z_transf_brain01ERF_noise_', num2str(Time), 's_', SubjectName, '+tlrc');
eval (['!3dcopy ', PathERF, ' ',strcat('br_z_transf_brain01ERF_noise_', num2str(Time), 's_', SubjectName, 'MNI.nii')])
    
    
end
