function [data,denoised,deblurred] = processData(inputPath,outputPath,processingType,optionalParams)
%% check depndencies and add subfolder paths for auxiliary functions
checkDependencies();
addpath(genpath('auxiliaryFunctions'));

%% load data
data = double(tiffreadVolume(inputPath));

%% create ouput data
if strcmp(processingType,'noiseEst')
    denoised = [];
    deblurred = [];
elseif strcmp(processingType,'denoising')
    deblurred = [];
elseif strcmp(processingType,'deblurring')
    denoised = [];
else
    processingType = 'all';
end

%% noise estimation
if strcmp(processingType,'all')
    [noiseParams,~] = estimateAllNoiseParams(data,'estNoiseParams');
elseif strcmp(processingType,'noiseEst')
    [noiseParams,PSD] = estimateAllNoiseParams(data,'estAll');
    save(optionalParams.noiseParamsPath,'noiseParams','PSD');
end

%% denoising
if strcmp(processingType,'all')
    denoised = chunckRF3D(data,noiseParams);
elseif strcmp(processingType,'denoising')
    denoised = chunckRF3D(data,optionalParams.noiseParams);
    writeTIFF(denoised,outputPath)
end

%% deblurring
PSF = fspecial('gaussian', 25, sqrt(3.5));
regParams = 1e-4;
if strcmp(processingType,'all')
    deblurred = applyDeblurring(denoised,PSF,regParams);
    writeTIFF(deblurred,outputPath)
elseif strcmp(processingType,'denoising')
    deblurred = applyDeblurring(data,PSF,regParams);
    writeTIFF(deblurred,outputPath)
end
   
    
