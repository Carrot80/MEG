
function for_all_subjects  

    PatientFolder = 'D:\kirsten_thesis\data\patients\';
%     ControlsFolder = 'D:\kirsten_thesis\data\controls\';
    
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
          RemoveMuscle (Path, SubjectName)
          
      end
 end
 
end

function [Path] = MakePath(SubjectPath, SubjectName)
        
        Path                     = [];
        Path.Subject             = SubjectPath ; 
        Path.DataInput           = strcat ( SubjectPath, '\MEG\01_Input_no_noisereduction')                 ;
        Path.Preprocessing       = strcat ( SubjectPath, '\MEG\02_PreProcessing')          ;
        
end

function RemoveMuscle (Path, SubjectName)

 % Reject all other but ...
%         if ( 1 == strcmp (Path.Subject, 'D:\kirsten_thesis\data\controls\zzz_ht'))
%             return;
%         end
        
%      FileNameGoodTrials = strcat(Path.Preprocessing, filesep, 'GoodTrials.mat')
%      if exist(FileNameGoodTrials, 'file')
%          return
%      end
    
     
     [fileName]=PathForFileName(Path, SubjectName)
     

     hdr                     = ft_read_header(fileName) ;
     cfg = [] ;
     cfg.dataset             = fileName ;
     cfg.channel             = 'MEG' ;
     [Data]                  = ft_definetrial(cfg) ;


    cfg         = [];
    cfg.trl     = Data.trl;
    cfg.dataset = fileName;
    cfg.demean  ='yes';
    cfg.baselinewindow = [-0.3 0];
    cfg.channel     ='MEG';
    cfg.hpfilter    = 'yes';
    cfg.hpfreq      = 60;
    cfg.padding     = 1;
    dataHp60=ft_preprocessing(cfg);

%     cfg.method='summary'; %trial
%     dataln=ft_rejectvisual(cfg, dataHp60);
%     goodChannels = dataln.label;
%     goodTrials = dataln.trial;
% 
%     save goodChannels goodChannels;
%     save goodTrials goodTrials;

    cfg=[];
    cfg.method='abs';
    cfg.criterion='sd';
    cfg.critval=3;
    [good,bad]=badTrials(cfg,dataHp60,1)
    
    FileNameGoodTrials = strcat(Path.Preprocessing, filesep, 'GoodTrials_noJumps.mat')
    save (FileNameGoodTrials, 'good')
    FileNameBadTrials = strcat(Path.Preprocessing, filesep, 'Jumps.mat')
    save (FileNameBadTrials, 'bad')
    

  end
      
      

    function      [fileName]=PathForFileName(Path, SubjectName)
        
    % Muscle activity
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
         PathSubdir = strcat(Path.DataInput, filesep, '1')
         if exist (PathSubdir, 'dir')
             PathfileNameHBcor=strcat(PathSubdir, filesep, 'hb_tr_lf_c,rfhp0.1Hz') ;
             PathfileNameHBcorNoTr=strcat(PathSubdir, filesep,'hb_lf_c,rfhp0.1Hz') ;
             PathfileNameNoHBcor=strcat(PathSubdir, filesep,'tr_lf_c,rfhp0.1Hz') ;
             PathfileNameLfcor=strcat(PathSubdir, filesep,'lf_c,rfhp0.1Hz') ;
             
             if exist (PathfileNameHBcor, 'file')
                 fileName = PathfileNameHBcor
                 
             elseif exist (PathfileNameHBcorNoTr, 'file')
                 fileName = PathfileNameHBcorNoTr
              
             elseif exist (PathfileNameNoHBcor, 'file')
                 fileName = PathfileNameNoHBcor
                 
             elseif exist (PathfileNameLfcor, 'file')
                 fileName = PathfileNameLfcor    
                 
                  
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
                 
             else
                return
             
             end
         end
     end
    end

