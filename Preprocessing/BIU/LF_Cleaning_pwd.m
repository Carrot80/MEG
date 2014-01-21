
    [CleanData,whereUp]=LFcleanNoCue('lf_c,rfhp0.1Hz',1017.25,'time', 'ADAPTIVE',17.0) ;
    
    
    [CleanData150Hz,whereUp]=LFcleanNoCue(CleanData,1017.25,'time', 'ADAPTIVE',150) ;
    
    [CleanData100,whereUp]=LFcleanNoCue(CleanData150Hz,1017.25,'time', 'ADAPTIVE',100) ;
    
    kh_rewrite_pdf(CleanData,[], 'lf_c,rfhp0.1Hz','tr') ;
      
    
    PathFigure = strcat (pwd, filesep, 'tr_Cleaning') ;
    saveas(gcf, PathFigure, 'fig')  
    close all
    clear all