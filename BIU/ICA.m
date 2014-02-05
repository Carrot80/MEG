
function for_all_subjects  

    PatientFolder = 'D:\kirsten_thesis\data\patients\';
    ControlsFolder = 'D:\kirsten_thesis\data\controls\';
    
     SelectSubjects (ControlsFolder)
     SelectSubjects (PatientFolder)
end


function SelectSubjects (Mainfolder)

    List = dir( Mainfolder );

 for i = 1 : size (List)
      if ( 0 == strcmp( List(i,1).name, '.') && 0 == strcmp( List(i,1).name, '..') )
          SubjectPath = strcat(Mainfolder, List(i,1).name) ;
          SubjectName = List(i,1).name  
          
          [Path] = MakePath(SubjectPath, SubjectName)
          ConductICA (SubjectName, Path)
          
      end
 end
 
end

function [Path] = MakePath(SubjectPath, SubjectName)
        
        Path                     = [];
        Path.Subject             = SubjectPath ; 
        Path.DataInput           = strcat ( SubjectPath, '\MEG\01_Input_no_noisereduction')                 ;
        Path.Preprocessing       = strcat ( SubjectPath, '\MEG\02_PreProcessing')          ;
        
end

function ConductICA (SubjectName, Path)

 % Reject all other but ...
        if ( 1 == strcmp (Path.Subject, 'D:\kirsten_thesis\data\controls\zzz_ca') || 1 == strcmp (Path.Subject, 'D:\kirsten_thesis\data\patients\Pat_01_13021km') || 1 == strcmp (Path.Subject, 'D:\kirsten_thesis\data\patients\Pat_12_12041he'))
            return;
        end
  PathComp_ICA = strcat( Path.Preprocessing, filesep, 'comp_ICA.mat');
  
  if exist (PathComp_ICA, 'file')
      return
  end
     
     [fileName]=PathForFileName(SubjectName, Path)   
        
     if isempty(fileName) 
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
   
    
 % filtering Data for PCA- eye blinks according to SSP
    %cfg_trl = [];
    cfg_trl.channel     = 'MEG' ;
    cfg_trl.continuous  = 'yes' ;
    cfg_trl.bpfilter    = 'yes' ;
    cfg_trl.bpfreq      = [1.5 15] ;
    cfg_trl.demean      = 'yes' ; 
    cfg_trl.blcwindow   = [-0.1 0];
    cfg_trl.padding     = 1;
    cfg_trl.dataset     = fileName ;
    DataBp1_15Hz        = ft_preprocessing(cfg_trl) ;
    
       %resampling:
    cfg            = [] ;
    cfg.resamplefs = 300 ;
    cfg.detrend    = 'yes' ;
    DataBp1_15Hz_resampled = ft_resampledata(cfg, DataBp1_15Hz) ;


        % ICA
    cfgc                = [] ;
    cfgc.method         = 'runica';
    comp_ICA            = ft_componentanalysis(cfgc, DataBp1_15Hz_resampled);
    
    
     % plot the components for visual inspection
    figure
    cfg3                = [];
    cfg3.component      = [1:20];       % specify the component(s) that should be plotted
    cfg3.layout         = '4D248.lay'; % specify the layout file that should be used for plotting
    cfg3.comment        = 'no';
    ft_topoplotIC(cfg3, comp_ICA)

    
    
    
    save (PathComp_ICA, 'comp_ICA')
    FigComp_ICA = strcat( Path.Preprocessing, filesep, 'comp_ICA');
    saveas (gcf, FigComp_ICA, 'fig')  ;
    close all
    
    cfgb                = [];
    cfgb.layout         = '4D248.lay';
    cfgb.channel = {comp_ICA.label{1:5}};
    cfg.component       = [1:5];
    comppic             = ft_databrowser(cfgb,comp_ICA);
    
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
    end