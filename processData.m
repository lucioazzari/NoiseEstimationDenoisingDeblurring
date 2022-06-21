function [noisy,denoised,deblurred] = processData(inputPath,outputPath,processingType,optionalParams)
%% check depndencies and add subfolder paths for auxiliary functions
checkDependencies();

%% load data
noisy = double(tiffreadVolume(inputPath));

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

%% set up default processing parameters and check optional inputs
if ~exist('optionalParams','var')
    optionalParams.useDefaultParams = true;
else
    optionalParams.useDefaultParams = false;
end

[allProcessingParameters] = getProcessingParameters(processingType,...
                                                    noisy,...
                                                    optionalParams);

%% noise estimation
if ~allProcessingParameters.enableBlocks.estimatePSD
    [noiseParams,~] = estimateAllNoiseParams(noisy,...
                                             'estNoiseParams',...
                                             1);
else
    [noiseParams,PSD] = estimateAllNoiseParams(noisy,...
                                               'estAll',...
                                               1);
    if exist('optionalParams','var') && isfield(optionalParams,'maxBinSize')
        save(optionalParams.noiseParamsPath,'noiseParams','PSD');
    else
        save('noiseParameters.mat','noiseParams','PSD');
    end
end

%% denoising
if allProcessingParameters.enableBlocks.doDenoising
    denoised = chunckRF3D(noisy,noiseParams,...
                          allProcessingParameters.maxBinSize,...
                          allProcessingParameters.filterStrenght,...
                          allProcessingParameters.enableEstimationPSD);
    output = denoised;
end

%% deblurring
if allProcessingParameters.enableBlocks.doDeblurring
    regParams = 1e-4*sqrt(max(noisy(:))/300);
    deblurred = applyDeblurring(denoised,...
                                allProcessingParameters.PSF,...
                                regParams);
    output = deblurred;
end

%% write output
writeTIFF(output,outputPath)