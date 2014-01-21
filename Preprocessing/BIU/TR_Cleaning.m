
function for_all_subjects  

    PatientFolder = 'D:\kirsten_thesis\data\patients\';
    ControlsFolder = 'D:\kirsten_thesis\data\controls\';
    
%     SelectSubjects (ControlsFolder)
    SelectSubjects (PatientFolder)
    
end


function SelectSubjects (Mainfolder)

    List = dir( Mainfolder );

 for i = 1 : size (List)
      if ( 0 == strcmp( List(i,1).name, '.') && 0 == strcmp( List(i,1).name, '..') )
          Path.Subject = strcat(Mainfolder, List(i,1).name) ;
          SubjectName = List(i,1).name  
          
         Path.DataInput           = strcat ( Path.Subject, '\MEG\01_Input_no_noisereduction\')                 ;
         Path.Preprocessing       = strcat ( Path.Subject, '\MEG\02_PreProcessing\')                       ;   
          
         TrCleaning (SubjectName, Path)
         
      end
 end
 
end


function TrCleaning (SubjectName, Path)


        

%  if initial heartbeatcleaning did not work and for lf-cleaning

     origFile         = strcat(Path.DataInput, 'lf_c,rfhp0.1Hz')    
     TrCleanedFile    = strcat(Path.DataInput, 'tr_lf_c,rfhp0.1Hz'); 
   
     
     if exist (TrCleanedFile, 'file')
         return
     end
     
     if ~exist (origFile, 'file')
         return
     end
     

    cd (Path.DataInput)
    
   % Line Frequency Cleaning:
    
    [CleanData,whereUp]=LFcleanNoCue(origFile,1017.25,'time', 'ADAPTIVE',17.0) ;
   
    kh_rewrite_pdf(CleanData,[], origFile,'tr') 
    
    PathFigure = strcat (Path.DataInput, 'tr_Cleaning') ;
    saveas(gcf, PathFigure, 'fig')  
    close all
    clear all
        
end