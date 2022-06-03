function [noiseParams,PSD] = estimateAllNoiseParams(data,estimateType)
%% estimate noiseParams
noiseParams = [];
if strcmp(estimateType,'estAll') || strcmp(estimateType,'estNoiseParams')
    [SNR] = getRoughSNR(data);
    if SNR > 2
        binSize = 1;
    elseif SNR > 1.5
        binSize = 3;
    else
        binSize = 5;
    end
    [noiseParams] = estimateNoiseParams(data,binSize);
end
%% estimate PSD
PSD = [];
if strcmp(estimateType,'estAll') || strcmp(estimateType,'estPSD')
    [PSD] = estimatPSD(data);
end