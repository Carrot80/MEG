
function for_all_subjects  

    PatientFolder = 'D:\kirsten_thesis\data\patients\';
    ControlsFolder = 'D:\kirsten_thesis\data\controls\';
    
%      SelectSubjects (ControlsFolder)
     SelectSubjects (PatientFolder)
end


function SelectSubjects (Mainfolder)

    List = dir( Mainfolder );

 for i = 1 : size (List)
      if ( 0 == strcmp( List(i,1).name, '.') && 0 == strcmp( List(i,1).name, '..') )
          SubjectPath = strcat(Mainfolder, List(i,1).name) ;
          SubjectName = List(i,1).name  
          
          [Path] = MakePath(SubjectPath, SubjectName)
          FilterData (SubjectName, Path)
           

      end
 end
 
end

function [Path] = MakePath(SubjectPath, SubjectName)
        
        Path                     = [];
        Path.Subject             = SubjectPath ; 
        Path.DataInput           = strcat ( SubjectPath, '\MEG\01_Input_no_noisereduction')                 ;
        Path.Preprocessing       = strcat ( SubjectPath, '\MEG\02_PreProcessing')          ;
        
end


function FilterData (SubjectName, Path)

 % Reject all other but ...
        if ( 0 == strcmp (Path.Subject, 'D:\kirsten_thesis\data\patients\Pat_04_13015st'))
            return;
        end

     [fileName]=PathForFileName(SubjectName, Path)   
        
     if isempty(fileName) 
         return
     end
     
    File_AVG = strcat (Path.Preprocessing, filesep, 'avg.mat');
    if exist(File_AVG, 'file')
        return
    end

% define trials:
    hdr                     = ft_read_header(fileName) ;
    cfg=[];
    cfg.dataset             = fileName ;
    cfg.channel             = 'MEG' ;
    [cfg_trl]               = ft_definetrial(cfg) ;
    
    PathBadTrials = strcat(Path.Preprocessing, filesep, 'BadTrials.mat');
    load(PathBadTrials);
    cfg_trl.trl(bad,:)=[];

    
    cfg_trl.channel     = 'MEG' ;
    cfg_trl.bpfilter    = 'yes' ;
    cfg_trl.bpfreq      = [1 50] ;
    cfg_trl.demean      = 'yes';
    cfg_trl.blcwindow   = [-0.1 0];
    cfg_trl.padding     = 1;
    DataBp1_50Hz    = ft_preprocessing(cfg_trl) ;
    
    File_DataBp1_50Hz = strcat (Path.Preprocessing, filesep, 'DataBp1_50Hz.mat');
    save (File_DataBp1_50Hz, 'DataBp1_50Hz')  
    

    cfg                                 = [];
    cfg.method                          = 'summary'; %trial
    cfg.channel                         = 'MEG';
    cfg.alim                            =  1e-12;
    [CleanData, trlsel,chansel] = ft_rejectvisual(cfg, DataBp1_50Hz);
    
    File_CleanData = strcat (Path.Preprocessing, filesep, 'CleanData.mat');
    save (File_CleanData, 'CleanData')  
    
    File_trlsel = strcat (Path.Preprocessing, filesep, 'trlsel.mat');
    save (File_trlsel, 'trlsel')  
    
%      cfg.datafile  = fileName;
%      cfg.headerfile = hdr;
%      cfg.viewmode = 'vertical';
%      test = ft_databrowser(cfg, CleanData)
% %     

    AvgData (SubjectName, Path, CleanData)
    
end


function AvgData (SubjectName, Path, CleanData)

    cfg = [];
    avg = ft_timelockanalysis(cfg, CleanData);
    
    figure;plot(avg.time,avg.avg)
    title(strcat('avg',' ','-', ' ', SubjectName)); 
    Fig_avg = strcat (Path.Preprocessing, filesep, 'avg.fig');
    saveas(gcf, Fig_avg, 'fig');
    
    avgBL=correctBL(avg,[-0.3 0]);
    figure;plot(avgBL.time,avgBL.avg)
    title(strcat('avgBL',' ','-', ' ', SubjectName)); 
    Fig_avgBL = strcat (Path.Preprocessing, filesep, 'avgBL.fig');
    saveas(gcf, Fig_avgBL, 'fig');

    File_AVG = strcat (Path.Preprocessing, filesep, 'avg.mat');
    save (File_AVG, 'avg')  
    
    File_AVGBL = strcat (Path.Preprocessing, filesep, 'avgBL.mat');
    save (File_AVGBL, 'avgBL')  
    
    figure
    cfg = [];
    cfg.interactive = 'yes';
    ft_topoplotER(cfg, avgBL);
    Fig_topoAVG = strcat (Path.Preprocessing, filesep, 'TopoAVG.fig');
    saveas(gcf, Fig_topoAVG, 'fig');

