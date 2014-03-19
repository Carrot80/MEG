  
    
    %% 
    
    cfg            = [] ;
    cfg.resamplefs = 300 ;
    cfg.detrend    = 'yes' ;
    CleanData_resampled = ft_resampledata(cfg, CleanData) ;
    
    cfgc                = [] ;
    cfgc.method         = 'runica';
    comp_ICA            = ft_componentanalysis(cfgc, CleanData_resampled);
    save comp_ICA comp_ICA
    
    figure
    cfg3                = [];
    cfg3.component      = [1:20];       % specify the component(s) that should be plotted
    cfg3.layout         = '4D248.lay'; % specify the layout file that should be used for plotting
    cfg3.comment        = 'no';
    ft_topoplotIC(cfg3, comp_ICA)
    
    
    cfgb                = [];
    cfgb.layout         = '4D248.lay';
    cfgb.channel = {comp_ICA.label{1:5}};
    cfg.component       = [13:16];
    comppic             = ft_databrowser(cfgb,comp_ICA);
    
    % nach der ICA wird diese gemittelt:
    cfg = [];
    avgComp = ft_timelockanalysis([],comp_ICA );
    figure;plot( avgComp.time,avgComp.avg);
    
    % Suche nach Komponenten, die ERP in interessierenden Zeitintervall aufweisen und somit ein gutes SNR aufweisen 
    
    tw=[nearest(avgComp.time,0.1),nearest(avgComp.time,0.3)];
    bl=[nearest(avgComp.time,-.2),nearest(avgComp.time,0)];  % zur baseline correction
    avgCom_tw = mean(abs(avgComp.avg(:,tw(1):tw(2))),2)./mean(abs(avgComp.avg(:,bl(1):bl(2))),2); 
    figure; plot(avgCom_tw, '.');
    
    % nur die Komponenten nehmen, die SNR über 1.5 aufweisen: 
    [a,b]=sort(avgCom_tw); % erst einmal sortieren
    
    % finde Komponenten, die SNR größer1.5 aufweisen
    KompSNR = find(a>1.3);
    size(KompSNR,1)
    
%     KompSNR1_5 = find(a>1.5);
%     size(KompSNR1_5,1)
    
%     figure; plot(avgComp.time,avgComp.avg(b(end-9:end),:)); % plotte die zehn Komponenten mit besten SNR
%     figure; plot(avgComp.time,avgComp.avg(b(end-19:end-10),:)); % plotte die nächsten 10 Komponenten mit besten SNR
    figure; plot(avgComp.time,avgComp.avg(b(end-size(KompSNR,1):end),:));
%     figure; plot(avgComp.time,avgComp.avg(b(end-size(KompSNR1_5,1):end),:));
        
%     BadCompSNR=setdiff(1:248, b(end-size(KompSNR,1):end));
%     BadCompSNR1_5=setdiff(1:248, b(end-size(KompSNR1_5,1):end));
    
    GoodCompSNR = setdiff(1:248, BadCompSNR);
%     GoodCompSNR1_5 = setdiff(1:248, BadCompSNR1_5);
    
    % reject bad Components:
    cfgrc                           = [];
    cfgrc.component                 = BadCompSNR; % change
    cfgrc.feedback                  = 'no';
    DataSNR    = ft_rejectcomponent(cfgrc, comp_ICA, CleanData_nobadTrls);
    
%     cfgrc                           = [];
%     cfgrc.component                 = BadCompSNR1_5; % change
%     DataSNR1_5    = ft_rejectcomponent(cfgrc, comp_ICA, CleanData_nobadTrls);
    
    
    
    
    %% ab hier verwenden:
    
    cfg                                 = [];
    cfg.method                          = 'trial'; %trial
    cfg.channel                         = 'MEG';
    cfg.alim                            =  1e-12;
    [CleanDataSNR1_5, trlsel,chansel] = ft_rejectvisual(cfg, DataSNR);
    save CleanDataSNR1_5 CleanDataSNR1_5
    
    
    % nach der ICA wird die ICA gemittelt:
    cfg = [];
    avgSNR1_3 = ft_timelockanalysis([],CleanDataSNR );
    avgSNR1_5BL=correctBL(avgSNR1_5,[-0.32 -.02]);
    figure;plot( avgSNR1_5.time,avgSNR1_5.avg);
    save avgSNR1_5BL avgSNR1_5BL
    
    figure
    cfg = [];
    cfg.interactive = 'yes';
    cfg.xlim = [.4 .4];
    ft_topoplotER(cfg, avgSNR1_5BL);
    
    
    
    cfg = [];
    avgSNR1_5 = ft_timelockanalysis([],DataSNR1_5 );
    avgSNR1_5BL=correctBL(avgSNR1_5,[-0.32 -.02]);
    figure;plot( avgSNR1_5BL.time,avgSNR1_5BL.avg);
    

    figure
    cfg = [];
    cfg.interactive = 'yes';
    cfg.xlim = [.4 .4];
    ft_topoplotER(cfg, avgSNR1_5BL);
    
    
    
    