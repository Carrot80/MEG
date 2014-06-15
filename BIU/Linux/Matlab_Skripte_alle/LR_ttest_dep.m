function LR_ttest_dep()
    ControlsFolder = '/home/kh/ShareWindows/data/controls/controls_SAM';
    PatientFolder  = '/home/kh/ShareWindows/data/patients/patients_SAM';
    TimeInt = [.32, .6];
    for_all( ControlsFolder, 'Controls', TimeInt )
    for_all( PatientFolder,  'Patients', TimeInt )
end


function for_all (Folder, group, TimeInt)
    DIR = dir (Folder)
    isub = [DIR(:).isdir]; %  returns logical vector
    nameFolds = {DIR(isub).name}';
    nameFolds(ismember(nameFolds,{'.','..'})) = [];

    Main (nameFolds, Folder, group, TimeInt)
end


function Main (nameFolds, Folder, group, TimeInt)
    VlrAll = [];
    Vall   = [];

 % TimInt unten noch anpassen

    for i = 4:size(nameFolds)
        SubjectPath = strcat(Folder, filesep, nameFolds{i,1});
        SubjectName = nameFolds{i};
        
        [avg] = AVG_CleanData (SubjectPath, SubjectName, group)
        kh_SAM(SubjectPath, SubjectName, group, avg)
        %     [VlrAll, Vall] = get_V (SubjectPath, SubjectName, VlrAll, Vall, TimeInt);
        %     UtestLR (SubjectPath, SubjectName, VlrAll, Vall, TimeInt)
    end
end


function [avg]=AVG_CleanData (SubjectPath, SubjectName, group)
    % Hauptordner ist für Patienten mit 2 Runs uninteressant
    if 1 == strcmp (SubjectName, 'Pat_02_13008rh') || 1 == strcmp (SubjectName, 'Pat_03_13014bg')
        return
    end

    switch SubjectName
        case 'Pat_03_13014bg_1'
            File_CleanData= strcat (SubjectPath, filesep, 'TTest', filesep, 'CleanDataSNR.mat');
        case 'Pat_03_13014bg_2'
            File_CleanData= strcat (SubjectPath, filesep, 'TTest', filesep, 'CleanDataSNR_best.mat');
        case  'Pat_07_13033gc'
            File_CleanData= strcat (SubjectPath, filesep, 'TTest', filesep, 'CleanData_nobadTrls.mat');
        case  'Pat_08_13026pj'
            File_CleanData= strcat (SubjectPath, filesep, 'TTest', filesep, 'CleanData_rejcomp.mat');
        case  'Pat_11_13030rs'
            File_CleanData= strcat (SubjectPath, filesep, 'TTest', filesep, 'CleanData_rejcomp.mat');
        case  'Pat_14_13039sg'
            File_CleanData= strcat (SubjectPath, filesep, 'TTest', filesep, 'CleanDataSNR2.mat');
        case  'Pat_17_13060ec'
            File_CleanData= strcat (SubjectPath, filesep, 'TTest', filesep, 'CleanData_rejectcomp2.mat');
        case  'Pat_19_13055eg'
            File_CleanData= strcat (SubjectPath, filesep, 'TTest', filesep, 'CleanData_rejcomp.mat');
        case  'Pat_21_13056hz'
            File_CleanData= strcat (SubjectPath, filesep, 'TTest', filesep, 'CleanData_rejcomp108Trials.mat');
        case  'Pat_22_13059oc'
            File_CleanData= strcat (SubjectPath, filesep, 'TTest', filesep, 'CleanData_rejcomp2.mat');
        case  'Pat_24_13067pj'
            File_CleanData= strcat (SubjectPath, filesep, 'TTest', filesep, 'CleanDataSNR1_5.mat');
        otherwise
            File_CleanData = strcat(SubjectPath, filesep, 'TTest', filesep, 'CleanData.mat');
    end

    % alte Zwischenergebnis löschen. Kann nach einen run entfernt werden (ToDo)
    if exist(strcat(SubjectPath, filesep, 'TTest', filesep, 'AvgKeepTrials.mat'), 'file')
        delete(strcat(SubjectPath, filesep, 'TTest', filesep, 'AvgKeepTrials.mat'))
    end    

    load(File_CleanData)
    CleanDataBL = correctBL(CleanData,[-0.32 -.02]);
    cfg = [];
    cfg.keeptrials='yes';
    
    % hier gehts weiter!
    avg = ft_timelockanalysis(cfg, CleanDataBL);

