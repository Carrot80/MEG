

function for_all_subjects  

    PatientFolder = 'D:\kirsten_thesis\data\patients\';
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
          GetAVG (SubjectName, Path)
          
      end

 end
 
           GrandAverage (SubjectName, Path)
 
end

function [Path] = MakePath(SubjectPath, SubjectName)
        
        Path                     = [];
        Path.Subject             = SubjectPath ; 
        Path.DataInput           = strcat ( SubjectPath, '\MEG\01_Input_no_noisereduction')                 ;
        Path.Preprocessing       = strcat ( SubjectPath, '\MEG\02_PreProcessing')          ;
        
end

function [avg] = GetAVG (SubjectName, Path)

  File_AVG = strcat (Path.Preprocessing, filesep, 'avg.mat');
  load(File_AVG)
  PathAVG = strcat('D:\kirsten_thesis\data\all\Results_controls\AVG_controls', filesep, 'avg', '_',  SubjectName);
  save (PathAVG, 'avg')  

end

function    GrandAverage (SubjectName, Path, AVG)

%  Baseline corrected
  cfg =[];
 [grandavgBL_controls] = ft_timelockgrandaverage(cfg, avgBL_1, avgBL_2, avgBL_3, avgBL_4, avgBL_5, avgBL_6, avgBL_7, avgBL_8, avgBL_9, avgBL_10) 
     
 figure;plot(grandavgBL_controls.time,grandavgBL_controls.avg, 'k')

    title('grandavgBL_controls'); 
 
  cfg =[];
   cfg.keepindividual = 'yes';
 [grandavgBL_controls_keepInd] = ft_timelockgrandaverage(cfg, avgBL_1, avgBL_2, avgBL_3, avgBL_4, avgBL_5, avgBL_6, avgBL_7, avgBL_8, avgBL_9, avgBL_10) 
     
    
    
 cfg = [];
    cfg.interactive = 'yes';
    cfg.layout = '4D248.lay';
    ft_topoplotER(cfg, grandavgBL_controls);
   
 %  not Baseline corrected   
    
 cfg =[];
 cfg.keepindividual = 'yes';
 [grandavg_controls_keepInd] = ft_timelockgrandaverage(cfg, avg_01, avg_02, avg_03, avg_04, avg_05, avg_06, avg_07, avg_08, avg_09, avg_10) 
  
 cfg =[];
 cfg.keepindividual = 'no';
 [grandavg_controls] = ft_timelockgrandaverage(cfg, avg_01, avg_02, avg_03, avg_04, avg_05, avg_06, avg_07, avg_08, avg_09, avg_10) 

 figure;plot(grandavg_controls.time,grandavg_controls.avg)
    title('grandavg_controls'); 
    
 cfg = [];
    cfg.interactive = 'yes';
    cfg.layout = '4D248.lay';
    ft_topoplotER(cfg, grandavg_controls);    
    
 
end