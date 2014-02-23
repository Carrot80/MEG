
function forAll()


ControlsFolder = '/home/kh/data/controls_SAM';

DIR = dir (ControlsFolder)
isub = [DIR(:).isdir]; %  returns logical vector
nameFolds = {DIR(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

 %% 

AVG = [];

for i= 1:size(nameFolds)
    
   [AVG, TimeBeg, TimeEnd] = kh_get_avg( strcat(ControlsFolder, filesep, nameFolds{i,1}), nameFolds{i}, .32, .6, AVG, i)
   
   
end

    kh_avg_AllSubj(AVG, TimeBeg, TimeEnd)
    
 %%   
    
 AVG = [];

for i= 1:size(nameFolds)
    
   [AVG, TimeBeg, TimeEnd] = kh_get_avg( strcat(ControlsFolder, filesep, nameFolds{i,1}), nameFolds{i}, .2, .31, AVG, i)
   
end   
    
   kh_avg_AllSubj(AVG, TimeBeg, TimeEnd)
   
   %%
       
   AVG = [];

for i= 1:size(nameFolds)
    
   [AVG, TimeBeg, TimeEnd] = kh_get_avg( strcat(ControlsFolder, filesep, nameFolds{i,1}), nameFolds{i}, .2, .6, AVG, i)
   
   
end   

  kh_avg_AllSubj(AVG, TimeBeg, TimeEnd) 
   

   
end




function [AVG, TimeBeg, TimeEnd]=kh_get_avg (SubjectPath, SubjectName, TimeBeg, TimeEnd, AVG, i)


    Path = strcat(SubjectPath, filesep, 'SAM');
    cd (Path)
    
    FileName = strcat('br_z_transf_brain01ERF_', num2str(TimeBeg), '-', num2str(TimeEnd), 's', '_', SubjectName, '+tlrc');   

    [V, Info] = BrikLoad (FileName);
    
    AVG{i}=V;
    

    %%
%     Vdif=V-Vlr;
%     Vdif(1:16,:,:)=0;
%     InfoNewTSOut = Info;
%     InfoNewTSOut.RootName = '';
%     InfoNewTSOut.BRICK_STATS = [];
%     InfoNewTSOut.BRICK_FLOAT_FACS = [];
%     InfoNewTSOut.IDCODE_STRING = '';
%     InfoNewTSOut.BRICK_TYPES=3*ones(1,1); % 1 short, 3 float.
%     InfoNewTSOut.DATASET_RANK(2)=1;
 
    
end

function kh_avg_AllSubj (AVG, TimeBeg, TimeEnd)

AVG_all = (AVG{1}+AVG{2}+AVG{3}+AVG{4}+AVG{5}+AVG{6}+AVG{7}+AVG{8}+AVG{9}+AVG{10})./length(AVG);
   
    OptTSOut.Scale = 1;
    OptTSOut.Prefix = strcat('AVG_controls_',num2str(TimeBeg),'_', num2str(TimeEnd), 's');
    OptTSOut.verbose = 1;
    OptTSOut.View = '+tlrc'
    %Vsymm=double(Vlr+V>0);
    
    Info = X; % ???
    cd /home/kh/data/AVGcontrols
    WriteBrik (AVG_all, Info, OptTSOut);
   

end