    origFile         = strcat(pwd, filesep, 'n_c,rfhp0.1Hz')    
    LFcleanedData = LFcleanNoCue(origFile) ;  % zzz_md not fine FIXME.m 
    kh_rewrite_pdf(LFcleanedData,[], origFile,'lf') ; 

    
    PathFigure = strcat (pwd, filesep, 'Lf_Cleaning') ;
    saveas(gcf, PathFigure, 'fig')  
    close all

    [cleanData,temp2e,period4,MCG,Rtopo]=correctHB('lf_c,rfhp0.1Hz',[], 1);
    kh_rewrite_pdf(cleanData,[], 'lf_n_c,rfhp0.1Hz','hb') 
    
     handles=findall(0,'type','figure')
    for i=1:length(handles)
        FigNum=num2str(i)
        PathFigure = sprintf('%s%sHb_Cleaning_Fig%s' , pwd, filesep, FigNum);
        h=figure(i)
        saveas(h, PathFigure, 'fig')  
    end
    close all
    
    
     [TrainCleanData,whereUp]=LFcleanNoCue('lf_hb_n_c,rfhp0.1Hz',1017.25,'time', 'ADAPTIVE',150) ;
      kh_rewrite_pdf(TrainCleanData,[], 'lf_hb_n_c,rfhp0.1Hz','lf') 
     [TrainCleanData,whereUp]=LFcleanNoCue('lf_lf_hb_n_c,rfhp0.1Hz',1017.25,'time', 'ADAPTIVE',50) ;