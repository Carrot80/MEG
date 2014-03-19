
function for_all_subjects  

%     PatientFolder = 'D:\kirsten_thesis\data\patients\';
    ControlsFolder = 'D:\kirsten_thesis\data\controls\';
    
     SelectSubjects (ControlsFolder)
%      SelectSubjects (PatientFolder)
end


function SelectSubjects (Mainfolder)

    List = dir( Mainfolder );

 for i = 1 : size (List)
      if ( 0 == strcmp( List(i,1).name, '.') && 0 == strcmp( List(i,1).name, '..') )
          SubjectPath = strcat(Mainfolder, List(i,1).name) ;
          SubjectName = List(i,1).name  
          
          [Path] = MakePath(SubjectPath, SubjectName)
          AvgData (SubjectName, Path)
           

      end
 end
 
end

function [Path] = MakePath(SubjectPath, SubjectName)
        
        Path                     = [];
        Path.Subject             = SubjectPath ; 
        Path.Preprocessing       = strcat ( SubjectPath, '\MEG\02_PreProcessing')          ;
        
end


function AvgData (SubjectName, Path, CleanData)

 
    File_CleanData = strcat (Path.Preprocessing, filesep, 'CleanData.mat');
    load (File_CleanData)
    
    cfg = [];
    cfg.keeptrials = 'yes';
    avg = ft_timelockanalysis(cfg, CleanData);
    
    avgTrials = avg;
    
    TrialByTen=floor(length(CleanData.trial)./10);
      
    
    i = 1:TrialByTen:length(CleanData.trial) ;
    j = [i-1, (i(end)-1)+TrialByTen];
    
    avgTrials.trial = [];
     
    for a= 1:10
        b=a+1;
        avgTrials.trial(a,:,:) = mean(avg.trial(i(a):j(b),:,:));
      

    end
    
    %Baselinecorrection:
    
    for i=1:10
    
    avgTrialsBL=correctBL(avgTrials.trial(i,:,[-0.32 -.02]);
    
    
    end
    save avgTrials_Pat_07_13033gc_ohneICA avgTrials
    
    
%     PathavgTrials = strcat ('D:\kirsten_thesis\data\all\Results_controls\AVG_keeptrials', filesep, 'avgTrials_', SubjectName, '.mat')
%     
%     save (PathavgTrials, 'avgTrials')
    
    %%
    
    
    
    
end
    
    




% avgTrials.trial = [];
%     avgTrials.trial(1,:,:) = mean(avg.trial(i(1):j(2),:,:));
%     avgTrials.trial(2,:,:) = mean(avg.trial(i(2):j(3),:,:));
%     avgTrials.trial(3,:,:) = mean(avg.trial(i(3):j(4),:,:));
%     avgTrials.trial(4,:,:) = mean(avg.trial(i(4):j(5),:,:));
%     avgTrials.trial(5,:,:) = mean(avg.trial(i(5):j(6),:,:));
%     avgTrials.trial(6,:,:) = mean(avg.trial(i(6):j(7),:,:));
%     avgTrials.trial(7,:,:) = mean(avg.trial(i(7):j(8),:,:));
%     avgTrials.trial(8,:,:) = mean(avg.trial(i(8):j(9),:,:));
%     avgTrials.trial(9,:,:) = mean(avg.trial(i(9):j(10),:,:));
%     avgTrials.trial(10,:,:) = mean(avg.trial(i(10):j(11),:,:));
% 
% 

    % Check:
%     Mean = mean(avgTrials.trial(:,:,:));
%     Mean = squeeze(Mean);
%     SumMean=sum(sum(Mean));
%     SumAVG = sum(sum(avg.avg))
    
%     CleanData_1 = CleanData ;
%     Cleandata_1.trial = [] ;
%     Cleandata_1.time = [] ;
%     Cleandata_1.sampleinfo = [] ;
%     Cleandata_1.trial = CleanData.trial(i(1):j(2)) ;
%     Cleandata_1.time = CleanData.time(i(1):j(2)) ;
%     Cleandata_1.sampleinfo = CleanData.sampleinfo(i(1):j(2)) ;
%     
%     CleanData_2 = CleanData;
%     Cleandata_1.trial = [];
%     CleanData_2.trial = CleanData.trial(i(2):j(3));
%     
%     CleanData_3 = CleanData;
%     Cleandata_1.trial = [];
%     CleanData_3.trial = CleanData.trial(i(3):j(4));
%     
%     CleanData_4 = CleanData;
%     Cleandata_1.trial = [];
%     CleanData_4.trial = CleanData.trial(i(4):j(5));
%     
%     CleanData_5 = CleanData;
%     Cleandata_1.trial = [];
%     CleanData_5.trial = CleanData.trial(i(5):j(6));
%     
%     CleanData_6 = CleanData;
%     Cleandata_1.trial = [];
%     CleanData_6.trial = CleanData.trial(i(6):j(7));
%     
%     CleanData_7 = CleanData;
%     Cleandata_1.trial = [];
%     CleanData_7.trial = CleanData.trial(i(7):j(8));
%     
%     CleanData_8 = CleanData;
%     Cleandata_1.trial = [];
%     CleanData_8.trial = CleanData.trial(i(8):j(9));
%     
%     CleanData_9 = CleanData;
%     Cleandata_1.trial = [];
%     CleanData_9.trial = CleanData.trial(i(9):j(10));
%     
%     CleanData_10 = CleanData;
%     Cleandata_1.trial = [];
%     CleanData_10.trial = CleanData.trial(i(10):j(11));
%     
%        
%     
%     cfg = [];
%     cfg.keeptrials = 'yes';
%     avg = ft_timelockanalysis(cfg, CleanData);
%     
%     Mean=mean(avg.trial);
%     
%     
%     cfg = [];
%   
%     
%     figure;plot(avg.time,avg.avg)
%     title(strcat('avg',' ','-', ' ', SubjectName)); 
%     Fig_avg = strcat (Path.Preprocessing, filesep, 'avg.fig');
%     saveas(gcf, Fig_avg, 'fig');
%     
%     avgBL=correctBL(avg,[-0.3 0]);
%     figure;plot(avgBL.time,avgBL.avg)
%     title(strcat('avgBL',' ','-', ' ', SubjectName)); 
%     Fig_avgBL = strcat (Path.Preprocessing, filesep, 'avgBL.fig');
%     saveas(gcf, Fig_avgBL, 'fig');
% 
%     File_AVG = strcat (Path.Preprocessing, filesep, 'avg.mat');
%     save (File_AVG, 'avg')  
%     
%     File_AVGBL = strcat (Path.Preprocessing, filesep, 'avgBL.mat');
%     save (File_AVGBL, 'avgBL')  
%     
%     figure
%     cfg = [];
%     cfg.interactive = 'yes';
%     ft_topoplotER(cfg, avgBL);
%     Fig_topoAVG = strcat (Path.Preprocessing, filesep, 'TopoAVG.fig');
%     saveas(gcf, Fig_topoAVG, 'fig');
% 
% %     trl=DataBp1_50Hz.trial
% %     trl=trl(trlsel==1)
% %     DataBp1_50Hz.trial=trl
% %     cfg=rmfield(cfg,'ylim');
% %     ft_singleplotER(cfg,avgBL);
% %   
% 
%     
% 
%     % plot:
%     figure
%     cfg = [];
%     cfg.xlim = [0.2 0.4];
%     cfg.colorbar = 'yes';
%     ft_topoplotER(cfg,avg);
% 
%     cfg = [];
%     figure
%     cfg.xlim = [-0.3 1.0];
%     ft_singleplotER(cfg,avg);



    



