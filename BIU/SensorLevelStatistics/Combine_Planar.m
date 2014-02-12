
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
          CombinePlanar (SubjectName, Path)
           

      end
 end
 
end

function [Path] = MakePath(SubjectPath, SubjectName)
        
        Path                     = [];
        Path.Subject             = SubjectPath ; 
        Path.DataInput           = strcat ( SubjectPath, '\MEG\01_Input_no_noisereduction')                 ;
        Path.Preprocessing       = strcat ( SubjectPath, '\MEG\02_PreProcessing\') ;
        Path.SensorLevelAnalysis = strcat ( SubjectPath, '\MEG\SensorLevelAnalysis\');
end

%%
function CombinePlanar (SubjectName, Path)

% Compute planar gradient (megplanar) to reduce noise.
% 
% Relies on dipole topography. One subject, M400.

load (strcat(Path.SensorLevelAnalysis, 'avgBL_ra.mat'));

cfg=[];
cfg.method = 'distance';
cfg.feedback ='yes'; 
neighbours = ft_prepare_neighbours(cfg, avgBL_ra)


cfg=[];
cfg.planarmethod   = 'orig';
cfg.neighbours     = neighbours;
[interp] = ft_megplanar(cfg, avgBL_ra);

cfg=[];
cfg.combinegrad  = 'yes';
avgBL_ra_planar = ft_combineplanar(cfg, interp)

cfgp = [];
cfgp.xlim=[0.4 0.4]; % change
cfgp.layout = '4D248.lay';
figure;
ft_topoplotER(cfgp,avgBL_ra_planar)
title(strcat('planar',' - ',SubjectName))
figure;
ft_topoplotER(cfgp,avgBL_ra)
title(strcat('raw',' - ',SubjectName))


 handles=findall(0,'type','figure')
    for i=1:length(handles)
        FigNum=num2str(i)
        PathFigure = sprintf('%sMEGPlanar%s' , Path.SensorLevelAnalysis, FigNum);
        h=figure(i)
        saveas(h, PathFigure, 'fig')  
    end
    close all


Path_avgBL_ra_planar = strcat(Path.SensorLevelAnalysis, 'avgBL_ra_planar');

save(Path_avgBL_ra_planar, 'avgBL_ra_planar')



end
