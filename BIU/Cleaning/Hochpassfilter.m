cleanData=correctHB('tr_lf_c,rfhp0.1Hz', 1017.25);
ObjXcr=fdesign.highpass('Fst,Fp,Ast,Ap',0.001,1,60,1,sRate);%
FiltXcr=design(ObjXcr ,'butter');
ECG = myFilt(meanMEG,FiltXcr);
plot(ECG)
ObjXcr=fdesign.highpass('Fst,Fp,Ast,Ap',0.00001,1,60,1,sRate);%
FiltXcr=design(ObjXcr ,'butter');
ECG = myFilt(meanMEG,FiltXcr);
plot(ECG)
ObjXcr=fdesign.highpass('Fst,Fp,Ast,Ap',0.00001,1.1,60,1,sRate);%
FiltXcr=design(ObjXcr ,'butter');
ECG = myFilt(meanMEG,FiltXcr);
plot(ECG)
ObjXcr=fdesign.highpass('Fst,Fp,Ast,Ap',0.00001,2,60,1,sRate);%
FiltXcr=design(ObjXcr ,'butter');
ECG = myFilt(meanMEG,FiltXcr);
plot(ECG(1:10172))
hdr=ft_read_header('tr_lf_c,rfhp0.1Hz')
cfg=[]
cfg.trl=[1 hdr.nSamples 0];
cfg.dataset='tr_lf_c,rfhp0.1Hz';
cfg.channel='MEG';
cfg.bpfilter='yes';;
cfg.bpfreq
cfg.bpfilter='no';;
cfg.hpfilter='yes';;
cfg.hpfreq=1;
cfg.demean='yes';
data=ft_preprocessing(cfg);
plot(mean(data.trial{1,1}))
clear cleanData
hpData=data.trial{1,1};
save hpData hpData
save hpData hpData -v7.3
label=data.label;
save label label
clear
cleanData=correctHB('hpData.mat', 1017.25);
load('label.mat')
rewrite_pdf(cleanData,label,'tr_lf_c,rfhp0.1Hz','hb') %
kh_rewrite_pdf(cleanData,label,'tr_lf_c,rfhp0.1Hz','hb') %