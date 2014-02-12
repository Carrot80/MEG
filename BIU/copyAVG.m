

function DicomImportMain  

    PatientFolder = 'D:\kirsten_thesis\data\patients\';
    ControlsFolder = 'D:\kirsten_thesis\data\controls\'
    
%     DicomImport (PatientFolder)
    DicomImport (ControlsFolder)
    
end


function DicomImport(Mainfolder)
    
     List = dir( Mainfolder );
      
    for i = 1 : size (List)
        if ( 0 == strcmp( List(i,1).name, '.') && 0 == strcmp( List(i,1).name, '..') )
            CopyFiles( strcat(Mainfolder, List(i,1).name), List(i,1).name  );
        end
    end
end

function CopyFiles(SubjectPath, Subjectname)

PathAVG = strcat(SubjectPath, filesep, 'MEG\', 'SensorLevelAnalysis', filesep, 'avgBL.mat')

NewPath = strcat('D:\Arbeit\LinuxExchange\SensorLevelAnalysis\', 'avgBL_', Subjectname, '.mat')

copyfile(PathAVG, NewPath)

end