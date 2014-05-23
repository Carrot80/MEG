
function for_all_subjects  

    PatientFolder = 'D:\kirsten_thesis\data\patients\';
  
    
     SelectSubjects (PatientFolder)
%      SelectSubjects (PatientFolder)
end


function SelectSubjects (Mainfolder)

    List = dir( Mainfolder );
    List(1:2) = [];
    
 for i = 14 : size (List)
%       if ( 0 == strcmp( List(i,1).name, '.') && 0 == strcmp( List(i,1).name, '..') )
          SubjectPath = strcat(Mainfolder, List(i,1).name) ;
          SubjectName = List(i,1).name  
          
          [Path] = MakePath(SubjectPath, SubjectName)
          MEGrealign (SubjectName, Path, i)
           

      end
 end
 


function [Path] = MakePath(SubjectPath, SubjectName)
        
        Path                     = [];
        Path.Subject             = SubjectPath ; 
        Path.DataInput           = strcat ( SubjectPath, '\MEG\01_Input_no_noisereduction')                 ;
        Path.Preprocessing       = strcat ( SubjectPath, '\MEG\02_PreProcessing\')          ;
        
end

function MEGrealign (SubjectName, Path, i)
% 
% if ~exist(strcat(Path.Preprocessing, filesep, 'avgBL.mat'), 'file')
%     return
% end

load (strcat(Path.Preprocessing, 'avgBL.mat'));
origFile = strcat( Path.DataInput, filesep, 'c,rfhp0.1Hz');

% 
% if ~isfield(avgBL, 'grad')
%     return
% end
% 
% if ~exist('avgBL', 'var')
%     return
% end

cfg=[];
cfg.template={avgBL.grad};
hs=ft_read_headshape(origFile);
[o,r]=fitsphere(hs.pnt);
cfg.inwardshift=0.025;
cfg.vol.r=r;cfg.vol.o=o;
% cfg.trials=1;
avgBL_ra=ft_megrealign(cfg,avgBL);


 handles=findall(0,'type','figure')
    for b=1:length(handles)
        FigNum=num2str(b)
        PathFigure = sprintf('%sMEGRealignment%s' , Path.Preprocessing, FigNum);
        h=figure(b)
        saveas(h, PathFigure, 'fig')  
    end
    close all

Path_avgBL_ra = strcat(Path.Preprocessing, filesep, 'avgBL_ra.mat');

save(Path_avgBL_ra, 'avgBL_ra')


 cfg = [];
    cfg.interactive = 'yes';
    cfg.layout = '4D248.lay';
    cfg.colorbar = 'yes';
    cfg.xlim =[.17 .17];
    ft_topoplotER(cfg, avgBL_ra);
    title(strcat(['Patient', ' ', num2str(i)]))
    
    FigName=strcat('D:\kirsten_thesis\data\all\Results_patients\', 'M170_', SubjectName, '.fig')
    saveas(gcf, FigName)
    print('-dpng', strcat('D:\kirsten_thesis\data\all\Results_patients\', 'M170_', SubjectName))

    
    
    cfg = [];
    cfg.interactive = 'yes';
    cfg.layout = '4D248.lay';
    cfg.colorbar = 'yes';
    cfg.xlim =[.4 .4];
    ft_topoplotER(cfg, avgBL_ra);
    title(strcat(['Patient', ' ', num2str(i)]))
    
    FigName=strcat('D:\kirsten_thesis\data\all\Results_patients\', 'M400_', SubjectName, '.fig'); 
    saveas(gcf, FigName)
    print('-dpng', strcat('D:\kirsten_thesis\data\all\Results_patients\', 'M400_', SubjectName))

    PathLRpairs = 'D:\kirsten_thesis\data\all\LRpairs.mat';

    load (PathLRpairs);

    
    ga=avgBL_ra;
    
    [~,Li]=ismember(LRpairs(:,1),ga.label); % ga ) grandaverage with individually kept trials, LRpairs is file from Yuval
    [~,Ri]=ismember(LRpairs(:,2),ga.label);
    gaLR=ga;
    gaLR.avg=zeros(size(gaLR.avg)); % die mittleren Sensoren behalten Nullen
    gaLR.avg(:,Li,:)=abs(ga.avg(:,Li,:))-abs(ga.avg(:,Ri,:));
    gaLR.avg(:,Ri,:)=abs(ga.avg(:,Ri,:))-abs(ga.avg(:,Li,:));


    % compute RMS => not necessary for planar gradiometer
    rmsL=sqrt(mean(ga.avg(Li,:).^2));
    rmsR=sqrt(mean(ga.avg(Ri,:).^2));     
    rmsbothHem=sqrt(mean(ga.avg(:,:,:).^2));
   
%     set(0,'DefaultFigureWindowStyle','docked' )   
    figure('Position', [1 1 1119 198]); plot(ga.time,rmsL,'color','r','LineWidth',2)
    hold on
    plot(ga.time,rmsR,'LineWidth',2)
    set (gcf, 'OuterPosition', [5 5 1119 298]); legend('L','R')
    title(strcat(['RMS Patient', ' ', num2str(i)]))
    legend('Location','NorthEast');legend('boxoff');
    axis tight; box off
    print('-dpng', strcat('D:\kirsten_thesis\data\all\Results_patients\', 'RMS_', SubjectName))
    FigName2=strcat('D:\kirsten_thesis\data\all\Results_patients\', 'RMS_', SubjectName, '.fig')
    saveas(gcf, FigName2)

%     scrsz = get(0,'ScreenSize');
%    figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])

    
    
    

end