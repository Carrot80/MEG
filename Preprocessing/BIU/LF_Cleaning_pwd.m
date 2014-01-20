
    [CleanData,whereUp]=LFcleanNoCue('c,rfhp0.1Hz',1017.25,'time', 'ADAPTIVE',50) ;
    [CleanData100Hz,whereUp]=LFcleanNoCue(CleanData,1017.25,'time', 'ADAPTIVE',100) ;
    [CleanData,whereUp]=LFcleanNoCue(CleanData150Hz,1017.25,'time', 'ADAPTIVE',50) ;
    kh_rewrite_pdf(CleanData,[], 'c,rfhp0.1Hz','lf') ;
      
    
    PathFigure = strcat (pwd, filesep, 'Lf_Cleaning') ;
    saveas(gcf, PathFigure, 'fig')  
    close all
    clear all