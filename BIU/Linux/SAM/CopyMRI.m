% SAM


function for_all_subjects  

      PatientFolder = 'D:\kirsten_thesis\data\patients\';
    
%      SelectSubjects (ControlsFolder)
     SelectSubjects (PatientFolder)
end


function SelectSubjects (Mainfolder)

    List = dir( Mainfolder );

 for i = 1 : size (List)
      if ( 0 == strcmp( List(i,1).name, '.') && 0 == strcmp( List(i,1).name, '..') )
          SubjectPath = strcat(Mainfolder, List(i,1).name) ;
          SubjectName = List(i,1).name  
          
        
          [Path] = MakePath(SubjectPath, SubjectName)
          CopyFiles (Path, SubjectName)
          
      end

 end
 

 
end

function  CopyFiles (Path, SubjectName)

MRIFilePath = strcat('D:\Arbeit\LinuxExchange\data\patients\patients_SAM', filesep, SubjectName,filesep, 's_', SubjectName, '.nii');

if exist (MRIFilePath, 'file')
    return
end



SAMPATH= (strcat('D:\Arbeit\LinuxExchange\data\patients\patients_SAM', filesep, SubjectName, filesep ));   
if ~exist(SAMPATH, 'dir')
    return
end

MRIFile = strcat(Path.MRI, filesep, 's_', SubjectName, '.nii');

copyfile(MRIFile, SAMPATH)







end


function [Path] = MakePath(SubjectPath, SubjectName)
        
        Path                     = [];
        Path.Subject             = SubjectPath ; 
        Path.DataInput           = strcat ( SubjectPath, '\MEG\01_Input_no_noisereduction')                 ;
        Path.Preprocessing       = strcat ( SubjectPath, '\MEG\02_PreProcessing')          ;
        Path.StatisticsSensorLevel = strcat (SubjectPath, '\MEG\SensorLevelAnalysis')          ;
        Path.MRI = strcat (SubjectPath, '\MRI\')          ;
end

