
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
%         if        ( 1 == strcmp (Path.Subject, 'D:\kirsten_thesis\data\controls\zzz_md'))
%                  
%             return;
%         end
        

%  if initial heartbeatcleaning did not work and for lf-cleaning

     origFile         = strcat(Path.DataInput, 'c,rfhp0.1Hz')    
     LfCleanedFile    = strcat(Path.DataInput, 'lf_c,rfhp0.1Hz'); 
     HbLfCleanedFile = strcat(Path.DataInput, 'hb,lf_c,rfhp0.1Hz'); 
     
     if exist (LfCleanedFile, 'file')
         return
     end
     
          if exist (LfCleanedFile, 'file')
         return
     end
    cd (Path.DataInput)
    
   % Line Frequency Cleaning:
    
    LFcleanedData = LFcleanNoCue(origFile) ;  
    kh_rewrite_pdf(LFcleanedData,[], origFile,'lf') 
    
    PathFigure = strcat (Path.DataInput, 'Lf_Cleaning') ;
    saveas(gcf, PathFigure, 'fig')  
    close all
    
    
    
    
    % HeartbeatCleaning:
%     [cleanData,temp2e,period4,MCG,Rtopo]=correctHB(origFile,[], 1);
%     kh_rewrite_pdf(cleanData,[], origFile,'hb') 
%     
%     handles=findall(0,'type','figure')
%     for i=1:length(handles)
%         FigNum=num2str(i)
%         PathFigure = sprintf('%sHb_Cleaning_Fig%s' , Path.DataInput, FigNum);
%         h=figure(i)
%         saveas(h, PathFigure, 'fig')  
%     end
%     close all
    
    
    
   %   Frequency Spectrum:   
%     [FourRef,Fref]=fftBasic(LFcleanedData,round(1017.25)); 
%      plot(FourRef, Fref)
    
    %  Cleaning Train Frequency : noch für alle fehlenden einbauen:
%     [TrainCleanData,whereUp]=LFcleanNoCue(LfHbCleanedFile,1017.25,'time', 'ADAPTIVE',16.666666666666666666667) ;
%     kh_rewrite_pdf(TrainCleanData,[], LfHbCleanedFile,'tr') 
%     PathTrFigure = strcat (Path.DataInput, filesep, 'Tr_Cleaning') ;
%     saveas(gcf, PathTrFigure, 'fig')  
        
end


