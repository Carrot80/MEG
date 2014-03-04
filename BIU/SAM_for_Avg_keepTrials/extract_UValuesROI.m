
function for_all ()

% function created textfiles for Maxvalue in ROI


    ControlsFolder = '/home/kh/data/controls_SAM';

    DIR = dir (ControlsFolder)
    isub = [DIR(:).isdir]; %  returns logical vector
    nameFolds = {DIR(isub).name}';
    nameFolds(ismember(nameFolds,{'.','..'})) = [];

    for i= 1:size(nameFolds)
        
    TimeInt = [.4, .6];
        
        kh_extractActROI(strcat(ControlsFolder, filesep, nameFolds{i,1}), nameFolds{i}, 'Broca_left', 'Broca_right_recalc', 'Broca', TimeInt)
        kh_extractActROI(strcat(ControlsFolder, filesep, nameFolds{i,1}), nameFolds{i}, 'Wernicke_left', 'Wernicke_right_recalc', 'Wernicke', TimeInt)
        kh_extractActROI(strcat(ControlsFolder, filesep, nameFolds{i,1}), nameFolds{i}, 'TempInfplusPols_left', 'TempInfplusPols_right_recalc', 'TempInfplusPols', TimeInt)

    end

end

function kh_extractActROI (SubjectPath, SubjectName, ROI_left, ROI_right, ROIName, TimeInt)

SubjectToAnalyse = '/home/kh/data/controls_SAM/zzz_ms';
if 0 == strcmp (SubjectPath, SubjectToAnalyse)
    return
end


Path2ROI = strcat( SubjectPath, filesep, 'SAM', filesep);
Path2UValues = strcat (SubjectPath, filesep, 'keptTrials', filesep, 'Utest_LR_', num2str(TimeInt(1,1)), '_', num2str(TimeInt(1,2)), 'sMNI+tlrc' );

[V_UValues, Info_UValues] = BrikLoad (Path2UValues);

PathMask_left = strcat (Path2ROI, ROI_left, '+tlrc');
[Mask_left, Info_MASK_left] = BrikLoad (PathMask_left);


PathMask_right = strcat (Path2ROI, ROI_right, '+tlrc');
[Mask_right, Info_MASK_right] = BrikLoad (PathMask_right);


Left_Voxels = find(Mask_left==1);

leftAct=V_UValues(Left_Voxels);

[signLeftVoxels]=find(leftAct>=.95);


Right_Voxels = find(Mask_right==1);

rightAct=V_UValues(Right_Voxels);

[signRightVoxels]=find(rightAct>=.95);


% calculate LI:

 LI.signRightVoxels  = length(signRightVoxels);
 LI.signLeftVoxels = length(signLeftVoxels);
 LI.SizeROI = size(Left_Voxels, 1);
 LI.relActLeft = length(signLeftVoxels)./size(Left_Voxels, 1);
 LI.relActRight = length(signRightVoxels)./size(Right_Voxels, 1);
 LI.Max_percchange = (length(signLeftVoxels)-length(signRightVoxels))./length(signRightVoxels);
 LI.Classic = (length(signLeftVoxels)-length(signRightVoxels))./(length(signLeftVoxels)+length(signRightVoxels));

 
 PathFile = strcat (SubjectPath, filesep, 'LI', filesep, 'LI_', ROIName, '_SumOfSignVoxels_', num2str(TimeInt(1,1)), '_', num2str(TimeInt(1,2)),  '_s.mat' );
 save (PathFile, 'LI')

end
