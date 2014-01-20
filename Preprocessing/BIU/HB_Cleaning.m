
function for_all_subjects  

    PatientFolder = 'D:\kirsten_thesis\data\patients\';
    ControlsFolder = 'D:\kirsten_thesis\data\controls\';
    
    SelectSubjects (ControlsFolder)
%     SelectSubjects (PatientFolder)
    
end


function SelectSubjects (Mainfolder)

    List = dir( Mainfolder );

 for i = 1 : size (List)
      if ( 0 == strcmp( List(i,1).name, '.') && 0 == strcmp( List(i,1).name, '..') )
          Path.Subject = strcat(Mainfolder, List(i,1).name) ;
          SubjectName = List(i,1).name  
          
         Path.DataInput           = strcat ( Path.Subject, '\MEG\01_Input_no_noisereduction\')                 ;
         Path.Preprocessing       = strcat ( Path.Subject, '\MEG\02_PreProcessing\')                       ;   
          
         HbCleaning (SubjectName, Path)
         
      end
 end
 
end


function HbCleaning (SubjectName, Path)


        

%  if initial heartbeatcleaning did not work and for lf-cleaning

     origFile         = strcat(Path.DataInput, 'tr_lf_c,rfhp0.1Hz')    
     HbCleanedFile    = strcat(Path.DataInput, 'hb_tr_lf_c,rfhp0.1Hz'); 
   
     
     if exist (HbCleanedFile, 'file')
         return
     end
     

    cd (Path.DataInput)
    
% HeartbeatCleaning:
    [cleanData,temp2e,period4,MCG,Rtopo]=correctHB(origFile,[], 1);
    kh_rewrite_pdf(cleanData,[], origFile,'hb') 
    
    handles=findall(0,'type','figure')
    for i=1:length(handles)
        FigNum=num2str(i)
        PathFigure = sprintf('%sHb_Cleaning_Fig%s' , Path.DataInput, FigNum);
        h=figure(i)
        saveas(h, PathFigure, 'fig')  
    end
    close all
    clear all

        
end