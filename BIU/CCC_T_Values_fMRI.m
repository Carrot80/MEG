

%% Broca

Contr_Fluency=load(strcat('D:/Arbeit/LinuxExchange/data/Cluster_and_Locations_fMRI_t-values_Controls_Fluency_ROIs.mat'));
Pat_Fluency=load(strcat('D:/Arbeit/LinuxExchange/data/Cluster_and_Locations_fMRI_t-values_Patients_Fluency_ROIs.mat'));
Fluency_Broca=[Pat_Fluency.Table.Broca.Coord(:,13); Contr_Fluency.Table.Broca.Coord(:,13)]


Pat_VG=load(strcat('D:/Arbeit/LinuxExchange/data/Cluster_and_Locations_fMRI_t-values_Patients_Verbgeneration_ROIs.mat'));
Contr_VG=load(strcat('D:/Arbeit/LinuxExchange/data/Cluster_and_Locations_fMRI_t-values_Controls_Verbgeneration_ROIs.mat'));
VG_Broca=[Pat_VG.Table.Broca.Coord(:,13); Contr_VG.Table.Broca.Coord(:,13)]


Pcorr=corr(Fluency_Broca, VG_Broca); % normale Person Correlation

ccc=[2*corr(Fluency_Broca,VG_Broca).*std(Fluency_Broca).*std(VG_Broca)]./[std(Fluency_Broca)^2+std(VG_Broca)^2+(mean(Fluency_Broca)-mean(VG_Broca))^2 ];

%% Wernicke

Contr_Fluency=load(strcat('D:/Arbeit/LinuxExchange/data/Cluster_and_Locations_fMRI_t-values_Controls_Fluency_ROIs.mat'));
Pat_Fluency=load(strcat('D:/Arbeit/LinuxExchange/data/Cluster_and_Locations_fMRI_t-values_Patients_Fluency_ROIs.mat'));
Fluency_Wernicke=[Pat_Fluency.Table.Wernicke.Coord(:,13); Contr_Fluency.Table.Wernicke.Coord(:,13)]


Pat_VG=load(strcat('D:/Arbeit/LinuxExchange/data/Cluster_and_Locations_fMRI_t-values_Patients_Verbgeneration_ROIs.mat'));
Contr_VG=load(strcat('D:/Arbeit/LinuxExchange/data/Cluster_and_Locations_fMRI_t-values_Controls_Verbgeneration_ROIs.mat'));
VG_Wernicke=[Pat_VG.Table.Wernicke.Coord(:,13); Contr_VG.Table.Wernicke.Coord(:,13)]


Pcorr=corr(Fluency_Wernicke, VG_Wernicke); % normale Person Correlation

ccc=[2*corr(Fluency_Wernicke,VG_Wernicke).*std(Fluency_Wernicke).*std(VG_Wernicke)]./[std(Fluency_Wernicke)^2+std(VG_Wernicke)^2+(mean(Fluency_Wernicke)-mean(VG_Wernicke))^2 ];






%%

set(gca,'XTickLabel',{'left ';'Two';'Three';'Four'})