end

%%


function kh_SAM(SubjectPath, SubjectName, group, avg)
    switch group
        case 'Controls'
            load(strcat(SubjectPath, filesep, 'SAM', filesep, 'Workspace_SAM.mat'));
            save(strcat(SubjectPath, filesep, 'SAM', filesep, 'Workspace_SAM.mat'), 'ActIndex', 'ActWgts', 'SAMHeader', 'avgBL') % ToDo: kann nach einem Run entfernt werden 

        otherwise 
            PathSAM = strcat(SubjectPath, filesep, 'SAM', filesep);
            cd (PathSAM) % change matlab dir to Path of weights (SAMdir)
            [SAMHeader, ActIndex, ActWgts] = readWeights('M400,1-50Hz,VGa.wts');
    end        
            
        cd(strcat(SubjectPath, filesep, 'TTest'))
        
    for i=1:length(avg.trial(:,1,1))

        vs = [];
        ns = [];
        vs=ActWgts*squeeze(avg.trial(i,:,:));
        ns=mean(abs(ActWgts),2);
        vs=vs./repmat(ns,1,size(vs,2));

        fs = 1017.25;
        offset_samples = 509;
        vs_1_1000ms = vs(:,offset_samples:size(vs,2));
        time_samples=1:size(vs_1_1000ms,2);
        time_sec=time_samples./fs;
        TimeEnd=nearest(time_sec, .8) % von 0 bis 800ms

        vs_IntOfIn=vs_1_1000ms(:,1:TimeEnd); % von 0 bis 800ms

        cfg         = [];
        cfg.step    = 5;
        cfg.boxSize = [-120 120 -90 90 -20 150];
        cfg.prefix  = strcat('ERF_1_800ms_Trial_', num2str(i)); % change prefix
        cfg.torig   = 1;   %  comment if you want to sum up activity of specific time intervall
        cfg.TR      = 1/1.01725; % comment if you want to sum up activity of specific time intervall
        % VS2Brik(cfg,vs);
        % max(max(vs))
        VS2Brik(cfg,1e+12*abs(vs_IntOfIn)); % =>creates ERF+orig.Brik + Head
    end
 end


function [VlrAll, Vall] = get_V (SubjectPath, SubjectName, VlrAll, Vall, TimeInt)
    % Achtung: zeitintervall umändern!
    Path = strcat(SubjectPath, filesep, 'TTest');
    cd (Path)
    % load CleanData für länge der Trials 
    for i= 1:length()
        FileName = strcat('ERF_1_800ms_Trial_', num2str(i), '+orig');

        [V, Info] = BrikLoad (FileName);

        % Sum Samples in Time Interval
        fs        = 1017.25;             % Samplingrate vom MEG
        time      = (1:1000)/fs;         %
        TimeBeg   = nearest(time, .32)
        TimeEnd   = nearest(time, .6)
        V_TimeInt = V(:,:,:, TimeBeg:TimeEnd); 
        % sum forth dimension:
        V_TimeInt_sum=sum(V_TimeInt(:,:,:, TimeBeg:TimeEnd),4);

        clear V V_TimeInt       

        Vlr=flipdim(V_TimeInt_sum,2);
        if i==1
            Vall   = V_TimeInt_sum;
            VlrAll = Vlr;
        else
            Vall(:,:,:,i)   = V_TimeInt_sum;
            VlrAll(:,:,:,i) = Vlr;
        end
        clear V_TimeInt_sum
    end
end

%%