%     trl=DataBp1_50Hz.trial
%     trl=trl(trlsel==1)
%     DataBp1_50Hz.trial=trl
%     cfg=rmfield(cfg,'ylim');
%     ft_singleplotER(cfg,avgBL);
%   

    

    % plot:
    figure
    cfg = [];
    cfg.xlim = [0.2 0.4];
    cfg.colorbar = 'yes';
    ft_topoplotER(cfg,avg);

    cfg = [];
    figure
    cfg.xlim = [-0.3 1.0];
    ft_singleplotER(cfg,avg);



    % 
   

    % Yuval:
    
end


    function      [fileName]=PathForFileName(SubjectName, Path)
        
   
     PathfileNameHBcor=strcat(Path.DataInput, filesep,'hb_tr_lf_c,rfhp0.1Hz') ;
     PathfileNameHBcorNoTr=strcat(Path.DataInput, filesep,'hb_lf_c,rfhp0.1Hz') ;
     PathfileNameNoHBcor=strcat(Path.DataInput, filesep,'tr_lf_c,rfhp0.1Hz') ;
     PathfileNameLfcor=strcat(Path.DataInput, filesep,'lf_c,rfhp0.1Hz') ;

     if exist (PathfileNameHBcor, 'file')
         fileName=PathfileNameHBcor;
     elseif exist (PathfileNameHBcorNoTr, 'file')
         fileName=PathfileNameHBcorNoTr;
     elseif exist(PathfileNameNoHBcor, 'file')
         fileName=PathfileNameNoHBcor;
     elseif exist(PathfileNameLfcor, 'file')
         fileName=PathfileNameLfcor
         
     else 
         
         fileName = [];
     end
%          PathSubdir = strcat(Path.DataInput, filesep, '1')
%          if exist (PathSubdir, 'dir')
%              PathfileNameHBcor=strcat(PathSubdir, filesep, 'hb_tr_lf_c,rfhp0.1Hz') ;
%              PathfileNameHBcorNoTr=strcat(PathSubdir, filesep,'hb_lf_c,rfhp0.1Hz') ;
%              PathfileNameNoHBcor=strcat(PathSubdir, filesep,'tr_lf_c,rfhp0.1Hz') ;
%              PathfileNameLfcor=strcat(PathSubdir, filesep,'lf_c,rfhp0.1Hz') ;
%              
%              if exist (PathfileNameHBcor, 'file')
%                  fileName = PathfileNameHBcor
%                  
%              elseif exist (PathfileNameHBcorNoTr, 'file')
%                  fileName = PathfileNameHBcorNoTr
%               
%              elseif exist (PathfileNameNoHBcor, 'file')
%                  fileName = PathfileNameNoHBcor
                 
%      elseif exist (PathfileNameLfcor, 'file')
%                  fileName = PathfileNameLfcor    
                 
                  
%          else 
%              PathSubdir = strcat(Path.DataInput, filesep, '2')
%              
%          if exist (PathSubdir, 'dir')
%              PathfileNameHBcor=strcat(PathSubdir, filesep, 'hb_tr_lf_c,rfhp0.1Hz') ;
%              PathfileNameHBcorNoTr=strcat(PathSubdir, filesep,'hb_lf_c,rfhp0.1Hz') ;
%              PathfileNameNoHBcor=strcat(PathSubdir, filesep,'tr_lf_c,rfhp0.1Hz') ;
%              PathfileNameLfcor=strcat(PathSubdir, filesep,'lf_c,rfhp0.1Hz') ;
%              
%              if exist (PathfileNameHBcor, 'file')
%                  fileName = PathfileNameHBcor
%                  
%              elseif exist (PathfileNameHBcorNoTr, 'file')
%                  fileName = PathfileNameHBcorNoTr
%               
%              elseif exist (PathfileNameNoHBcor, 'file')
%                  fileName = PathfileNameNoHBcor
%                  
%              elseif exist (PathfileNameLfcor, 'file')
%                  fileName = PathfileNameLfcor    
                 
         
    end