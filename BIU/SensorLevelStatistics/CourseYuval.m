% Course 11 Yuval:
% plot the fields
timepoint=0.4;
cfg=[];
cfg.zlim='maxmin';
cfg.xlim=[timepoint timepoint];
cfg.layout = '4D248.lay';
figure;
ft_topoplotER(cfg,grandavgBL_controls_keepInd)


% t-test per channel for one time point

cfgs=[];
cfgs.latency=[timepoint timepoint];
cfgs.method='stats';
cfgs.statistic='paired-ttest';
cfgs.design = [ones(1,10) ones(1,10)*2];  % according to number of subjects
[stat] = ft_timelockstatistics(cfgs, gasub,gadom); % funktioniert nur bei zwei verschiedenen Bedingungen


% Similarity and differences between subjects in 100ms field

cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
cfg.xlim=[0.4 0.4];
figure;ft_topoplotER(cfg,avgBL_1_ra);
title('SUBJECT 1')
figure;ft_topoplotER(cfg,avgBL_2);
title('SUBJECT 2')
figure;ft_topoplotER(cfg,avgBL_3);
title('SUBJECT 3')
figure;ft_topoplotER(cfg,avgBL_4);
title('SUBJECT 4')
figure;ft_topoplotER(cfg,avgBL_5);
title('SUBJECT 5')
figure;ft_topoplotER(cfg,avgBL_6);
title('SUBJECT 6')
figure;ft_topoplotER(cfg,avgBL_7);
title('SUBJECT 7')
figure;ft_topoplotER(cfg,avgBL_8);
title('SUBJECT 8')
figure;ft_topoplotER(cfg,avgBL_9);
title('SUBJECT 9')
figure;ft_topoplotER(cfg,avgBL_10);
title('SUBJECT 10')


% Realign subjects correct fields for head position and size

subjn='1';
cfg=[];
cfg.template={avgBL_1.grad};
hs=ft_read_headshape('hb_lf_c,rfhp0.1Hz');
[o,r]=fitsphere(hs.pnt);
cfg.inwardshift=0.025;
cfg.vol.r=r;cfg.vol.o=o;
% cfg.trials=1;
avgBL_1_ra=ft_megrealign(cfg,avgBL_1);



%% Compute planar gradient (megplanar) to reduce noise.
% 
% Relies on dipole topography. One subject, M400.

cfg=[];
cfg.method = 'distance';
cfg.feedback ='yes'; 
neighbours = ft_prepare_neighbours(cfg, avgBL_2)


cfg=[];
cfg.planarmethod   = 'orig';
cfg.neighbours     = neighbours;
[interp] = ft_megplanar(cfg, avgBL_2);

cfg=[];
cfg.combinegrad  = 'yes';
avgBL_2_planar = ft_combineplanar(cfg, interp)

cfgp = [];
cfgp.xlim=[0.4 0.4];
cfgp.layout = '4D248.lay';
figure;
ft_topoplotER(cfgp,avgBL_2_planar)
title('planar')
figure;
ft_topoplotER(cfgp,avgBL_2)
title('raw')

