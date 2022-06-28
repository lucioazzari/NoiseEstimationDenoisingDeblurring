function [allProcessingParameters] = getProcessingParameters(processingType,noisy,optionalParams)

%% enable processing blocks
if strcmp(processingType,'noiseEst')
    disp('Processing steps enabled: noise estimation')
    allProcessingParameters.enableBlocks.estimatePSD = true;
    allProcessingParameters.enableBlocks.doDenoising = false;
    allProcessingParameters.enableBlocks.doDeblurring = false;
elseif strcmp(processingType,'denoising')
    disp('Processing steps enabled: noise estimation, denoising')
    allProcessingParameters.enableBlocks.estimatePSD = false;
    allProcessingParameters.enableBlocks.doDenoising = true;
    allProcessingParameters.enableBlocks.doDeblurring = false;
elseif strcmp(processingType,'all')
    disp('Processing steps enabled: noise estimation, denoising, deblurring')
    allProcessingParameters.enableBlocks.estimatePSD = false;
    allProcessingParameters.enableBlocks.doDenoising = true;
    allProcessingParameters.enableBlocks.doDeblurring = true;
end

%% set up default parameters if optionalParams
if optionalParams.useDefaultParams
    if max(size(noisy(:,:,1)))<512
        allProcessingParameters.maxBinSize = 1;
    else
        allProcessingParameters.maxBinSize = 3;
    end
    allProcessingParameters.filterStrenght = 1;
    allProcessingParameters.enableEstimationPSD = false;
    deblurringStrenght = 1;
    allProcessingParameters.PSF = getPSF(noisy,deblurringStrenght);
    disp('*----------------*')
    fprintf('All defalt parameters will be used:\n');
    fprintf('maxBinSize=%d\n', allProcessingParameters.maxBinSize);
    fprintf('enableEstimationPSD=%d\n', allProcessingParameters.enableEstimationPSD);
    fprintf('Default PSF with width=%f\n', deblurringStrenght);
    disp('*----------------*')
else
    %% set up max binning size
    if isfield(optionalParams,'maxBinSize')
        maxBinSize = optionalParams.maxBinSize;
        maxBinSize = max(1,maxBinSize);% maxBinSize has to be minimum 1
        if mod(maxBinSize,2)==0
            maxBinSize = maxBinSize-1;
        end
        disp('*----------------*')
        fprintf('User input maxBinSize=%d\n', maxBinSize);
        disp('*----------------*')
    else
        [maxBinSize,SNR] = getMaxBinSize(noisy);
        if max(size(noisy(:,:,1)))>=512
            maxBinSize = max(3,maxBinSize);
        end
        disp('*----------------*')
        fprintf('The rough SNR estimate is: %f. maxBinSize=%d has been automatically estimated\n', SNR, maxBinSize);
        disp('*----------------*')
    end
    allProcessingParameters.maxBinSize = maxBinSize;
    
    %% set filter strenght
    if isfield(optionalParams,'filterStrenght')
        filterStrenght = optionalParams.filterStrenght;
        filterStrenght = max(0,filterStrenght);% maxBinSize has to be minimum 1
        disp('*----------------*')
        fprintf('User input filterStrenght=%f\n', filterStrenght);
        disp('*----------------*')
    else
        filterStrenght = 1;
        disp('*----------------*')
        fprintf('filterStrenght=%f has been set up to its default value\n', filterStrenght);
        disp('*----------------*')
    end
    allProcessingParameters.filterStrenght = filterStrenght;
    
    %% enable PSD estimation
    if isfield(optionalParams,'enableEstimationPSD')
        enableEstimationPSD = optionalParams.enableEstimationPSD;
        disp('*----------------*')
        fprintf('User input enableEstimationPSD=%d\n', enableEstimationPSD);
        disp('*----------------*')
    else
        enableEstimationPSD = false;
        disp('*----------------*')
        fprintf('enableEstimationPSD=%f has been set up to its default value\n', filterStrenght);
        disp('*----------------*')
    end
    allProcessingParameters.enableEstimationPSD = enableEstimationPSD;
    
    %% get PSF for deblurring
    if isfield(optionalParams,'PSF')
        PSF = optionalParams.PSF;
        disp('*----------------*')
        fprintf('User input PSF\n');
        disp('*----------------*')
    else
        if isfield(optionalParams,'deblurringStrenght')
            deblurringStrenght = optionalParams.deblurringStrenght;
        else
            deblurringStrenght = 1;
        end
        PSF = getPSF(noisy,deblurringStrenght);
        disp('*----------------*')
        fprintf('Default PSF with width=%f\n', deblurringStrenght);
        disp('*----------------*')
    end
    allProcessingParameters.PSF = PSF;
end
end

function PSF = getPSF(noisy,deblurringStrenght)
psfSupport = 25;
psfStd = sqrt(min(13,max(0.3,-0.4984 + 0.0039*min(size(noisy(:,:,1))))))*deblurringStrenght;
PSF = fspecial('gaussian', psfSupport, psfStd);
end