
 


function ForAllPat ()

% checks data quality (mean MEG) for all patients at once
    
    PatientFolder = 'D:\kirsten_thesis\data\patients\'
    PatientList = dir( PatientFolder );

    for i = 1 : size (PatientList)
        if ( 0 == strcmp( PatientList(i,1).name, '.') && 0 == strcmp( PatientList(i,1).name, '..'))
            MeanMEGmultFolders ( strcat(PatientFolder, PatientList(i,1).name), PatientList(i,1).name  ) ;
        end
    end
   
end


function [Path, PatientName] = MeanMEGmultFolders  ( PatientPath, PatientName)

        % for Patients with more than file:      
        Path                     = [];
        Path.DataInput           = strcat ( PatientPath, '\MEG\01_Input_noise_reduced')                 ;
        Path.Preprocessing       = strcat ( PatientPath, '\MEG\02_PreProcessing');
        

        
        file = strcat(Path.DataInput, filesep, '01', filesep, 'n_c,rfhp0.1Hz');
        
        PathPlot = strcat (Path.Preprocessing, '\', 'MeanMEG_01', '.fig') ;

            if exist (PathPlot, 'file')
                return
            end
        
        if ~exist (file)
            
            file = strcat(Path.DataInput, filesep, '02', filesep, 'n_c,rfhp0.1Hz');

            return;
        end         


               
        
        
       
  

        
        % plot the mean MEG:

           %  fileName        = strcat ( Path.DataInput, '\',  'n_c,rfhp0.1Hz')  ;
            fileName        =  'n_c,rfhp0.1Hz' ;
            p               = pdf4D(fileName) ;
            chi             = channel_index( p, 'meg' ) ;
            data            = read_data_block( p, [], chi ) ;
            samplingRate    = get( p,'dr' ) ;
            tMEG            = ( 0:size(data,2)-1 )/samplingRate ;
            h = figure('visible','on'); 
            plot(tMEG,mean(data))
            axis tight ;
            ylim([-4e-12 4e-12]) ;
            PathPlot        = pwd ;
            NameTitle       = strcat ('Mean MEG', {' '}, '-', {' '}, PatientName)
            title (NameTitle) ;
            print('-dpng', PathPlot) ;
            saveas(h, PathPlot, 'fig')  

end