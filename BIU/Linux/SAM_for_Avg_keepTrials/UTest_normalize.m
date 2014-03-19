function forAll()

% dies für alle Patienten nutzen und umbauen
ControlsFolder = '/home/kh/data/controls_SAM';

DIR = dir (ControlsFolder)
isub = [DIR(:).isdir]; %  returns logical vector
nameFolds = {DIR(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];
TimeInt = [0.32, 0.6];

for i= 1:size(nameFolds)
    
   kh_UTest_normalize( strcat(ControlsFolder, filesep, nameFolds{i,1}), nameFolds{i}, TimeInt)
    
end


end



function kh_UTest_normalize (SubjectPath, SubjectName, TimeInt)

% 
SubjectToAnalyse = '/home/kh/data/controls_SAM/zzz_ms';
if 0 == strcmp (SubjectPath, SubjectToAnalyse)
    return
end


Path = strcat (SubjectPath, filesep, 'keptTrials');
cd (Path)

PathUtest = strcat('Utest_LR_', num2str(TimeInt(1,1)), '_', num2str(TimeInt(1,2)), 's', '+orig');

disp(['!@auto_tlrc -apar ', 'orthoMNI_avg152T1+tlrc',' -suffix MNI -input ', PathUtest, ' -ok_notice']);
eval(['!@auto_tlrc -apar ', 'orthoMNI_avg152T+tlrc',' -suffix MNI -input ', PathUtest, ' -dxyz 5']);

% !@auto_tlrc -apar orthoMNI_avg152T+tlrc -input ERF+orig -dxyz 5  

FileName = strcat('Utest_LR_', num2str(TimeInt(1,1)), '_', num2str(TimeInt(1,2)), 'sMNI+tlrc'); 
 
eval(['!3dcalc -a /home/kh/data/mniBrain01+tlrc -b ', FileName, ' -prefix ', strcat('brain01_', FileName), ' -exp ', 'b*a'])

end
