
function for_all_subjects  

    PatientFolder = 'D:\kirsten_thesis\data\patients\';
%     ControlsFolder = 'D:\kirsten_thesis\data\controls\';
%     
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
        if ( 0 == strcmp (Path.Subject, 'D:\kirsten_thesis\data\patients\Pat_03_13014bg'))
            return;
        end

%      [fileName]=PathForFileName(SubjectName, Path)   
%         
%      if isempty(fileName) 
%          return
%      end
     
%     File_AVG = strcat (Path.Preprocessing, filesep, 'avg.mat');
%     if exist(File_AVG, 'file')
%         return
%     end

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
    cfg_trl.blcwindow   = [-0.2 -0.1];
    cfg_trl.padding     = 10; % padding of 10seconds works, everything below does not work
    DataBp1_50Hz    = ft_preprocessing(cfg_trl) ;
    
    File_DataBp1_50Hz = strcat (Path.Preprocessing, filesep, 'DataBp1_50Hz.mat');
    save (File_DataBp1_50Hz, 'DataBp1_50Hz')  
    

    cfg                                 = [];
    cfg.method                          = 'summary'; %trial
    cfg.channel                         = 'MEG';
    cfg.alim                            =  1e-12;
    [CleanData, trlsel,chansel] = ft_rejectvisual(cfg, DataBp1_50Hz);
    
       
    cfg                                 = [];
    cfg.method                          = 'summary'; %trial
    cfg.channel                         = 'MEG';
    cfg.alim                            =  1e-12;
    [CleanData_nobadTrls, trlsel2,chansel2] = ft_rejectvisual(cfg, CleanData);
    
%%
    cfgc                = [] ;
    cfgc.method         = 'pca';
    compPCA            = ft_componentanalysis(cfgc, CleanData);
    
    figure
    cfg3                = [];
    cfg3.component      = [1:30];       % specify the component(s) that should be plotted
    cfg3.layout         = '4D248.lay'; % specify the layout file that should be used for plotting
    cfg3.comment        = 'no';
    ft_topoplotIC(cfg3, compPCA)
    
    save compPCA compPCA
    FigComp_PCA = strcat( Path.Preprocessing, filesep, 'compPCA');
    saveas (gcf, FigComp_PCA, 'fig')  ;
    
        % lets view the raw data for one channel
    cfgb                    = [] ;
    cfgb.layout             = '4D248.lay' ;
%     cfgb.continuous         = 'yes' ;
%     cfgb.event.type         = '' ;
%     cfgb.event.sample       = 1 ;
%     cfgb.blocksize          = 3 ;
    cfgb.channel = compPCA.label(1:5);
%     cfgb.channel            = {'A93', 'A39', 'A125', 'A20', 'A65', 'A8', 'A95', 'A114', 'A175', 'A16', 'A228', 'A35', 'A37', 'A64', 'A3', 'A177', 'A63', 'A155', 'A127', 'A67', 'A115', 'A174', 'A194', 'A5', 'A176', 'A38', 'A230', 'A91', 'A212', 'A66', 'A42', 'A96', 'A57', 'A86', 'A56', 'A116', 'A151', 'A120', 'A122', 'A19', 'A62', 'A21', 'A229', 'A84', 'A213', 'A85', 'A146', 'A58', 'A60', 'A88', 'A128', 'A121', 'A4', 'A61', 'A6', 'A126', 'A94', 'A193', 'A150', 'A227', 'A59', 'A36', 'A195', 'A124', 'A40', 'A123', 'A153', 'A178', 'A179', 'A33', 'A147', 'A117', 'A148', 'A87', 'A89', 'A119', 'A92', 'A41', 'A90', 'A7', 'A23', 'A83', 'A154', 'A34', 'A17', 'A18', 'A248', 'A149', 'A118', 'A152'}';
    comppic                 = ft_databrowser(cfgb, compPCA) ;
    
    cfgrc                           = [];
    cfgrc.component                 = [1:5]; % change
    cfgrc.feedback                  = 'no';
    CleanData_rejcomp1    = ft_rejectcomponent(cfgrc, compPCA, CleanData_nobadTrls);
    
    
    cfg                                 = [];
    cfg.method                          = 'trial'; %trial
    cfg.channel                         = 'MEG';
    cfg.alim                            =  1e-12;
    [CleanData_rejcomp1, trlsel2,chansel2] = ft_rejectvisual(cfg, CleanData_rejcomp1);
    
  
    
 %%    
    % now compare trlsel 1 und 2 und berechne 
    
    
     cfgb                    = [] ;
    cfgb.layout             = '4D248.lay' ;
