
% Read trigger:

trig=readTrig_BIU;
trig=double(bitand(uint16(trig),4224));
trigSh=zeros(size(trig));
trigSh(2:end)=trig(1:end-1);
trigOnset=find((trig-trigSh)>0);
offset=round(0.3*1017.25);
trl=trigOnset'-offset;
trl(:,2)=trl+1017;
trl(:,3)=-offset;


cfg=[];
cfg.trl=trl;
cfg.dataset='hb_lf_c,rfhp0.1Hz';
% cfg.bpfilter='yes';
% cfg.bpfreq=
cfg.demean='yes';
cfg.channel='MEG';
raw=ft_preprocessing(cfg);

% HP-Filter to reject muscle activity:
cfg=[];
cfg.method='summary'; %trial
cfg.channel='MEG';
%cfg.alim=1e-12;
cfg.preproc.hpfilter    = 'yes';
cfg.preproc.hpfreq    = 60;


datacln=ft_rejectvisual(cfg, raw);

cfg=[];
cfg.method='abs';
cfg.criterion='sd';
cfg.critval=3;

[good,bad]=badTrials(cfg,data,1)



cfg=[];
cfg.bpfilter='yes';
cfg.bpfreq=[1 50];
cfg.demean='yes';
cfg.blcwindow=[-0.1 0];
cfg.trials=find(ismember(trl(:,1),datacln.sampleinfo(:,1)));
cln=ft_preprocessing(cfg,raw);
