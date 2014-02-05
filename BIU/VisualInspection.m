
   
    % cfg.trials=find(ismember(trl(:,1),datacln.sampleinfo(:,1)));
    % now: reject visual (summary) and averaging
    
    cfg                                 = [];
    cfg.method                          = 'summary'; %trial
    cfg.channel                         = 'MEG';
    cfg.alim                            =  1e-12;
    [data_no_blinks_rejvisual, trlsel,chansel] = ft_rejectvisual(cfg, data_no_blinks);
    



 

   
    % lets view the raw data for one channel
    cfgb                    = [] ;
    cfgb.layout             = lay ;
    cfgb.continuous         = 'yes' ;
    cfgb.event.type         = '' ;
    cfgb.event.sample       = 1 ;
    cfgb.blocksize          = 3 ;
    cfgb.channel            = 'A245';
    comppic                 = ft_databrowser(cfgb, DataBp1_15Hz_resampled) ;