%     cfgb.continuous         = 'yes' ;
%     cfgb.event.type         = '' ;
%     cfgb.event.sample       = 1 ;
%     cfgb.blocksize          = 3 ;
    comppic                 = ft_databrowser(cfgb, CleanData) ;

    File_CleanData = strcat (Path.Preprocessing, filesep, 'CleanData_nobadTrls.mat');
    save (File_CleanData, 'CleanData_nobadTrls')  
    
    File_CleanData = strcat (Path.Preprocessing, filesep, 'CleanData_rejcomp1.mat');
    save (File_CleanData, 'CleanData_rejcomp1')  
    
    File_trlsel = strcat (Path.Preprocessing, filesep, 'trlsel.mat');
    save (File_trlsel, 'trlsel')  
    
    File_trlsel2 = strcat (Path.Preprocessing, filesep, 'trlsel2.mat');
    save (File_trlsel2, 'trlsel2')  
    
    %% create trigger for SAM:  tf wichtig
    
    [tf,loc] = ismember(DataBp1_50Hz.sampleinfo(:,1),CleanData_rejcomp2.sampleinfo(:,1));
    
    
    
    %%
    
    
%      cfg.datafile  = fileName;
%      cfg.headerfile = hdr;
%      cfg.viewmode = 'vertical';
%      test = ft_databrowser(cfg, CleanData)
% %     

    AvgData (SubjectName, Path, CleanData)
    
end


function AvgData (SubjectName, Path, CleanData)

    cfg = [];
    avg = ft_timelockanalysis(cfg, CleanData_nobadTrls);
    
    cfg = [];
    avg = ft_timelockanalysis(cfg, CleanData);

    cfg = [];
    avg = ft_timelockanalysis(cfg, CleanData_rejcomp1);
    
    figure;plot(avg.time,avg.avg)
    title(strcat('avg',' ','-', ' ', SubjectName)); 
    Fig_avg = strcat (Path.Preprocessing, filesep, 'avg.fig');
    saveas(gcf, Fig_avg, 'fig');
    
    avgBL=correctBL(avg,[-0.32 -.02]);
    figure;plot(avgBL.time,avgBL.avg)
    title(strcat('avgBL',' ','-', ' ', SubjectName)); 
    Fig_avgBL = strcat (Path.Preprocessing, filesep, 'avgBL.fig');
    saveas(gcf, Fig_avgBL, 'fig');

    File_AVG = strcat (Path.Preprocessing, filesep, 'avg.mat');
    save (File_AVG, 'avg')  
    
    File_AVGBL = strcat (Path.Preprocessing, filesep, 'avgBL.mat');
    save (File_AVGBL, 'avgBL')  
    
    
    File_AVG = strcat (Path.Preprocessing, filesep, 'avg_rejcomp1.mat');
    save (File_AVG, 'avg')  
    
    File_AVGBL = strcat (Path.Preprocessing, filesep, 'avg_rejcomp1_BL.mat');
    save (File_AVGBL, 'avgBL')  
    
    figure
    cfg = [];
    cfg.interactive = 'yes';
    cfg.xlim = [.4 .4];
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
    cfg.xlim = [0.405 0.405];
    cfg.colorbar = 'yes';
    ft_topoplotER(cfg,avgBL);

    cfg = [];
    figure
    cfg.xlim = [-0.3 1.0];
    ft_singleplotER(cfg,avgBL);



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