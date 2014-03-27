function for_all ()


ControlsFolder = '/home/kh/data/controls_SAM';

DIR = dir (ControlsFolder)
isub = [DIR(:).isdir]; %  returns logical vector
nameFolds = {DIR(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

TimeIntvls = [.2, .4; .3, .5; .4, .6; .5, .7; .32, .6; .25, .55; .25, .65 ];

for i= 1:size(nameFolds)
    
        openTextfile(strcat(ControlsFolder, filesep, nameFolds{i,1}), nameFolds{i}, TimeIntvls, 'Broca_left', 'Broca_right_recalc', 'Broca' )
        openTextfile(strcat(ControlsFolder, filesep, nameFolds{i,1}), nameFolds{i}, TimeIntvls, 'Wernicke_left', 'Wernicke_right_recalc', 'Wernicke' )
        openTextfile(strcat(ControlsFolder, filesep, nameFolds{i,1}), nameFolds{i}, TimeIntvls, 'TempInfplusPols_left', 'TempInfplusPols_right_recalc', 'TempInfplusPols' )
        
end

end

function openTextfile(SubjectPath, SubjectName, TimeIntvls, LeftROI, RightROI, ROIName )

for i = 1: length(TimeIntvls)
    
    File_left = strcat (SubjectPath, filesep, 'SAM', filesep, LeftROI, '_', num2str(TimeIntvls(i,1)), '_', num2str(TimeIntvls(i,2)), 's_Max.txt')
    [Data_left] = importfile(File_left);
    
    File_right = strcat (SubjectPath, filesep, 'SAM', filesep, RightROI, '_', num2str(TimeIntvls(i,1)), '_', num2str(TimeIntvls(i,2)), 's_Max.txt')
    [Data_right] = importfile(File_right)
    
    Time = strcat(num2str(TimeIntvls(i,1)), '_', num2str(TimeIntvls(i,2)), 's')
    
    
    LI.TimeIntervall{i} = Time;
    
    LI.Max_left(i) = Data_left.data(1,2);
    LI.Max_right(i) = Data_right.data(1,2);
    LI.Max_percchange(1,i) = (LI.Max_left(i)-LI.Max_right(i))./LI.Max_right(i)
    LI.Classic(1,i) = (LI.Max_left(i)-LI.Max_right(i))./(LI.Max_left(i)+LI.Max_right(i))
    
       
end

 PathFile = strcat (SubjectPath, filesep, 'LI', filesep, 'LI_', ROIName, '_MaxValue.mat' )
 save (PathFile, 'LI')

end

function [newData1] = importfile(fileToRead1)

    %IMPORTFILE(FILETOREAD1)
    %  Imports data from the specified file
    %  FILETOREAD1:  file to read

    %  Auto-generated by MATLAB on 25-Feb-2014 10:35:16

    DELIMITER = ' ';
    HEADERLINES = 10;

    % Import the file
    newData1 = importdata(fileToRead1, DELIMITER, HEADERLINES);

    % Create new variables in the base workspace from those fields.
    vars = fieldnames(newData1);
    for i = 1:length(vars)
        assignin('base', vars{i}, newData1.(vars{i}));
    end

end
