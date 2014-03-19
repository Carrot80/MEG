
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


function ConductPCA (SubjectPath, SubjectName)


 % Reject all other but ...
        if ( 0 == strcmp (Path.Subject, 'D:\kirsten_thesis\data\controls\zzz_ca') || 1 == strcmp (Path.Subject, 'D:\kirsten_thesis\data\patients\Pat_01_13021km') || 1 == strcmp (Path.Subject, 'D:\kirsten_thesis\data\patients\Pat_21_13056hz'))
            return;
        end
  PathComp_PCA = strcat( Path.Preprocessing, filesep, 'comp_PCA.mat');
  
%   if exist (PathComp_PCA, 'file')
%       return
%   end
     
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

    cfg_trl.channel     = 'MEG' ;
    cfg_trl.continuous  = 'yes' ;
    cfg_trl.bpfilter    = 'yes' ;
    cfg_trl.bpfreq      = [1.5 15] ;
    cfg_trl.demean      = 'yes' ; 
    cfg_trl.blcwindow   = [-0.2 -0.1];
    cfg_trl.padding     = 10;

    DataBp1_15Hz        = ft_preprocessing(cfg_trl) ;
  
         
    
    % lets view the raw data for one channel
%     cfgb                    = [] ;
%     cfgb.layout             = '4D248.lay' ;
%     cfgb.continuous         = 'yes' ;
%     cfgb.event.type         = '' ;
%     cfgb.event.sample       = 1 ;
%     cfgb.blocksize          = 3 ;
%     cfgb.channel            = {'A93', 'A39', 'A125', 'A20', 'A65', 'A8', 'A95', 'A114', 'A175', 'A16', 'A228', 'A35', 'A37', 'A64', 'A3', 'A177', 'A63', 'A155', 'A127', 'A67', 'A115', 'A174', 'A194', 'A5', 'A176', 'A38', 'A230', 'A91', 'A212', 'A66', 'A42', 'A96', 'A57', 'A86', 'A56', 'A116', 'A151', 'A120', 'A122', 'A19', 'A62', 'A21', 'A229', 'A84', 'A213', 'A85', 'A146', 'A58', 'A60', 'A88', 'A128', 'A121', 'A4', 'A61', 'A6', 'A126', 'A94', 'A193', 'A150', 'A227', 'A59', 'A36', 'A195', 'A124', 'A40', 'A123', 'A153', 'A178', 'A179', 'A33', 'A147', 'A117', 'A148', 'A87', 'A89', 'A119', 'A92', 'A41', 'A90', 'A7', 'A23', 'A83', 'A154', 'A34', 'A17', 'A18', 'A248', 'A149', 'A118', 'A152'}';
%     comppic                 = ft_databrowser(cfgb, DataBp1_15Hz) ;



    % PCA
    cfgc                = [] ;
    cfgc.method         = 'pca';
    compPCA_1_15Hz            = ft_componentanalysis(cfgc, DataBp1_15Hz);


      % plot the components for visual inspection
    figure
    cfg3                = [];
    cfg3.component      = [1:30];       % specify the component(s) that should be plotted
    cfg3.layout         = '4D248.lay'; % specify the layout file that should be used for plotting
    cfg3.comment        = 'no';
    ft_topoplotIC(cfg3, compPCA_1_15Hz)

    save (PathComp_PCA, 'compPCA')
    FigComp_PCA = strcat( Path.Preprocessing, filesep, 'compPCA');
    saveas (gcf, FigCompPCA, 'fig')  ;
    close all
    
%     
%     cfgb                = [];
%     cfgb.layout         = lay;
%     cfgb.channel = {comp_PCA.label{1:5}};
%     cfg.component       = [1:5];
%     comppic             = ft_databrowser(cfgb,comp_PCA);
%     


    

    
   
    

