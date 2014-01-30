
function ForAllPat ()
    
    PatientFolder = 'D:\kirsten_thesis\data\patients\'
    PatientList = dir( PatientFolder );
    VolunteerFolder = 'D:\kirsten_thesis\data\controls\';
    VolunteerList = dir( VolunteerFolder );
    
    for i = 1 : size (VolunteerList)
        if ( 0 == strcmp( VolunteerList(i,1).name, '.') && 0 == strcmp( VolunteerList(i,1).name, '..'))
            BIUCorrectHbLf ( strcat(VolunteerFolder, VolunteerList(i,1).name), VolunteerList(i,1).name  ) ;
        end
    end
end



function BIUCorrectHbLf (PatientPath, PatientName)

% use this function if initial heartbeatcleaning did not work

 % Reject all other but ...
        if ( 0 == strcmp (PatientPath, 'D:\kirsten_thesis\data\controls\zzz_ca'))
            return;
        end
        
    if exist(, 'file')
        return
    end        
        
    Path                     = [];
    Path.DataInput           = strcat ( PatientPath, '\MEG\01_Input_noise_reduced')                 ;
       
    fileName = strcat(Path.DataInput, filesep, 'n_c,rfhp0.1Hz');
    
    [cleanData,temp2e,period4,MCG,Rtopo]=correctHB(fileName,[], 1);
    
%     kh_rewrite_pdf(cleanData,[],'lf_n_c,rfhp0.1Hz','lf,hb') 
    kh_rewrite_pdf(cleanData,[], fileName,'lf,hb') 
    
    [FourRef,Fref]=fftBasic(cleanData,round(sRate));
    
    
    % Try Cleaning Train Frequency :
    [cleanData,whereUp]=LFcleanNoCue('lf,hb_lf_n_c,rfhp0.1Hz',1017.25,'time', 'ADAPTIVE',16.67)
    % Frequency Spectrum:
    [FourRef,Fref]=fftBasic(var4Dref,round(sRate));
    plot(FourRef, Fref)
    
    
end

