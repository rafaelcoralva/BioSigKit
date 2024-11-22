function [idx_P,idx_Q,idx_R,idx_S,idx_T] = BioSigKit_ecg_pqrst_detection(fs, preprocessed_ecg, ecg_algo)
% Function to call BioSigKit wrapper and use the MTEO to detect and the return the index positions 
% of P,Q,R,S, and T wave peaks of an input (preprocessed) ECG.

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
% idx_P/Q/R/S/T (vectors of potentially different lengths) - Index positions of P/Q/R/S/T waves in the input (preprocessed) ECG.

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
idx_Results = BioSigKitAnalysis.Results; 

% Packaging output.
detected_waves = fieldnames(idx_Results);

if sum(contains(detected_waves,'P'))
    idx_P = idx_Results.P;
else
    idx_P = [];
end

if sum(contains(detected_waves,'Q'))
    idx_Q = idx_Results.Q;
else
    idx_Q = [];
end

if sum(contains(detected_waves,'R'))
    idx_R = idx_Results.R;
else
    idx_R = [];
end

if sum(contains(detected_waves,'S'))
    idx_S = idx_Results.S;
else
    idx_S = [];
end

if sum(contains(detected_waves,'T'))
    idx_T = idx_Results.T;
else
    idx_T = [];
end
end

