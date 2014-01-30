fileName = 'hb_lf_c,rfhp0.1Hz'

% define trials:
    hdr                     = ft_read_header(fileName) ;
    cfg.dataset     = fileName ;
    cfg.channel     = 'MEG' ;
    [Data]                  = ft_definetrial(cfg) ;
    
    cfg = [];
    cfg.channel     = 'MEG' ;
    cfg.bpfilter    = 'yes' ;
    cfg.bpfreq      = [1 50] ;
    cfg.demean = 'yes';
    cfg.blcwindow = [-0.1 0];
    cfg.padding     = 1;
    

    DataBp1_50Hz             = ft_preprocessing(Data) ;
    
  
         %% for one segment:
     
     startt                  = 1 ;
    endt                    = 600 ;
    cfg                     = [] ;
    cfg.dataset             = fileName ;
    cfg.trialdef.beginning  = startt ;
    cfg.trialdef.end        = endt ;
    cfg.trialfun            = 'trialfun_raw' ; % the other usefull trialfun we have are trialfun_beg and trialfun_BIU
    cfg1                    = ft_definetrial(cfg) ;

    cfg1.channel            = Data.label ;
    cfg1.continuous         = 'yes' ;
    cfg1.bpfilter           = 'yes' ;
    cfg1.bpfreq             = [1.5 15] ;
    cfg1.demean             = 'yes' ; % old version was: cfg1.blc='yes';
    EOG                     = ft_preprocessing(cfg1);
    
    % lets view the raw data for one channel
    cfgb                    = [] ;
    cfgb.layout             = lay ;
    cfgb.continuous         = 'yes' ;
    cfgb.event.type         = '' ;
    cfgb.event.sample       = 1 ;
    cfgb.blocksize          = 3 ;
    cfgb.channel            = 'A245';
    comppic                 = ft_databrowser(cfgb, EOG) ;



    % PCA
    cfgc                = [] ;
    cfgc.method         = 'pca';
    comp_PCA_600s      = ft_componentanalysis(cfgc, EOG);

    cfg_lay         = [];
    cfg_lay.grad    = comp_PCA_100s.grad;
    lay             = ft_prepare_layout(cfg_lay);
    
    
    
        % ICA
    cfgc                = [] ;
    cfgc.method         = 'runica';
    comp_ICA_100s       = ft_componentanalysis(cfgc, MOG);
    File_comp_ICA_100s  = strcat (Path.Preprocessing, '\', 'comp_ICA_100s') ;
    save (File_comp_ICA_100s, 'comp_ICA_100s')
    % see the components and find the HB and MOG artifact
    % remember the numbers of the bad components and close the data browser
    
    
     %%
    
    cfgrc                           = [];
    cfgrc.component                 = [1 2 4]; % change
    cfgrc.feedback                  = 'no';
    data_no_blinks    = ft_rejectcomponent(cfgrc, comp_PCA_100s, DataBp1_50Hz);
    
    save data_no_blinks data_no_blinks
    
    
   
    
    % now: reject visual (summary) and averaging
    
    cfg                                 = [];
    cfg.method                          = 'summary'; %trial
    cfg.channel                         = 'MEG';
    cfg.alim                            =  1e-12;
    [data_no_blinks_rejvisual, trlsel,chansel] = ft_rejectvisual(cfg, data_no_blinks);
    
    save chansel chansel
    save trlsel trlsel
    goodTrials = data_no_blinks_rejvisual.trial;

save goodChannels goodChannels;
save goodTrials goodTrials;

%% average:
trl=DataBp1_50Hz.trial
trl=trl(trlsel==1)
DataBp1_50Hz.trial=trl


cfg = [];
avg = ft_timelockanalysis(cfg, DataBp1_50Hz);

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





% Yuval:
avgBL=correctBL(avg,[-0.1,0]);
figure
ft_singleplotER(cfg,avgBL);
cfg
cfg=rmfield(cfg,'ylim');
ft_singleplotER(cfg,avgBL);

    %%
    
    
    % preprocessing
    cfg_preproc = [];
    cfg_preproc.channel     = 'MEG' ;
    cfg_preproc.continuous  = 'yes' ;
    cfg_preproc.bpfilter    = 'yes' ;
    cfg_preproc.bpfreq      = [1.5 15] ;
    

    DataBp1_15Hz             = ft_preprocessing(Data) ;

    %resampling:
    cfg            = [] ;
    cfg.resamplefs = 300 ;
    cfg.detrend    = 'yes' ;
    DataBp1_15Hz_resampled = ft_resampledata(cfg, DataBp1_15Hz) ;

   
    % lets view the raw data for one channel
    cfgb                    = [] ;
    cfgb.layout             = lay ;
    cfgb.continuous         = 'yes' ;
    cfgb.event.type         = '' ;
    cfgb.event.sample       = 1 ;
    cfgb.blocksize          = 3 ;
    cfgb.channel            = 'A245';
    comppic                 = ft_databrowser(cfgb, DataBp1_15Hz_resampled) ;

    % PCA
    cfgc                = [] ;
    cfgc.method         = 'pca';
    comp_PCA      = ft_componentanalysis(cfgc, DataBp1_15Hz_resampled);

    cfg_lay         = [];
    cfg_lay.grad    = comp_PCA.grad;
    lay             = ft_prepare_layout(cfg_lay);
    
    % see the components and find the HB and MOG artifact
    % remember the numbers of the bad components and close the data browser

    
    % plot the components for visual inspection
    figure
    cfg3                = [];
    cfg3.component      = [1:10];       % specify the component(s) that should be plotted
    cfg3.layout         = lay; % specify the layout file that should be used for plotting
    cfg3.comment        = 'no';
    ft_topoplotIC(cfg3, comp_PCA)

    % http://fieldtrip.fcdonders.nl/tutorial/layout:
    
    cfgb                = [];
    cfgb.layout         = lay;
    %cfgb.channel = {comp.label{1:5}};
    cfg.component       = [1:5];
    cfgb.continuous     = 'yes';
    cfgb.event.type     = '';
    cfgb.event.sample   = 1;
    cfgb.blocksize      = 3;
    comppic             = ft_databrowser(cfgb,comp_PCA);
    
    


    
    % plot the components for visual inspection
    figure
    cfg3                = [];
    cfg3.component      = [1:10];       % specify the component(s) that should be plotted
    cfg3.layout         = lay; % specify the layout file that should be used for plotting
    cfg3.comment        = 'no';
    ft_topoplotIC(cfg3, comp_PCA_600s)

    save comp_PCA_600s comp_PCA_600s
    
    % http://fieldtrip.fcdonders.nl/tutorial/layout:
    
    cfgb                = [];
    cfgb.layout         = lay;
    %cfgb.channel = {comp.label{1:5}};
    cfg.component       = [1:5];
    cfgb.continuous     = 'yes';
    cfgb.event.type     = '';
    cfgb.event.sample   = 1;
    cfgb.blocksize      = 3;
    comppic             = ft_databrowser(cfgb,comp_PCA_600s);
    
    
   
    

