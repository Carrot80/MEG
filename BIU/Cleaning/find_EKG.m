cfg = [];
cfg.dataset     = 'c,rfhp0.1Hz';
data_org        = ft_preprocessing(cfg)


figure
chansel  = 1; 
plot(data_org.time{1,1}(1,1:end), data_org.trial{1}(chansel, 1:end))
xlabel('time (s)')
ylabel('channel amplitude (uV)')
legend(strcat(data_org.label(chansel), '_', num2str(chansel)))

figure
chansel  = 338; 
plot(data_org.time{1,1}(1,100000:500000), data_org.trial{1}(chansel, 100000:500000))
xlabel('time (s)')
ylabel('channel amplitude (uV)')
legend(strcat(data_org.label(chansel), '_', num2str(chansel)))


 PathFigure = strcat (pwd, filesep, 'EOG_',num2str(chansel) ) ; 
 saveas(gcf, PathFigure, 'fig') 
 
cfg = [];
cfg.dataset     = 'c,rfhp0.1Hz';
data_org        = ft_preprocessing(cfg)

