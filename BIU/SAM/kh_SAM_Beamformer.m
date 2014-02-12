function ForAll()

ControlsFolder = '/home/kh/data/controls_SAM';

DIR = dir (ControlsFolder, 'dir')
isub = [DIR(:).isdir]; %# returns logical vector
nameFolds = {DIR(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

for i= 1:size(nameFolds)
    
   kh_SAM( strcat(ControlsFolder, nameFolds(i,1).name), nameFolds(i).name)

end


end




function kh_SAM(PatientPath, PatientName)

[FileName]=findFileName(PatientPath, PatientName)

PathAll = '/home/kh/data/controls_SAM'
cd PathAll

!SAMcov64 -r  PatientName -d FileName -m M400 -v


end

function [FileName]=findFileName(PatientPath, PatientName)



end
