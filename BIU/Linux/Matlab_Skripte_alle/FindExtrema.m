
function for_all ()

% function created textfiles for Maxvalue in ROI, zum Ausrechnen des LI's


    ControlsFolder = '/home/kh/ShareWindows/data/patients/patients_SAM';

    DIR = dir (ControlsFolder)
    isub = [DIR(:).isdir]; %  returns logical vector
    nameFolds = {DIR(isub).name}';
    nameFolds(ismember(nameFolds,{'.','..'})) = [];
    Table=[];

    for i= 1:size(nameFolds)
   

    TimeInt = [.32, .6];
      
   [Table]=findextrema(strcat(ControlsFolder, filesep, nameFolds{i,1}), nameFolds{i}, Table, i)  
    
    end

    Table.Location= Table.Location'
    Path=strcat('/home/kh/ShareWindows/data', filesep, 'Extrema_and_Locations_patients.mat')
    save(Path, 'Table')
    
end


function [Table]=findextrema(SubjectPath, SubjectName, Table, i)

if 1==strcmp(SubjectName,'Pat_02_13008rh_1') || 1==strcmp(SubjectName,'Pat_02_13008rh_2') || 1==strcmp(SubjectName,'Pat_03_13014bg_1') || 1==strcmp(SubjectName,'Pat_03_13014bg_2')

    return
end

Path=strcat(SubjectPath, filesep, 'TimeIntervalls');

cd(Path)

PathMask = strcat ('/home/kh/ShareWindows/data/Brainmask+tlrc');
% eval(['!3dcalc -a ERF_noise_0.32-0.6s_Pat_01_13021km+tlrc -b ', PathMask_left, ' -exp a*b -prefix ',ROI, '_zscores'])


if 1==strcmp (SubjectName,'Pat_02_13008rh') ||  1==strcmp (SubjectName,'Pat_03_13014bg')
    eval(['!3dExtrema -volume -mask_file ', PathMask, ' BothRuns_br_z_transf_brain01ERF_noise_0.32-0.6s+tlrc > Extrema.txt'])
else
    
    eval(['!3dExtrema -volume -mask_file ', PathMask, ' br_z_transf_brain01ERF_noise_0.32-0.6s_', SubjectName,'+tlrc > Extrema.txt'])
end


[newData1]=importfile ('Extrema.txt')

eval(['!whereami ', num2str(newData1.data(1,3)),' ', num2str(newData1.data(1,4)),' ', num2str(newData1.data(1,5)), ' > Whereami.txt' ])

fid = fopen('Whereami.txt');
Whereami=textscan(fid, '%s', 'delimiter', sprintf('\f'));
fclose(fid)

Number=strfind( Whereami{1,1}, 'Atlas CA_ML_18_MNIA: Macro Labels (N27)')
for j=1:length(Number)
    X(j)=~isempty(Number{j})
end

  X=double(X)
[row]=find(X==1)

Table.Location{i} = Whereami{1,1}{row+1}
Table.Coord(i,:)  = newData1.data(1,2:5)


end


function [newData1]=importfile(fileToRead1)
%IMPORTFILE(FILETOREAD1)
%  Imports data from the specified file
%  FILETOREAD1:  file to read

%  Auto-generated by MATLAB on 27-May-2014 16:09:09

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