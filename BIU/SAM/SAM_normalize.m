function forAll()

% dies für alle Patienten nutzen und umbauen
ControlsFolder = '/home/kh/data/controls_SAM';

DIR = dir (ControlsFolder)
isub = [DIR(:).isdir]; %  returns logical vector
nameFolds = {DIR(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

for i= 1:size(nameFolds)
    
   kh_SAM_normalize( strcat(ControlsFolder, filesep, nameFolds{i,1}), nameFolds{i})
    
end


end



function kh_SAM_normalize (SubjectPath, SubjectName)


Path = strcat (SubjectPath, filesep, 'SAM');
cd (Path)

%  Path_Ortho = strcat(SubjectPath, filesep, 'SAM', filesep, 'ortho+orig');

!@auto_tlrc -base TT_avg152T1+tlrc -suffix MNI152T -input ortho+orig -ok_notice

!@auto_tlrc -apar orthoMNI152T+tlrc -input ERF+orig -dxyz 5  

end
