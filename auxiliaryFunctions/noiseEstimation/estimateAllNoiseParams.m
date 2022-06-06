function [noiseParams,PSD] = estimateAllNoiseParams(data,estimateType,binSize)
%% estimate noiseParams
noiseParams = [];
if strcmp(estimateType,'estAll') || strcmp(estimateType,'estNoiseParams')
    [noiseParams] = estimateNoiseParams(data,binSize);
end
%% estimate PSD
PSD = [];
if strcmp(estimateType,'estAll') || strcmp(estimateType,'estPSD')
    [PSD] = estimatePSD(data);
end