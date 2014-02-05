    figure
    cfg3                = [];
    cfg3.component      = [1:20];       % specify the component(s) that should be plotted
    cfg3.layout         = '4D248.lay'; % specify the layout file that should be used for plotting
    cfg3.comment        = 'no';
    ft_topoplotIC(cfg3, comp_ICA)
    
     cfgb                = [];
    cfgb.layout         = '4D248.lay';
    cfgb.channel = {comp_ica.label{1:5}};
    cfg.component       = [1:5];
    comppic             = ft_databrowser(cfgb,comp_ica);
    
    %%
    fileName = 'hb_tr_lf_c,rfhp0.1Hz';
    
    startt                  = 1 ;
    endt                    = 600 ;
    cfg                     = [] ;
    cfg.dataset             = fileName ;
    cfg.trialdef.beginning  = startt ;
    cfg.trialdef.end        = endt ;
    cfg.trialfun            = 'trialfun_raw' ; % the other usefull trialfun we have are trialfun_beg and trialfun_BIU
    cfg1                    = ft_definetrial(cfg) ;

    cfg1.channel            = 'MEG' ;
    cfg1.continuous         = 'yes' ;
    cfg1.bpfilter           = 'yes' ;
    cfg1.bpfreq             = [1.5 15] ;
    cfg1.demean             = 'yes' ; % old version was: cfg1.blc='yes';
    MOG                     = ft_preprocessing(cfg1);
    
    findBadChans(fileName);
    
    % lets view the raw data for one channel
    cfgb                    = [] ;
    cfgb.layout             = '4D248.lay' ;
    cfgb.continuous         = 'yes' ;
    cfgb.event.type         = '' ;
    cfgb.event.sample       = 1 ;
    cfgb.blocksize          = 3 ;
%     cfgb.channel            = {'A170'; 'A171';'A172';'A173';'A174';'A175';'A176';'A177';'A178';'A179';'A180';};
     cfgb.channel            = {'A227'; 'A228';'A229';};
    comppic                 = ft_databrowser(cfgb, MOG) ;