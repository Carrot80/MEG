% Similarity and differences between subjects in 400ms field

cfg=[];
cfg.layout='4D248.lay';
cfg.interactive='yes';
cfg.xlim=[0.4 0.4];
figure;ft_topoplotER(cfg,avgBL_1);
title('CONTROL 1')
figure;ft_topoplotER(cfg,avgBL_2);
title('CONTROL 2')
figure;ft_topoplotER(cfg,avgBL_3);
title('CONTROL 3')
figure;ft_topoplotER(cfg,avgBL_4);
title('CONTROL 4')
figure;ft_topoplotER(cfg,avgBL_5);
title('CONTROL 5')
figure;ft_topoplotER(cfg,avgBL_6);
title('CONTROL 6')
figure;ft_topoplotER(cfg,avgBL_7);
title('CONTROL 7')
figure;ft_topoplotER(cfg,avgBL_8);
title('CONTROL 8')
figure;ft_topoplotER(cfg,avgBL_9);
title('CONTROL 9')
figure;ft_topoplotER(cfg,avgBL_10);
title('CONTROL 10')

handles=findall(0,'type','figure')
    for i=1:length(handles)
        FigNum=num2str(i)
        PathFigure = sprintf('%s_%s' , pwd, FigNum);
        h=figure(i)
        saveas(h, PathFigure, 'fig')  
    end

% Realign subjects correct fields for head position and size

function 
cfg=[];
cfg.template={avgBL_1.grad};
hs=ft_read_headshape('c,rfhp0.1Hz');
[o,r]=fitsphere(hs.pnt);
cfg.inwardshift=0.025;
cfg.vol.r=r;cfg.vol.o=o;
% cfg.trials=1;
avgBL_1_ra=ft_megrealign(cfg,avgBL_1);
