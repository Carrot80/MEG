
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
          
         Path.DataInput           = strcat ( Path.Subject, '\MEG\01_Input_no_noisereduction\')                 ;
         Path.Preprocessing       = strcat ( Path.Subject, '\MEG\02_PreProcessing\')                       ;   
          
         LfHbCleaning (SubjectName, Path)
         
      end
 end
 
end


function LfHbCleaning (SubjectName, Path)

 % Reject ...
        if        ( 1 == strcmp (Path.Subject, 'D:\kirsten_thesis\data\patients\Pat_01_13021km')...
                  || 1 == strcmp (Path.Subject, 'D:\kirsten_thesis\data\patients\Pat_20_12049fc'))
            return;
        end
        

%  if initial heartbeatcleaning did not work and for lf-cleaning

     TrCleanedFile         = strcat(Path.DataInput, 'tr_lf_c,rfhp0.1Hz') 
     LfCleanedFile         = strcat(Path.DataInput, 'lf_c,rfhp0.1Hz')
     
     
     if exist(TrCleanedFile, 'file')
         FileToUse = TrCleanedFile
     elseif exist(LfCleanedFile, 'file')
          FileToUse = LfCleanedFile
     elseif ~exist(LfCleanedFile, 'file')
         return
     end
     
       
     HbtrCleanedFile    = strcat(Path.DataInput, 'hb_tr_lf_c,rfhp0.1Hz'); 
     HbtLfcleanedFile    = strcat(Path.DataInput, 'hb_lf_c,rfhp0.1Hz'); 
%      
     if exist (HbtrCleanedFile, 'file')
         return
     elseif exist (HbtLfcleanedFile, 'file')
         return
     end
     
%     if exist(HbCleanedFile, 'file')
%        LfCleaning (SubjectName, Path) % only done if HbCleanedFile already exist
%        return
%     end        
        
   cd (Path.DataInput)
    close all
    % HeartbeatCleaning:
    [cleanData,temp2e,period4,MCG,Rtopo]=correctHB(FileToUse,[], 1);
    kh_rewrite_pdf(cleanData,[], FileToUse,'hb') 
    
    handles=findall(0,'type','figure')
    for i=1:length(handles)
        FigNum=num2str(i)
        PathFigure = sprintf('%sHb_Cleaning_Fig%s' , Path.DataInput, FigNum);
        h=figure(i)
        saveas(h, PathFigure, 'fig')  
    end
    close all
      
       
   %   Frequency Spectrum:   
%     [FourRef,Fref]=fftBasic(LFcleanedData,round(1017.25)); 
%      plot(FourRef, Fref)
  
        
end


