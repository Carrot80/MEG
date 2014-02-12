int_beg = 0.350;
int_end = 0.650;



fs = 1017.25
size_vs=size(vs)

offset_samples = 509;
vs_1_1000ms = vs(:,offset_samples:size_vs(2));
size_vs_1_1000ms=size(vs_1_1000ms);
time_samples=1:size_vs_1_1000ms(2);
time_sec=time_samples./fs;


plot(time_sec,vs_1_1000ms)
axis tight


sample_int_Beg=size(find(time_sec<=int_beg));
sample_int_End=size(find(time_sec<=int_end));

vs_IntOfIn=vs_1_1000ms(:,sample_int_Beg(2):sample_int_End(2));
sum_vs_IntOfIn = sum(vs_IntOfIn')


% Save it to see it in afni
cfg=[];
cfg.step=5;
cfg.boxSize=[-120 120 -90 90 -20 150];
str_timeInt= strcat('ERF', '-', num2str(int_beg), '-', num2str(int_end));
cfg.prefix = str_timeInt; % change prefix
% cfg.torig=-500;   %  comment if you want to sum up activity of specific time intervall
% cfg.TR=1/1.01725; % comment if you want to sum up activity of specific time intervall
% VS2Brik(cfg,vs);
% max(max(vs))
VS2Brik(cfg,1e+13*abs(sum_vs_IntOfIn')); % =>creates ERF+orig.Brik+Head 


