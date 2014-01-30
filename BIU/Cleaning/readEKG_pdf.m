% Visualierung von Yuval: 

which createCleanFile
pdf = pdf4D('n_c,rfhp0.1Hz');
hdr = get(pdf, 'header')
chi = channel_index(pdf, '338', 'name');
chi
chi = channel_index(pdf, 'E1', 'name');
chi
chi = channel_index(pdf, 'EKG-1', 'name');
chi
chi = channel_index(pdf, 'E38', 'name');
chi
for i = 274:341; label{1,i}=channel_label(pdf,i);end
label
hdr.epoch_data{1,1}.pts_in_epoch
EKG=read_data_block(pdf,[1 hdr.epoch_data{1,1}.pts_in_epoch]],338);
EKG=read_data_block(pdf,[1 hdr.epoch_data{1,1}.pts_in_epoch],338);
plot(EKG)


%%

hdr.epoch_data{1,1}.pts_in_epoch
EKG=read_data_block(pdf,[1 hdr.epoch_data{1,1}.pts_in_epoch]],338);
EKG=read_data_block(pdf,[1 hdr.epoch_data{1,1}.pts_in_epoch],338);
plot(EKG)
save EKG
cleanData=correctHBk ('n_c,rfhp0.1Hz',);
open correctHB
cleanData=correctHB([],[],1,EKG);
cleanData=correctHB('n_c,rfhp0.1Hz',[],1,EKG);
close all
chi=channel_index(pdf,'A248')
A248=read_data_block(pdf,[1,hdr.epoch_data{1,1}.pts_in_epoch],248);
plot(EKG)/median(EKG);hold on;
plot(A248/median(A248),'k')
plot(EKG)/max(EKG(1000:10000));hold on;
plot(EKG/median(EKG));hold on;
plot(A248/median(A248),'k')
plot(EKG/mean(EKG(10000:20000));hold on;
plot(EKG/mean(EKG(10000:20000)));hold on;
plot(EKG/abs(mean(EKG(10000:20000))));hold on;
plot(A248/abs(mean(A248)),'k')
plot(EKG/abs(mean(EKG(10000:20000))));hold on;
plot(A248/abs(mean(A248)/5),'k')
plot(A248/abs(mean(A248)),'k')
plot(10*EKG/abs(mean(EKG(10000:20000))));hold on;
plot(A248/abs(mean(A248)),'k')
clean=LFcleanNoCue('n_c,rfhp0.1Hz',1017.25,'time','ADAPTIVE',50);
clean150=LFcleanNoCue(clean,1017.25,'time','ADAPTIVE',150);
kh_rewrite_pdf(clean150,[], 'n_c,rfhp0.1Hz,'lf') ;
kh_rewrite_pdf(clean150,[], 'n_c,rfhp0.1Hz','lf') ;
pdf2=pdf4D('lf_n_c,rfhp0.1Hz')
A248c=read_data_block(pdf2,[1,hdr.epoch_data{1,1}.pts_in_epoch],248);
plot(A248,'r')
hold on
plot(A248c,'b')
cfg = [];
cfg.dataset     = 'lf_n_c,rfhp0.1Hz';
cfg.trl=[1 10172 0];
cfg.channel='MEG';
data = ft_preprocessing(cfg)
avg=ft_timelockanalysis([],data)
absMEG=median(abs(data.trial{1,1}));
absMEG=median(abs(data.trial{1,1}),2);
avg.avg=absMEG;
avg.time=0;
ft_topoplotER([],avg)
cfg=[]
cfg.layout='4D248.lay';
ft_topoplotER(cfg,avg)
fftBasic(data.trial{1,1},1017.17
open fftBasic
[four,F]=fftBasic(data.trial{1,1},1017.25);
plot(four
who four
whos four
figure;plot(F,abs(four))
figure;plot(F,abs(four(end,:)))
hold on
plot(F,abs(four(1,:)))
plot(F,abs(four(1,:)),'g')
plot(data.time{1,1},data.trial{1,1}([1 248],:))
plot(data.time{1,1},data.trial{1,1}([247 248],:))
cfg = [];
cfg.dataset     = 'c,rfhp0.1Hz';
cfg.trl=[1 10172 0];
cfg.channel='MEG';
orig = ft_preprocessing(cfg)
cfg = [];
cfg.dataset     = 'c,rfhp0.1Hz';
cfg.trl=[1 10172 0];
cfg.channel='MEG';
orig = ft_preprocessing(cfg)
plot(data.time{1,1},data.trial{1,1}([247 248],:))
hold on
plot(data.time{1,1},orig.trial{1,1}([247 248],:),'r')
correctHB;
correctHB('c,rfhp0.1Hz');



cfg = [];
cfg.dataset     = 'c,rfhp0.1Hz';
cfg.trl=[1 10172 0];
cfg.channel='MEG';
orig = ft_preprocessing(cfg)
