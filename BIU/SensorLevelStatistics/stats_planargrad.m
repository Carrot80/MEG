
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
 
%            statsMEGPlanar (SubjectName, Path)
 
end

function [Path] = MakePath(SubjectPath, SubjectName)
        
        Path                     = [];
        Path.Subject             = SubjectPath ; 
        Path.DataInput           = strcat ( SubjectPath, '\MEG\01_Input_no_noisereduction')                 ;
        Path.Preprocessing       = strcat ( SubjectPath, '\MEG\02_PreProcessing')          ;
        Path.StatisticsSensorLevel = strcat (SubjectPath, '\MEG\SensorLevelAnalysis')          ;
end

function GetAVG (SubjectName, Path)


  File_AVG = strcat (Path.StatisticsSensorLevel, filesep, 'avgBL_ra_planar.mat');
  load(File_AVG)
  
  PathAVG = strcat('D:\kirsten_thesis\data\all\Results_controls\AVG_MEGPlanar', filesep, 'avgMEGPlanar', '_',  SubjectName);
  save (PathAVG, 'avgBL_ra_planar')  
  
  

end

function    statsMEGPlanar (SubjectName, Path, AVG)


% Statistics with planar Gradiometers:

% compute Grandavg:

%  Baseline corrected

AVGBL_ra_planar_1 = load (strcat (Path.SensorLevalAnalysis, filesep, 'avgBL_ra_planar.mat'));



  cfg =[] ;
 [grandavgBL_Planar_controls] = ft_timelockgrandaverage(cfg, avgBL_ra_planar_01, avgBL_ra_planar_02, avgBL_ra_planar_03, avgBL_ra_planar_04, avgBL_ra_planar_05, avgBL_ra_planar_06, avgBL_ra_planar_07, avgBL_ra_planar_08, avgBL_ra_planar_09, avgBL_ra_planar_10) 
     
 figure;plot(grandavgBL_Planar_controls.time,grandavgBL_Planar_controls.avg, 'k')

    title('grandavgBLPlanar_controls'); 
 
  cfg =[];
   cfg.keepindividual = 'yes';
    [grandavgBL_Planar_controls_keepInd] = ft_timelockgrandaverage(cfg, avgBL_ra_planar_01, avgBL_ra_planar_02, avgBL_ra_planar_03, avgBL_ra_planar_04, avgBL_ra_planar_05, avgBL_ra_planar_06, avgBL_ra_planar_07, avgBL_ra_planar_08, avgBL_ra_planar_09, avgBL_ra_planar_10) 
     
    
     cfg = [];
    cfg.interactive = 'yes';
    cfg.layout = '4D248.lay';
    ft_topoplotER(cfg, grandavgBL_Planar_controls);
    
 ga=grandavgBL_Planar_controls_keepInd;
[~,Li]=ismember(LRpairs(:,1),ga.label); % ga ) grandaverage with individually kept trials, LRpairs is file from Yuval
[~,Ri]=ismember(LRpairs(:,2),ga.label);
gaLR=ga;
gaLR.individual=zeros(size(gaLR.individual)); % die mittleren Sensoren behalten Nullen
gaLR.individual(:,Li,:)=abs(ga.individual(:,Li,:))-abs(ga.individual(:,Ri,:));
gaLR.individual(:,Ri,:)=abs(ga.individual(:,Ri,:))-abs(ga.individual(:,Li,:));

aliceTtest0(gaLR, 0.4, 1);
vgenTtest0(gaLR, 0.4158, 1,0.001,ga); % Input Nr. 3 = p-value, use fieldtrip-version from BIU
vgenTtest0(gaLR, 0.17, 1,0.01,ga);
vgenTtest0(gaLR, 0.3, 1,0.05,ga);

 
end
