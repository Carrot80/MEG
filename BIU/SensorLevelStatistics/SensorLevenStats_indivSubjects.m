% Sensor Level analysis for individual subjects:
% Compute Diff between abs left and right values
ga=avg_BL1;
[~,Li]=ismember(LRpairs(:,1),ga.label); % ga ) LRpairs is file from Yuval
[~,Ri]=ismember(LRpairs(:,2),ga.label);
gaLR=ga;
gaLR.avg=zeros(size(gaLR.avg)); % die mittleren Sensoren behalten Nullen
gaLR.avg(:,Li,:)=abs(ga.avg(:,Li,:))-abs(ga.avg(:,Ri,:));
gaLR.avg(:,Ri,:)=abs(ga.avg(:,Ri,:))-abs(ga.avg(:,Li,:));

kh_aliceTtest0_1subj(gaLR, 0.4, 1); % tests each hemisphere against zero for one subject, modified
vgenTtest0(gaLR, 0.4, 1,0.001,ga); % Input Nr. 3 = p-value, use fieldtrip-version from BIU
vgenTtest0(gaLR, 0.17, 1,0.01,ga);
vgenTtest0(gaLR, 0.3, 1,0.05,ga);