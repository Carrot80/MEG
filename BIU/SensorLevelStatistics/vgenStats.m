% Sensor Level analysis:
% Compute Diff between abs left and right values
ga=grandavgBL_Planar_controls_keepInd;
ga=grandavgBL_controls_keepInd;
[~,Li]=ismember(LRpairs(:,1),ga.label); % ga ) grandaverage with individually kept trials, LRpairs is file from Yuval
[~,Ri]=ismember(LRpairs(:,2),ga.label);
gaLR=ga;
gaLR.individual=zeros(size(gaLR.individual)); % die mittleren Sensoren behalten Nullen
gaLR.individual(:,Li,:)=abs(ga.individual(:,Li,:))-abs(ga.individual(:,Ri,:));
gaLR.individual(:,Ri,:)=abs(ga.individual(:,Ri,:))-abs(ga.individual(:,Li,:));

aliceTtest0(gaLR, 0.4, 1);
vgenTtest0(gaLR, 0.405, 1,0.001,ga); % Input Nr. 3 = p-value, use fieldtrip-version from BIU
vgenTtest0(gaLR, 0.17, 1,0.01,ga);
vgenTtest0(gaLR, 0.3, 1,0.05,ga);


% compute RMS => not necessary for planar gradiometer
rmsL=squeeze(sqrt(mean(ga.individual(:,Li,:).^2,2)));
rmsR=squeeze(sqrt(mean(ga.individual(:,Ri,:).^2,2)));
rmsbothHem=squeeze(sqrt(mean(ga.individual(:,:,:).^2,2)));
s0=nearest(ga.time,0); % BIU_fieldtrip has to be added
s700=nearest(ga.time,0.7);
p=ones(1, length(rmsL));
for si=s0:s700
[~,p(si)] = ttest(rmsL(:,si),rmsR(:,si)); % BIU_fieldtrip has to be added
end
sig=find(p<0.05);
figure;plot(ga.time,mean(rmsL),'r')
hold on
plot(ga.time,mean(rmsR))
plot(ga.time(sig),1.1*squeeze(max(mean(rmsL))),'k*');
legend('L','R','sig')

t1=0.47;s1=nearest(ga.time,t1);
t2=0.6;s2=nearest(ga.time,t2);
areaL=trapz(ga.time(s1:s2),rmsL(:,s1:s2)');
areaR=trapz(ga.time(s1:s2),rmsR(:,s1:s2)');
[~,p]=ttest(areaL,areaR)

hRi=area(ga.time(s1:s2),mean(rmsL(:,s1:s2)));
set(hRi,'FaceColor','r','EdgeColor','r')
hLi=area(ga.time(s1:s2),mean(rmsR(:, s1:s2)));
set(hLi,'FaceColor','w','EdgeColor','w')
title(strcat('Area Under Curve - p<0.05'))



%%

cfg=[];
cfg.method='RMS';
cfg.neighbours='all';
gadomRMSall=clustData(cfg,gadom);
gasubRMSall=clustData(cfg,gasub);

timelim=[0.32 0.47];
samp1=nearest(rmsL,timelim(1));
samp2=nearest(rmsL,timelim(2));
timeline=rmsL.time(1,samp1:samp2);
Lcurve=squeeze(rmsL.individual(:,1,samp1:samp2))';
Rcurve=squeeze(rmsR.individual(:,1,samp1:samp2))';
LArea=trapz(timeline,Lcurve);
RArea=trapz(timeline,Rcurve);
[~,b]=ttest(LArea,RArea)
hR=area(timeline,mean(RArea,2));
set(R,'FaceColor','r','EdgeColor','r')
hL=area(timeline,mean(Lcurve,2));
set(hL,'FaceColor','w','EdgeColor','w')