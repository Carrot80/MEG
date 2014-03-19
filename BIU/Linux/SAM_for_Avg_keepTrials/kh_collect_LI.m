


function for_all ()

% function created textfiles for Maxvalue in ROI


    ControlsFolder = '/home/kh/data/controls_SAM';

    DIR = dir (ControlsFolder)
    isub = [DIR(:).isdir]; %  returns logical vector
    nameFolds = {DIR(isub).name}';
    nameFolds(ismember(nameFolds,{'.','..'})) = [];

    LI_All = [];
    TimeInt = [.32, .6];
    
    for i= 1:size(nameFolds)
         
%         [LI_SumVoxelsORValues] = collect_LI(strcat(ControlsFolder, filesep, nameFolds{i,1}), nameFolds{i}, 'Broca' , 'Wernicke','TempInfplusPols', TimeInt, LI_SumOfsignVoxels);
        [LI_All, SumVoxelsORValues] = collect_LI(strcat(ControlsFolder, filesep, nameFolds{i,1}), nameFolds{i}, TimeInt, 'SumOfMaxValues', LI_All);
%          [LI_All, SumVoxelsORValues] = collect_LI(strcat(ControlsFolder, filesep, nameFolds{i,1}), nameFolds{i}, TimeInt, 'SumOfSignVoxels', LI_All);
    end
    
    Path = strcat( '/home/kh/data/', SumVoxelsORValues, '_dil_', num2str(TimeInt(1,1)), '_', num2str(TimeInt(1,2)), '_s.mat'); 
    save (Path, 'LI_All')
    
 
    
    
end


function [LI_All, SumVoxelsORValues] = collect_LI (SubjectPath, SubjectName, TimeInt, SumVoxelsORValues, LI_All )


% PathFile = strcat (SubjectPath, filesep, 'LI', filesep, 'LI_', ROIName, '_SumOfMaxValues_', num2str(TimeInt(1,1)), '_', num2str(TimeInt(1,2)),  '_s.mat' );

PathLIBroca = strcat (SubjectPath, filesep, 'LI/', 'LI_', 'Broca', '_dil_', SumVoxelsORValues, '_', num2str(TimeInt(1,1)), '_', num2str(TimeInt(1,2)), '_s.mat');
load (PathLIBroca)


% LI_SumOfsignVoxels.(SubjectName).Broca = LI;
LI_All.(SubjectName).Broca = LI;
clear LI

PathLIWernicke = strcat (SubjectPath, filesep, 'LI/', 'LI_', 'Wernicke','_dil_', SumVoxelsORValues, '_', num2str(TimeInt(1,1)), '_', num2str(TimeInt(1,2)), '_s.mat');
load (PathLIWernicke)
LI_All.(SubjectName).Wernicke = LI;
clear LI

% PathLITempInf = strcat (SubjectPath, filesep, 'LI/', 'LI_', 'TempInfplusPols', '_', SumVoxelsORValues, '_', num2str(TimeInt(1,1)), '_', num2str(TimeInt(1,2)), '_s.mat');
% load (PathLITempInf)
% LI_All.(SubjectName).TempInf = LI;
% clear LI



end