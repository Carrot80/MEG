function [grandavgBL_controls_keepInd_diff_left, grandavgBL_controls_keepInd_diff_right]=AVGdiffLeftRight(LRpairs, grandavgBL_controls_keepInd)

% left
Channels_left = LRpairs(:,1) ;
ind_left=find(ismember(grandavgBL_controls_keepInd.label, Channels_left));
grandavgBL_controls_keepInd_diff_left=grandavgBL_controls_keepInd;
% grandavgBL_controls_left = grandavgBL_controls_keepInd_diff_left.label(ind_left);


grandavgBL_controls_keepInd_diff_left.individual = grandavgBL_controls_keepInd.individual(:,ind_left,:); % wichtige Variable
grandavgBL_controls_keepInd_diff_left.label = grandavgBL_controls_keepInd.label(ind_left);

% right:
Channels_right = LRpairs(:,1) ;
ind_right=find(ismember(grandavgBL_controls_keepInd.label, Channels_right));
grandavgBL_controls_keepInd_diff_right=grandavgBL_controls_keepInd;
% grandavgBL_controls_right = grandavgBL_controls_keepInd_diff_right.label(ind_right);

grandavgBL_controls_keepInd_diff_right.individual = grandavgBL_controls_keepInd.individual(:,ind_right,:); % wichtige Variable
grandavgBL_controls_keepInd_diff_right.label = grandavgBL_controls_keepInd.label(ind_right);


%  diff: 
grandavgBL_controls_keepInd_diff_left.individual = grandavgBL_controls_keepInd_diff_left.individual - grandavgBL_controls_keepInd_diff_right.individual;
grandavgBL_controls_keepInd_diff_right.individual = grandavgBL_controls_keepInd_diff_right.individual - grandavgBL_controls_keepInd_diff_left.individual;

LR=grandavgBL_controls_keepInd_diff_left;
LR.individual(:,116:230,:)=grandavgBL_controls_keepInd_diff_right.individual;
LR.label(116:230,1)=grandavgBL_controls_keepInd_diff_right.label;

layout = ft_prepare_layout(cfg, data)

%%
% verify left and right:
A = sort(Channels_left)
B = sort(grandavgBL_controls_left)
strcmp(A,B)

A = sort(Channels_right)
B = sort(grandavgBL_controls_right)
strcmp(A,B)

function statsSensorLevel (grandavgBL_controls_keepInd_diff_left, grandavgBL_controls_keepInd_diff_right)

aliceTtest0(LR, 0.4, 1)
aliceTtest0(grandavgBL_controls_keepInd_diff_right, 0.4, 1)

