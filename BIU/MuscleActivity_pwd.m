fileName =  'hb_tr_lf_c,rfhp0.1Hz';


    hdr                     = ft_read_header(fileName) ;
     cfg = [] ;
     cfg.dataset             = fileName ;
     cfg.channel             = 'MEG' ;
     [Data]                  = ft_definetrial(cfg) ;

     
    hdr                     = ft_read_header(fileName) ;
     cfg = [] ;
     cfg.dataset             = fileName ;
     cfg.channel             = 'MEG' ;

    cfg.trl     = Data.trl;
    cfg.dataset = fileName;
    cfg.demean  ='yes';
    cfg.baselinewindow = [-0.3 0];
    cfg.channel     ='MEG';
    cfg.hpfilter    = 'yes';
    cfg.hpfreq      = 60;
    cfg.padding     = 10;
    dataHp60=ft_preprocessing(cfg);
    
    cfg=[];
    cfg.method='abs';
    cfg.criterion='sd';
    cfg.critval=3;
    [good,bad]=badTrials(cfg,dataHp60,1)
    save BadTrials bad
    save GoodTrials good