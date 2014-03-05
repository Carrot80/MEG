


function for_all ()

% function created textfiles for Maxvalue in ROI


    ControlsFolder = '/home/kh/data/controls_SAM';

    DIR = dir (ControlsFolder)
    isub = [DIR(:).isdir]; %  returns logical vector
    nameFolds = {DIR(isub).name}';
    nameFolds(ismember(nameFolds,{'.','..'})) = [];

    LI_SumOfsignVoxels = [];
    for i= 1:size(nameFolds)
        
    TimeInt = [.23, .31];
        
        [LI_SumOfsignVoxels] = collect_LI(strcat(ControlsFolder, filesep, nameFolds{i,1}), nameFolds{i}, 'Broca' , 'Wernicke','TempInfplusPols', TimeInt, LI_SumOfsignVoxels)
         

    end
    
    Path = strcat( '/home/kh/data/', 'LI', '_SumOfSignVoxels_', num2str(TimeInt(1,1)), '_', num2str(TimeInt(1,2)), '_s.mat'); 
    save (Path, 'LI_SumOfsignVoxels')
    
 
    
    
end


function [LI_SumOfsignVoxels] = collect_LI (SubjectPath, SubjectName, Broca, Wernicke, TempInf, TimeInt, LI_SumOfsignVoxels )


PathLIBroca = strcat (SubjectPath, filesep, 'LI/', 'LI_', Broca, '_SumOfSignVoxels_', num2str(TimeInt(1,1)), '_', num2str(TimeInt(1,2)), '_s.mat');
load (PathLIBroca)

LI_SumOfsignVoxels.(SubjectName).Broca = LI;


PathLIWernicke = strcat (SubjectPath, filesep, 'LI/', 'LI_', Wernicke, '_SumOfSignVoxels_', num2str(TimeInt(1,1)), '_', num2str(TimeInt(1,2)), '_s.mat');
load (PathLIWernicke)

LI_SumOfsignVoxels.(SubjectName).Wernicke = LI;

PathLITempInf = strcat (SubjectPath, filesep, 'LI/', 'LI_', TempInf, '_SumOfSignVoxels_', num2str(TimeInt(1,1)), '_', num2str(TimeInt(1,2)), '_s.mat');
load (PathLITempInf)

LI_SumOfsignVoxels.(SubjectName).TempInf = LI;




end