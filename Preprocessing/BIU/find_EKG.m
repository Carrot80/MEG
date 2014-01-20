cfg = [];
cfg.dataset     = 'hb_lf_n_c,rfhp0.1Hz';
data_org        = ft_preprocessing(cfg)


figure
chansel  = 339; 
plot(data_org.time{1,1}(1,1:100000), data_org.trial{1}(chansel, 1:100000))
xlabel('time (s)')
ylabel('channel amplitude (uV)')
legend(strcat(data_org.label(chansel), '_', num2str(chansel)))

 PathFigure = strcat (pwd, filesep, 'EOG_',num2str(chansel) ) ; 
 saveas(gcf, PathFigure, 'fig') 