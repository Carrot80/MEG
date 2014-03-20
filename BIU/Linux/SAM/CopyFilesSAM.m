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

configFileSAMPath = strcat('D:\Arbeit\LinuxExchange\data\patients\patients_SAM', filesep, SubjectName,filesep, 'SAM\config');

if exist (configFileSAMPath, 'file')
    return
end

[fileName]=PathForFileName(SubjectName, Path);

if isempty(fileName)
    return
end



NewDir = (strcat('D:\Arbeit\LinuxExchange\data\patients\patients_SAM', filesep, SubjectName, filesep, 'SAM'));
if ~exist(NewDir, 'dir')
    
  mkdir(strcat('D:\Arbeit\LinuxExchange\data\patients\patients_SAM', filesep, SubjectName, filesep, 'SAM'));  
    
end

SAMPATH= (strcat('D:\Arbeit\LinuxExchange\data\patients\patients_SAM', filesep, SubjectName, filesep, 'SAM'));   

hs= strcat(Path.DataInput, filesep, 'hs_file');
configFile = strcat(Path.DataInput, filesep, 'config');
FileMarkerFile = strcat(Path.Preprocessing, filesep, 'MarkerFile.mrk');
FileTRL_SAM = strcat(Path.Preprocessing, filesep, 'trl_SAM.mat');
AVGTrialsFILE = strcat(Path.Preprocessing, filesep, 'avgTrials_', SubjectName, '.mat');

if exist (strcat(Path.Preprocessing, filesep, 'avgBL'), 'file');
    copyfile
end


copyfile(fileName, SAMPATH)
copyfile(hs, SAMPATH)
copyfile(configFile, SAMPATH)
copyfile(FileMarkerFile, SAMPATH)
copyfile(AVGTrialsFILE, SAMPATH)
copyfile(FileTRL_SAM, SAMPATH)






end


function [Path] = MakePath(SubjectPath, SubjectName)
        
        Path                     = [];
        Path.Subject             = SubjectPath ; 
        Path.DataInput           = strcat ( SubjectPath, '\MEG\01_Input_no_noisereduction')                 ;
        Path.Preprocessing       = strcat ( SubjectPath, '\MEG\02_PreProcessing')          ;
        Path.StatisticsSensorLevel = strcat (SubjectPath, '\MEG\SensorLevelAnalysis')          ;
end

   

    function      [fileName]=PathForFileName(SubjectName, Path)
        
   
     PathfileNameHBcor=strcat(Path.DataInput, filesep,'hb_tr_lf_c,rfhp0.1Hz') ;
     PathfileNameHBcorNoTr=strcat(Path.DataInput, filesep,'hb_lf_c,rfhp0.1Hz') ;
     PathfileNameNoHBcor=strcat(Path.DataInput, filesep,'tr_lf_c,rfhp0.1Hz') ;
     PathfileNameLfcor=strcat(Path.DataInput, filesep,'lf_c,rfhp0.1Hz') ;

     if exist (PathfileNameHBcor, 'file')
         fileName=PathfileNameHBcor;
     elseif exist (PathfileNameHBcorNoTr, 'file')
         fileName=PathfileNameHBcorNoTr;
     elseif exist(PathfileNameNoHBcor, 'file')
         fileName=PathfileNameNoHBcor;
     elseif exist(PathfileNameLfcor, 'file')
         fileName=PathfileNameLfcor
         
     else 
         
         fileName = [];
 
                 
         
    end
    end
