function noiseParams = estimateAllNoiseParams(data,noiseModel,binSize)

[noiseParams] = estimateNoiseParams(data,binSize);
if strcmp(noiseModel,'colored')
    ratio = getNoiseScalingFactor(data,noiseParams);
    noiseParams = noiseParams*ratio;
end

if numel(noiseParams)==2
    disp(['Estimated signal-independent noise parameters: a = ' num2str(noiseParams(1)) ', b = ' num2str(noiseParams(2))...
        '. For the mean value of the sequence, that is , ' num2str(mean(data(:))) ', the noise has a standard deviation of ' num2str(sqrt(noiseParams(1)*mean(data(:))+noiseParams(2))) '.'])
elseif numel(noiseParams)==1
    disp(['Estimated signal-independent noise parameters: b = ' num2str(noiseParams(1)) '.']);
end