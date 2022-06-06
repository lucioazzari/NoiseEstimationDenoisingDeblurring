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

%% if the user does not specify the max binning size we automatically estimate it
if exist('optionalParams','var') && isfield(optionalParams,'maxBinSize')
    maxBinSize = optionalParams.maxBinSize;
    maxBinSize = max(1,maxBinSize);% maxBinSize has to be minimum 1
    if mod(maxBinSize,2)==0
        maxBinSize = maxBinSize-1;
    end
    dip('*----------------*')
    fprintf('User input maxBinSize=%d\n', maxBinSize);
    dip('*----------------*')
else
    [maxBinSize,SNR] = getMaxBinSize(data);
    disp('*----------------*')
    fprintf('The rough SNR estimate is: %f. maxBinSize=%d has been automatically estimated\n', SNR, maxBinSize);
    disp('*----------------*')
end

%% noise estimation
if strcmp(processingType,'all')
    [noiseParams,~] = estimateAllNoiseParams(data,'estNoiseParams',1);
elseif strcmp(processingType,'noiseEst')
    [noiseParams,PSD] = estimateAllNoiseParams(data,'estAll',1);
    save(optionalParams.noiseParamsPath,'noiseParams','PSD');
end

%% denoising
if strcmp(processingType,'all')
    denoised = chunckRF3D(data,noiseParams,maxBinSize);
elseif strcmp(processingType,'denoising')
    denoised = chunckRF3D(data,optionalParams.noiseParams,maxBinSize);
    writeTIFF(denoised,outputPath)
end

%% deblurring
psfSupport = 25;
psfStd = sqrt(min(13,max(0.3,-0.4984 + 0.0039*min(size(denoised(:,:,1))))));
PSF = fspecial('gaussian', psfSupport, psfStd);
regParams = 1e-4*sqrt(max(denoised(:))/300);
if strcmp(processingType,'all')
    deblurred = applyDeblurring(denoised,PSF,regParams);
    writeTIFF(deblurred,outputPath)
elseif strcmp(processingType,'denoising')
    deblurred = applyDeblurring(data,PSF,regParams);
    writeTIFF(deblurred,outputPath)
end
   
    
