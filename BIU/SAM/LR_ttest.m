
% Script written by Yuval:

ControlsFolder = '/home/kh/data/controls_SAM';

DIR = dir (ControlsFolder)
isub = [DIR(:).isdir]; %  returns logical vector
nameFolds = {DIR(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];

AVG = [];

for i= 1:size(nameFolds)
    SubjectPath = strcat(ControlsFolder, filesep, nameFolds{i,1});
    SubjectName = nameFolds{i};
    Path = strcat(SubjectPath, filesep, 'SAM');
    TimeBeg = .2;
    TimeEnd = .4;
    cd (Path)
    
    FileName = strcat('br_z_transf_brain01ERF_', num2str(TimeBeg), '-', num2str(TimeEnd), 's', '_', SubjectName, '+tlrc');   

    [V, Info] = BrikLoad (FileName);
    Vlr=flipdim(V,1);
    if i==1
        Vall=V;
        VlrAll=Vlr;
    else
        Vall(:,:,:,i)=V;
        VlrAll(:,:,:,i)=Vlr;
    end
end
U=zeros(size(V));
for i=1:36
    for j=1:44
        for k=1:36
            if Vall(i,j,k)>0
                p = ranksum(squeeze(Vall(i,j,k,:)),squeeze(VlrAll(i,j,k,:)));
                u=1-p;
                dif=mean(squeeze(Vall(i,j,k,:)))-mean(squeeze(VlrAll(i,j,k,:)));
                    if dif>0
                        R=1;% R is 1 when current is larger than other side
                    else
                        R=-1;
                    end
                U(i,j,k)=R*u;
            end
        end
    end
    i
end

OptTSOut.Scale = 1;
    OptTSOut.Prefix = ['UtestLR_200-310ms'];
    OptTSOut.verbose = 1;
    OptTSOut.View = '+tlrc'
    %Vsymm=double(Vlr+V>0);
    WriteBrik (U, Info, OptTSOut);