function UtestLR (SubjectPath, SubjectName, VlrAll, Vall, TimeInt)
 
    % SubjectToAnalyse = '/home/kh/data/controls_SAM/zzz_ms';
    % if 0 == strcmp (SubjectPath, SubjectToAnalyse)
    % return
    % end

    U=zeros(size(Vall,1),size(Vall,2),size(Vall,3));
    
    for i=1:size(Vall,1)
        for j=1:size(Vall,2)
            for k=1:size(Vall,3)
                if Vall(i,j,k)>0
                    p = ttest(squeeze(Vall(i,j,k,:)),squeeze(VlrAll(i,j,k,:)));
                    u=1-p;
                    dif=mean(squeeze(Vall(i,j,k,:)))-mean(squeeze(VlrAll(i,j,k,:)));
                    if dif>0
                        R=1;% R is 1 when current is larger than other side
                    else
                        R=-1;
                    end
                    U(i,j,k)=R*u;
                end
            end
        end
    end

    [~, Info] = BrikLoad (strcat(SubjectPath, filesep, 'SAM/', 'ERF_0.4-0.6s_', SubjectName, '+orig')); % Info would be 
    
    Path = strcat(SubjectPath, filesep, 'TTest'); 
    
    cd (Path)
    
    OptTSOut.Scale = 1;
    OptTSOut.Prefix = strcat('ttest', '_', 'LR', '_', num2str(TimeInt(1,1)), '_', num2str(TimeInt(1,2)), 's');
    OptTSOut.verbose = 1;
    OptTSOut.View = '+orig' ;
    %Vsymm=double(Vlr+V>0);
    WriteBrik (U, Info, OptTSOut);
end


function kh_UTest_normalize (SubjectPath, SubjectName, TimeInt)

    % if 0 == strcmp (SubjectName, 'Pat_02_13008rh')
    %     return
    % end
    
    % Path = strcat (SubjectPath, filesep, 'keptTrials');

    PathName = strcat(SubjectPath, filesep, 'UTest');
    cd (PathName)

    if exist (strcat(SubjectPath, filesep, 'orthoMNI_avg152T+tlrc.BRIK'))
        movefile(strcat(SubjectPath, filesep, 'orthoMNI_avg152T+tlrc.BRIK'), strcat(SubjectPath, filesep,'keptTrials', filesep, 'orthoMNI_avg152T+tlrc.BRIK'));
    end

    if exist(strcat(SubjectPath, filesep, 'orthoMNI_avg152T+tlrc.HEAD'))
        movefile(strcat(SubjectPath, filesep, 'orthoMNI_avg152T+tlrc.HEAD'), strcat(SubjectPath, filesep,'keptTrials', filesep, 'orthoMNI_avg152T+tlrc.HEAD'));
    end

    PathUtest = strcat('Utest_LR_', num2str(TimeInt(1,1)), '_', num2str(TimeInt(1,2)), 's', '+orig');

    disp(['!@auto_tlrc -apar ', '/home/kh/data/patients_SAM/', SubjectName, '/UTest/orthoMNI_avg152T+tlrc',' -suffix MNI -input ', PathUtest, ' -ok_notice']);
    % eval(['!@auto_tlrc -apar ', 'orthoMNI_avg152T+tlrc',' -suffix MNI -input ', PathUtest, ' -dxyz 5']);
    eval(['!@auto_tlrc -apar ', 'orthoMNI_avg152T+tlrc',' -suffix MNI -input ', PathUtest, ' -dxyz 5']);


    eval(['!@auto_tlrc -apar ', SubjectPath, '/UTest/orthoMNI_avg152T+tlrc',' -suffix MNI -input ', PathUtest, ' -dxyz 5']);
    % eval(['!@auto_tlrc -apar ', 'orthoMNI_avg152T+tlrc',' -suffix MNI -input ', PathUtest, ' -dxyz 5']);

    % !@auto_tlrc -apar orthoMNI_avg152T+tlrc -input ERF+orig -dxyz 5  

    FileName = strcat('Utest_LR_', num2str(TimeInt(1,1)), '_', num2str(TimeInt(1,2)), 'sMNI+tlrc'); 

    eval(['!3dcalc -a /home/kh/ShareWindows/data/mniBrain01+tlrc -b ', FileName, ' -prefix ', strcat('brain01_', FileName), ' -exp ', 'b*a'])
end

