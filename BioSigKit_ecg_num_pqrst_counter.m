function [num_p,num_q,num_r,num_s,num_t] = BioSigKit_ecg_num_pqrst_counter(fs, preprocessed_ecg, ecg_algo)
% Function to call BioSigKit wrapper and use the user-selected BioSigKit
% ECG fiducial point detector algorithm to obtain the number of P/Q/R/S/T
% waves in the input (preprocessed) ECG.

% INPUTS:
% fs (positive scalar) - ECG sampling frequency (in Hz).
% preprocessed_ecg (vector) - Preprocessed ECG signal.
% ecg_algo (positive integer scalar) - Choice of algorithm to detect p,q,r,s,t waves:
%   - 1 - Pan-Tompkins (R peaks only)
%   - 2 - Phase space (R peaks only)
%   - 3 - Filter bank (R peaks only)
%   - 4 - State machine (QRST)
%   - 5 - Multi-level TKEO (pqrst)

% OUTPUTS:
% num_P/Q/R/S/T (positive integer scalars) - Number of detected /Q/R/S/T waves in the input (preprocessed) ECG.

% Run BioSigKit.
BioSigKitAnalysis = RunBioSigKit(preprocessed_ecg,fs,0); 

% Extract detections from selected algorithm.
if ecg_algo == 1
    BioSigKitAnalysis.PanTompkins;   % Pan-Tompkins algorithm to detect R peaks.
elseif ecg_algo == 2
    BioSigKitAnalysis.PhaseSpaceAlg; % Phase space algorithm to detect R peaks.
elseif ecg_algo == 3
    BioSigKitAnalysis.FilterBankQRS; % Filter bank algorithm to detect R peaks.
elseif ecg_algo == 4
    BioSigKitAnalysis.StateMachine;  % State Machine algorithm to detect QRST peaks.
elseif ecg_algo == 5
    BioSigKitAnalysis.MTEO_qrstAlg;  % MTKEO algorithm to detect PQRST peaks.
end

% Extracting detected peak index positions.
ecg_results = BioSigKitAnalysis.Results; 

% Packaging output.
detected_waves = fieldnames(ecg_results);

if sum(contains(detected_waves,'P'))
    num_p = length(ecg_results.P);
else
    num_p = 0;
end

if sum(contains(detected_waves,'Q'))
    num_q = length(ecg_results.Q);
else
    num_q = 0;
end

if sum(contains(detected_waves,'R'))
    num_r = length(ecg_results.R);
else
    num_r = 0;
end

if sum(contains(detected_waves,'S'))
    num_s = length(ecg_results.S);
else
    num_s = 0;
end

if sum(contains(detected_waves,'T'))
    num_t = length(ecg_results.T);
else
    num_t = 0;
end
end
