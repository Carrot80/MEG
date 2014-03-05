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


% U-Tst for all controls:
kh_avg % creating AVG for  all controls:
LR_ttest % U-Test for Left and Right Hemisphere created by Yuval

smaller_timeintervals.m % includes Reduce_ERF2Brain01.m and kh_z_scoreNormalizationERF.m 
kh_avg
LRttest

% Erstellung von ROI-Masken:

Create_ROI
FlipROI % flips left ROI to right Hemisphere
ROIMaskrecalc.m % has to recalc right ROI, as it does not consist of values of one after sampling, but of 0,..7. Recalculated to resample values of 1

ROI_Analysis.m % looks for extrem values for each ROI and saves to Textfile
loadTextComputeLI.m % computes LIs of maximum values
extractActROI.m % extrahiert Aktivität aller Voxel aus ROI
extractfullActROI


% U-Test für einzelne Subjects: WICHTIG
kh_SAM_Beamforming_keepttrials.m % Wiederholung für AVGTrials, mitteln von 10er Gruppen
LR_ttest_ind.m % U-Test für verschiedene Zeitintervalle
UTest_normalize.m % NOrmalisierung in MNI space
extract_UValuesROI.m % Berechnung des LI-Wertes
kh_collect_LI % sammeln der Werte für alle Subjects in einer Matrix


% Nützliche Skripte:

