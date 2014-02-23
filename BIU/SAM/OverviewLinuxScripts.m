% Übersicht über Linux-Skripte
% Beispielskripte von Yuval:
Script_SAM_Yuval % Yuvals Vorlage für SAM_Beamforming und für Berechnung von virtuellen Sensoren und Multiplikation von Weights mit AVG 


% eigene Skripte in chronologischer Reihenfolge:

kh_SAM_Beamformer % eigenes Skript, um SAM_Beamforming durchzuführen
SAM_normalize % um SAM_results und Orthogonale Anatomie zu normalisieren in MNI avgT152
SAM_Timeinterval % calculates mean activity for time intervals
(ERF_transform2MNIspace.m) % nachträgliche transformation der funktionellen Daten zum MNI space, da vorher falsches template verwendet
Reduce_ERF2Brain01.m % reduces die ERF activity which expands the brain after MNI Normalization back to Brain Volume size
kh_z_scoreNormalizationERF.m 
% creating AVG for  all controls:
kh_avg
LR_ttest % U-Test for Left and Right Hemisphere created by Yuval

smaller_timeintervals.m  % includes Reduce_ERF2Brain01.m and kh_z_scoreNormalizationERF.m 

% Erstellung von ROI-Masken:

Create_ROI
FlipROI % flips left ROI to right Hemisphere

% Nützliche Skripte:

