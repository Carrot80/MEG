
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
            T1 = .4; 
            T2 = .6;
          [Path] = MakePath(SubjectPath, SubjectName);
          RMS_ind (Path, SubjectName, T1, T2 );
           

      end
 end
 
end

function RMS_ind (Path, SubjectName, T1, T2)


    PathLRpairs = 'D:\kirsten_thesis\data\all\LRpairs.mat';

    load (PathLRpairs);

    PathAVG = strcat(Path.SensorLevelAnalysis, filesep, 'avgBL_ra.mat');
    load (PathAVG);

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
   
        
    figure;plot(ga.time,rmsL,'r')
    hold on
    plot(ga.time,rmsR)
    legend('L','R')
    title(strcat('RMS_', SubjectName));
    
 
    
    sT1=nearest(ga.time,T1); % BIU_fieldtrip has to be added
    sT2=nearest(ga.time,T2);
    p=ones(1, length(rmsL));
    si=sT1:sT2
   [h,p,ci,stats] = ttest(rmsL(:,si),rmsR(:,si)); % BIU_fieldtrip has to be added

    PathFig = strcat (Path.SensorLevelAnalysis, filesep, 'RMS_ind');
    cd (Path.SensorLevelAnalysis)
    saveas (gcf, PathFig, 'fig')
    print ('-dpng', PathFig) ; 
    
end



function [Path] = MakePath(SubjectPath, SubjectName)
        
        Path                     = [];
        Path.Subject             = SubjectPath ; 
        Path.DataInput           = strcat ( SubjectPath, '\MEG\01_Input_no_noisereduction')                 ;
        Path.Preprocessing       = strcat ( SubjectPath, '\MEG\02_PreProcessing')          ;
        Path.SensorLevelAnalysis       = strcat ( SubjectPath, '\MEG\SensorLevelAnalysis')          ;
        
end