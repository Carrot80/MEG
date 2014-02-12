
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
          MEGrealign (SubjectName, Path)
           

      end
 end
 
end

function [Path] = MakePath(SubjectPath, SubjectName)
        
        Path                     = [];
        Path.Subject             = SubjectPath ; 
        Path.DataInput           = strcat ( SubjectPath, '\MEG\01_Input_no_noisereduction')                 ;
        Path.Preprocessing       = strcat ( SubjectPath, '\MEG\02_PreProcessing\')          ;
        
end

function MEGrealign (SubjectName, Path)

load (strcat(Path.Preprocessing, filesep, 'avgBL.mat'));
origFile = strcat( Path.DataInput, filesep, 'c,rfhp0.1Hz');

cfg=[];
cfg.template={avgBL.grad};
hs=ft_read_headshape(origFile);
[o,r]=fitsphere(hs.pnt);
cfg.inwardshift=0.025;
cfg.vol.r=r;cfg.vol.o=o;
% cfg.trials=1;
avgBL_ra=ft_megrealign(cfg,avgBL);


 handles=findall(0,'type','figure')
    for i=1:length(handles)
        FigNum=num2str(i)
        PathFigure = sprintf('%sMEGRealignment%s' , Path.Preprocessing, FigNum);
        h=figure(i)
        saveas(h, PathFigure, 'fig')  
    end
    close all


Path_avgBL_ra = strcat(Path.Preprocessing, filesep, 'avgBL_ra');

save(Path_avgBL_ra, 'avgBL_ra')


end