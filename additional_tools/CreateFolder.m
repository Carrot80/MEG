
function for_all_subjects  

    PatientFolder = 'D:\kirsten_thesis\data\patients\';
    ControlsFolder = 'D:\kirsten_thesis\data\controls\';
    
    SelectSubjects (ControlsFolder)
    SelectSubjects (PatientFolder)
    
end


function SelectSubjects (Mainfolder)

    List = dir( Mainfolder );

 for i = 16 : size (List)
      if ( 0 == strcmp( List(i,1).name, '.') && 0 == strcmp( List(i,1).name, '..') )
          Path.Subject = strcat(Mainfolder, List(i,1).name) ;
          SubjectName = List(i,1).name  
          
       
         CopyFiles (SubjectName, Path)
         
      end
 end
 
 
end

function  CopyFiles (SubjectName, Path)

NewFolder = strcat ( Path.Subject, filesep, 'MEG', filesep, '01_Input_no_noisereduction\') ;
OldFolder = strcat ( Path.Subject, filesep, 'MEG', filesep, '01_Input_noise_reduced\') ;

hsFile = strcat ( Path.Subject, filesep, 'MEG', filesep, '01_Input_no_noisereduction', filesep, 'hs_file') ;
configFile = strcat ( Path.Subject, filesep, 'MEG', filesep, '01_Input_no_noisereduction', filesep, 'config') ;

if ~exist(hsFile,'file')
    copyfile (strcat(OldFolder, 'hs_file'), NewFolder)
end

if ~exist(configFile,'file')
    copyfile (strcat(OldFolder, 'config'), NewFolder)
end

end

function Create_Folder(SubjectName, Path)


    NewFolder = strcat ( Path.Subject, filesep, 'MEG', filesep, '01_Input_no_noisereduction') ;

    if ~exist( NewFolder, 'dir')
            mkdir( NewFolder );
    end
 
end