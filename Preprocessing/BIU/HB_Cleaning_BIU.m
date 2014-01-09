
function ForAllPat ()
    
    PatientFolder = 'D:\kirsten_thesis\data\patients\'
    PatientList = dir( PatientFolder );
    VolunteerFolder = 'D:\kirsten_thesis\data\controls\';
    VolunteerList = dir( VolunteerFolder );
    
    for i = 6 : size (VolunteerList)
        if ( 0 == strcmp( VolunteerList(i,1).name, '.') && 0 == strcmp( VolunteerList(i,1).name, '..'))
            Cleaning_BIU ( strcat(VolunteerFolder, VolunteerList(i,1).name), VolunteerList(i,1).name  ) ;
        end
    end
end

function Cleaning_BIU (PatientPath, PatientName)

% for initial heartbeatcleaning, works only for some patients. if this doesn't work, go on to correctHB 

 % Reject all other but ...
        if ( 0 == strcmp (PatientPath, 'D:\kirsten_thesis\data\controls\zzz_md'))
            return;
        end
        
    Path                     = [];
    Path.DataInput           = strcat ( PatientPath, '\MEG\01_Input_noise_reduced')                 ;
    Path.Preprocessing       = strcat ( PatientPath, '\MEG\02_PreProcessing')                       ;   

    cleanedFile =  strcat( Path.DataInput, filesep, 'hb,n_c,rfhp0.1Hz');
    
    if exist (cleanedFile, 'file')
        return
    end
    
       
    fileName = strcat(Path.DataInput, filesep, 'n_c,rfhp0.1Hz');
    p=pdf4D(fileName);

    cleanCoefs = createCleanFile(p, fileName, 'HeartBeat', []);   
  
    PathPlot = strcat ( Path.Preprocessing, filesep, 'HB_Cleaned_MEG') ;
    print('-dpng', PathPlot) ;
    saveas(h, PathPlot, 'fig') ;

end
