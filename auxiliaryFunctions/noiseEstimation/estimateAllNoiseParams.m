function noiseParams = estimateAllNoiseParams(data,noiseModel,binSize)

[noiseParams] = estimateNoiseParams(data,binSize);
if strcmp(noiseModel,'colored')
    ratio = getNoiseScalingFactor(data,noiseParams);
    noiseParams = noiseParams*ratio;
end