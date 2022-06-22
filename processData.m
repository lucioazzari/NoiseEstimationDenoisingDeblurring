function [noisy,denoised,deblurred] = processData(inputPath,outputPath,processingType,optionalParams)
% [noisy,denoised,deblurred] = processData(inputPath,outputPath,processingType,optionalParams)
% 
% INPUT:
%     inputPath: path to the signle-channel gray-scale multipage TIFF to be processed
%     outputPath: path where to store the signle-channel gray-scale multipage TIFF output
%     processingType [string]: processing block to be applied to the input ('noiseEst','denoising','all')
%     optionalParams: optional parameters for each processing block (see below for all the options)
% 
% OUTPUT:
%     noisy: noisy data read from inputPath
%     denoised: denoised data (if denoising is executed, otherwise empty)
%     deblurred: deblurred data (if deblurring is executed, otherwise empty)
%
% *----------------------------------------------------------------------------------------------------------------------------------*
% 
% Processing types:
% 1) noise estiation + denoising + deblurring: 'all' [default]
% 2) automatic noise parameters estimation: 'noiseEst'
% 3) noise estiation + denoising: 'denoising'
% 
% *----------------------------------------------------------------------------------------------------------------------------------*
% 
% NOISE ESTIMATION PARAMETERS
% 
% optionalParams.noiseParamsPath is the path where the user wants the noise parameters to be saved. They will be saved in mat format and can be loaded in Matlab afterwards. The parameters will be saved as affine noise parameters (a and b), and a noise PSD.
% NOTE: If processingType is set to 'noiseEst' and optionalParams.noiseParamsPath is not specified the noise parameters are saved in the working folder as 'noiseParameters.mat'
% 
% *----------------------------------------------------------------------------------------------------------------------------------*
% 
% DENOISING PARAMETERS
% 
% optionalParams.filterStrenght: adjusts the filter strenght. 
% optionalParams.filterStrenght is a positive scalar double that will be used to adjust the filter strenght. It is indepepndent from optionalParams.maxBinSize (see below), and it is applied to each denoising scale.
% 0 corresponds to no denoising, 1 corresponds to standard denoising, >1 corresponds to strong denoising
% 
% optionalParams.maxBinSize: is the bin size (positive scalar integer) corresponding to the smallest scale (in multiscale processing) used for denoising. 
% optionalParams.maxBinSize should be set to 1 most of the time. In case the noise is very strong, and the underlying noise-free signal is barely visible, then we recommend optionalParams.maxBinSize > 1.
% NOTE: optionalParams.maxBinSize must be odd and smaller or equal than 5; if not, the algorithm automatically converts it to the smallest odd value closest to the input and larger or equal than 1.
% For 'ordinary' noise strength (e.g., noise variance smaller than half of the data's dynamic range) optionalParams.maxBinSize=1 is recommended. 
% For 'strong' noise strength (e.g., noise variance between half and the data's dynamic range) optionalParams.maxBinSize=3 is recommended. 
% For 'very strong' noise strength (e.g., noise variance larger than the data's dynamic range) optionalParams.maxBinSize=5 is recommended.
% If optionalParams.maxBinSize is not specified, the algorithm will estimate it internally.
% 
% *----------------------------------------------------------------------------------------------------------------------------------*
% 
% DEBLURRING PARAMETERS
% 
% optionalParams.deblurringStrenght: adjusts the deblurring PSF width. Only used if optionalParams.PSF is not specified.
% optionalParams.deblurringStrenght is a strictly positive scalar double that will be used to adjust the width of the default PSF used for deblurring.
% 
% optionalParams.PSF: is the PSF to be used for deblurring. If given as input it overwrites the default isotropic PSF and it disables any optionalParams.deblurringStrenght given as input.
% 
% *----------------------------------------------------------------------------------------------------------------------------------*

%% check depndencies and add subfolder paths for auxiliary functions
fprintf('*--------------------------------------------------------------*\n');
fprintf('Processing starts\n');
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
fprintf('Processing parameters defined...\n');

%% noise estimation
if exist('optionalParams','var') && isfield(optionalParams,'noiseParamsPath')
    [noiseParams,PSD] = estimateAllNoiseParams(noisy,...
                                               'estAll',...
                                               1);
	save(optionalParams.noiseParamsPath,'noiseParams','PSD');
elseif ~allProcessingParameters.enableBlocks.estimatePSD
    [noiseParams,~] = estimateAllNoiseParams(noisy,...
                                             'estNoiseParams',...
                                             1);
else
    [noiseParams,PSD] = estimateAllNoiseParams(noisy,...
                                               'estAll',...
                                               1);
	save('noiseParameters.mat','noiseParams','PSD');
end
fprintf('Noise estimated...\n');

%% denoising
if allProcessingParameters.enableBlocks.doDenoising
    denoised = chunckRF3D(noisy,noiseParams,...
                          allProcessingParameters.maxBinSize,...
                          allProcessingParameters.filterStrenght,...
                          allProcessingParameters.enableEstimationPSD);
    output = denoised;
end
fprintf('Sequence denoised...\n');

%% deblurring
if allProcessingParameters.enableBlocks.doDeblurring
    regParams = 1e-4*sqrt(max(noisy(:))/300);
    deblurred = applyDeblurring(denoised,...
                                allProcessingParameters.PSF,...
                                regParams);
    output = deblurred;
end
fprintf('Sequence deblurred...\n');

%% write output
writeTIFF(output,outputPath)
fprintf('Output saved into %s\n',outputPath);
fprintf('Process finished correctly\n');
fprintf('*--------------------------------------------------------------*\n');