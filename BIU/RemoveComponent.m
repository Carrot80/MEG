
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
          RemoveComp (SubjectName, Path)
          
      end
 end
 
end

function [Path] = MakePath(SubjectPath, SubjectName)
        
        Path                     = [];
        Path.Subject             = SubjectPath ; 
        Path.DataInput           = strcat ( SubjectPath, '\MEG\01_Input_no_noisereduction')                 ;
        Path.Preprocessing       = strcat ( SubjectPath, '\MEG\02_PreProcessing')          ;
        
end


function RemoveComp (SubjectName, Path)

 % Reject all other but ...
        if ( 0 == strcmp (Path.Subject, 'D:\kirsten_thesis\data\controls\zzz_ca'))
            return;
        end

%   PathComp_ICA = strcat( Path.Preprocessing, filesep, 'comp_ICA.mat');
  
%   if exist (PathComp_ICA, 'file')
%       return
%   end
%      
     [fileName]=PathForFileName(SubjectName, Path)   
        
     if isempty(fileName) 
         return
     end



    % define trials:
    hdr                     = ft_read_header(fileName) ;
    cfg                     = [];
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
    
    Path_DataBp1_50Hz = strcat (Path.Preprocessing, filesep, 'DataBp1_50Hz.mat');
    save (Path_DataBp1_50Hz, 'DataBp1_50Hz')  
    save DataBp1_50Hz DataBp1_50Hz
    
    cfg                                 = [];
    cfg.method                          = 'summary'; %trial
    cfg.channel                         = 'MEG';
    cfg.alim                            =  1e-12;
    [data_no_blinks_rejvisual, trlsel,chansel] = ft_rejectvisual(cfg, data_no_blinks);
     
    cfgrc                           = [];
    cfgrc.component                 = blink_compICA; % change
    cfgrc.feedback                  = 'no';
    data_no_blinks    = ft_rejectcomponent(cfgrc, comp_ICA, DataBp1_50Hz);
    
    save data_no_blinks data_no_blinks
    save blink_compICA blink_compICA  
%     
    
    

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