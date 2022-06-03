function [noiseParams,PSD] = estimateAllNoiseParams(data,estimateType)
%% estimate noiseParams
if strcmp(estimateType,'estAll') || strcmp(estimateType,'estNoiseParams')
    binSize = 5;
    [noiseParams] = estimateNoiseParams(data,binSize);
end
%% estimate PSD
if strcmp(estimateType,'estAll') || strcmp(estimateType,'estPSD')
    [PSD] = estimatPSD(data);
end