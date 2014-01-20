    origFile         = strcat(pwd, filesep, 'n_c,rfhp0.1Hz')    
     HbCleanedFile    = strcat(pwd, filesep, 'hb_n_c,rfhp0.1Hz'); 
     LfHbCleanedFile = strcat(pwd, filesep, 'lf,hb_n_c,rfhp0.1Hz'); 
       
    % HeartbeatCleaning:
    [cleanData,temp2e,period4,MCG,Rtopo]=correctHB(origFile,[], 1);
    kh_rewrite_pdf(cleanData,[], origFile,'hb') 
    
    handles=findall(0,'type','figure')
    for i=1:length(handles)
        FigNum=num2str(i)
        PathFigure = sprintf('%s%sHb_Cleaning_Fig%s' , pwd, filesep, FigNum);
        h=figure(i)
        saveas(h, PathFigure, 'fig')  
    end
    close all
    
    % Line Frequency Cleaning, did not work for zzz_md and zzz_mf, zzz_ms,
    % zzz_sf, zzz_si
    origFile         = strcat(pwd, filesep, 'n_c,rfhp0.1Hz')    
    LFcleanedData = LFcleanNoCue(origFile) ;  % zzz_md not fine FIXME.m 
    kh_rewrite_pdf(LFcleanedData,[], origFile,'lf') ;
    
    [TrainCleanData,whereUp]=LFcleanNoCue('lf_n_c,rfhp0.1Hz',1017.25,'time', 'ADAPTIVE',150) ;
      kh_rewrite_pdf(TrainCleanData,[], 'lf_n_c,rfhp0.1Hz','lf') ;
      
    [cleanData,temp2e,period4,MCG,Rtopo]=correctHB('lf_lf_n_c,rfhp0.1Hz',[], 1);
    kh_rewrite_pdf(cleanData,[], origFile,'hb') 
    
    PathFigure = strcat (pwd, filesep, 'Lf_Cleaning') ;
    saveas(gcf, PathFigure, 'fig')  
    close all
    