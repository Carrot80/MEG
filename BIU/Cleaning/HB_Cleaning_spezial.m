% zzz_ms

cfg=[];
cfg.matchMethod='topo';
cleanData=correctHB('tr_lf_c,rfhp0.1Hz',[],1,[],cfg);
kh_rewrite_pdf(cleanData,[], 'tr_lf_c,rfhp0.1Hz','hb') 

 handles=findall(0,'type','figure')
    for i=1:length(handles)
        FigNum=num2str(i)
        PathFigure = sprintf('%s%sHb_Cleaning_Fig%s' , pwd, filesep, FigNum);
        h=figure(i)
        saveas(h, PathFigure, 'fig')  
    end
    close all
    clear all
    
    % line Frequency:
    
    LFcleanedData = LFcleanNoCue('hb_lf_c,rfhp0.1Hz') ;  % zzz_md not fine FIXME.m 
    kh_rewrite_pdf(LFcleanedData,[], origFile,'lf') ;
    
    
    [TrainCleanData,whereUp]=LFcleanNoCue('hb_lf_c,rfhp0.1Hz',1017.25,'time', 'ADAPTIVE',18) ;
      kh_rewrite_pdf(TrainCleanData,[], 'lf_n_c,rfhp0.1Hz','lf') ;
      
      %%
      % hb cleaning spezial
      
      cfg=[];
cfg.dataset='tr_lf_c,rfhp0.1Hz';
cfg.hpfilter='yes';
cfg.hpfreq=1;
cfg.demean='yes';
cfg.channel='MEG';
hp=ft_preprocessing(cfg);

 [cleanData,temp2e,period4,MCG,Rtopo]=correctHB(hp.trial{1,1},1017.25, 1);
 
  kh_rewrite_pdf(cleanData,[], 'tr_lf_c,rfhp0.1Hz','hb') 
  