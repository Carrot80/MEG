
function ForAllPat ()
    
    PatientFolder = 'D:\kirsten_thesis\data\patients\'
    PatientList = dir( PatientFolder );
    VolunteerFolder = 'D:\kirsten_thesis\data\controls\';
    VolunteerList = dir( VolunteerFolder );
    
    for i = 6 : size (VolunteerList)
        if ( 0 == strcmp( VolunteerList(i,1).name, '.') && 0 == strcmp( VolunteerList(i,1).name, '..'))
            Correct_HB_BIU ( strcat(VolunteerFolder, VolunteerList(i,1).name), VolunteerList(i,1).name  ) ;
        end
    end
end



function Correct_HB_BIU (PatientPath, PatientName)

% use this function if initial heartbeatcleaning did not work

 % Reject all other but ...
        if ( 0 == strcmp (PatientPath, 'D:\kirsten_thesis\data\controls\zzz_md'))
            return;
        end
        
    Path                     = [];
    Path.DataInput           = strcat ( PatientPath, '\MEG\01_Input_noise_reduced')                 ;
    Path.Preprocessing       = strcat ( PatientPath, '\MEG\02_PreProcessing')                       ;   
       
    fileName = strcat(Path.DataInput, filesep, 'n_c,rfhp0.1Hz');
    
    [cleanData,temp2e,period4,MCG,Rtopo]=correctHB(fileName,[], 1);
    rewrite_pdf(cleanData,[],[],'xc,lf,hb')

end

