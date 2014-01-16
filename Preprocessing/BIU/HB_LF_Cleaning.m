
function for_all_subjects  

    PatientFolder = 'D:\kirsten_thesis\data\patients\';
    ControlsFolder = 'D:\kirsten_thesis\data\controls\';
    
    SelectSubjects (ControlsFolder)
    SelectSubjects (PatientFolder)
    
end


function SelectSubjects (Mainfolder)

    List = dir( Mainfolder );

 for i = 1 : size (List)
      if ( 0 == strcmp( List(i,1).name, '.') && 0 == strcmp( List(i,1).name, '..') )
          Path.Subject = strcat(Mainfolder, List(i,1).name) ;
          SubjectName = List(i,1).name  
          
         Path.DataInput           = strcat ( Path.Subject, '\MEG\01_Input_noise_reduced')                 ;
         Path.Preprocessing       = strcat ( Path.Subject, '\MEG\02_PreProcessing')                       ;   
          
         LfHbCleaning (SubjectName, Path)
         
      end
 end
 
end


function LfHbCleaning (SubjectName, Path)

 % Reject all other but ...
        if ( 1 == strcmp (Path.Subject, 'D:\kirsten_thesis\data\controls\zzz_ca'))
            return;
        end
        

%  if initial heartbeatcleaning did not work and for lf-cleaning

     origFile         = strcat(Path.DataInput, filesep, 'n_c,rfhp0.1Hz')    
     HbCleanedFile    = strcat(Path.DataInput, filesep, 'hb_n_c,rfhp0.1Hz'); 
     LfHbCleanedFile = strcat(Path.DataInput, filesep, 'lf_hb_n_c,rfhp0.1Hz'); 
     
     if exist (LfHbCleanedFile, 'file')
         return
     end
     
    if exist(HbCleanedFile, 'file')
       LfCleaning (SubjectName, Path) % only done if HbCleanedFile already exist
       return
    end        
        
   
    % HeartbeatCleaning:
    [cleanData,temp2e,period4,MCG,Rtopo]=correctHB(origFile,[], 1);
    kh_rewrite_pdf(cleanData,[], origFile,'hb') 
    
    % Line Frequency Cleaning
   
    LFcleanedData = LFcleanNoCue(HbCleanedFile) ;
    kh_rewrite_pdf(LFcleanedData,[], HbCleanedFile,'lf') 
    
    PathFigure = strcat (Path.DataInput, filesep, 'Lf_Hb_Cleaning') ;
    saveas(gcf, PathFigure, 'fig')  
    close all
    
   %   Frequency Spectrum:   
%     [FourRef,Fref]=fftBasic(LFcleanedData,round(1017.25)); 
%      plot(FourRef, Fref)
    
    % Try Cleaning Train Frequency :
    [TrainCleanData,whereUp]=LFcleanNoCue(LfHbCleanedFile,1017.25,'time', 'ADAPTIVE',16.666666666666666666667) ;
    kh_rewrite_pdf(TrainCleanData,[], LfHbCleanedFile,'tr') 
    PathTrFigure = strcat (Path.DataInput, filesep, 'Tr_Cleaning') ;
    saveas(gcf, PathTrFigure, 'fig')  
       
    
end


