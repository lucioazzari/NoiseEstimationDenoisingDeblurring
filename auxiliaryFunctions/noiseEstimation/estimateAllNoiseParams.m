function [noiseParams,PSD] = estimateAllNoiseParams(data,estimateType,binSize)
%% estimate noiseParams
noiseParams = [];
if strcmp(estimateType,'estAll') || strcmp(estimateType,'estNoiseParams')
    [noiseParams] = estimateNoiseParams(data,binSize);
end
%% estimate PSD
PSD = [];
if strcmp(estimateType,'estAll') || strcmp(estimateType,'estPSD')
    a = noiseParams(1);
    b = noiseParams(2);
    fz = apply_GenAncombe(z_B,[a b],true);
    [PSD] = estimatePSD(fz);
    PSD = PSD / mean(PSD(:));
end