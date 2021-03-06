

function ForAllPat ()

% checks data quality (mean MEG) for all patients at once
    
    PatientFolder = 'D:\kirsten_thesis\data\patients\'
    PatientList = dir( PatientFolder );
    VolunteerFolder = 'D:\kirsten_thesis\data\controls\';
    VolunteerList = dir( VolunteerFolder );
    
    for i = 1 : size (VolunteerList)
        if ( 0 == strcmp( VolunteerList(i,1).name, '.') && 0 == strcmp( VolunteerList(i,1).name, '..'))
            MeanMEG ( strcat(VolunteerFolder, VolunteerList(i,1).name), VolunteerList(i,1).name  ) ;
        end
    end
    
    for i = 1 : size (PatientList)
        if ( 0 == strcmp( PatientList(i,1).name, '.') && 0 == strcmp( PatientList(i,1).name, '..'))
            MeanMEG ( strcat(PatientFolder, PatientList(i,1).name), PatientList(i,1).name  ) ;
        end
    end
    
    
end

%%

function [Path, PatientName] = MeanMEG  ( PatientPath, PatientName)

        
        Path                     = [];
        Path.DataInput           = strcat ( PatientPath, '\MEG\01_Input_noise_reduced')                 ;
        Path.Preprocessing       = strcat ( PatientPath, '\MEG\02_PreProcessing');
        file = strcat(Path.DataInput, filesep, 'n_c,rfhp0.1Hz');
                 
                
        if ~exist (file)

            return;
        end
  
        PathPlot = strcat (Path.Preprocessing, '\', 'MeanMEG', '.fig') ;

            if exist (PathPlot, 'file')
                return
            end
        
        % plot the mean MEG:

            fileName        = strcat ( Path.DataInput, '\',  'n_c,rfhp0.1Hz')  ;
            p               = pdf4D(fileName) ;
            chi             = channel_index( p, 'meg' ) ;
            data            = read_data_block( p, [], chi ) ;
            samplingRate    = get( p,'dr' ) ;
            tMEG            = ( 0:size(data,2)-1 )/samplingRate ;
            h = figure('visible','on'); 
            plot(tMEG,mean(data))
            axis tight ;
            ylim([-4e-12 4e-12]) ;
            PathPlot        = strcat(Path.Preprocessing, '\', 'MeanMEG') ;
            NameTitle       = strcat ('Mean MEG', {' '}, '-', {' '}, PatientName)
            title (NameTitle) ;
            print('-dpng', PathPlot) ;
            saveas(h, PathPlot, 'fig')  

end