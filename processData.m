function [noisy,denoised,deblurred] = processData(inputPath,outputPath,noiseModel,optionalParams)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  processData  is a collection of algorithms for noise estimation, denoising, and deblurring
%
%
%  FUNCTION INTERFACE:
%
%  [noisy,denoised,deblurred] = processData(inputPath,outputPath,noiseModel,optionalParams)
%
%  INPUT ARGUMENTS:
%
%  -- required --
%
%    'inputPath' : path to the signle-channel gray-scale multipage TIFF to be processed.
%
%   'outputPath' : path where to store the signle-channel gray-scale multipage TIFF output.
%
%   'noiseModel' : 'white' --> denoising of white noise (noise PSD disabled)
%                  'colored' --> denoising of colored noise (noise PSD enabled)
%
%
% -- optional --
%
%    'optionalParams.filterStrenght' : adjusts the filter strenght. It must be a positive scalar that 
%                                      will be used to adjust the filter strenght. It is applied to 
%                                      each denoising scale. Recommended values:
%                                        - As first denoising attempt, optionalParams.filterStrenght=1 
%                                          is recommended. This will use the automatically estimated
%                                          noise parameters.
%                                        - If the denoising result looks still noisy, use 
%                                          optionalParams.filterStrenght>1 (e.g., 1.5). In normal 
%                                          situtations we do not recommend to go over 3.
%                                        - If the denoising result looks oversmooth, use 
%                                          optionalParams.filterStrenght<1 (e.g., 0.5). If set to 0, 
%                                          the algorithm will not perform any denoising.
%
%        'optionalParams.maxBinSize' : bin size (positive scalar integer) corresponding to the smallest 
%                                      scale (in multiscale processing) used for denoising. 
%                                      optionalParams.maxBinSize should be set to 1 most of the time. 
%                                      In case the noise is very strong (low SNR), then it is 
%                                      recommended optionalParams.maxBinSize > 1:
%                                        - For 'ordinary' noise strength (e.g., noise variance smaller 
%                                          than half of the data's dynamic range) optionalParams.maxBinSize=1 
%                                          is recommended. 
%                                        - For 'strong' noise strength (e.g., noise variance between half 
%                                          and the data's dynamic range) optionalParams.maxBinSize=3 is 
%                                          recommended. 
%                                        - For 'very strong' noise strength (e.g., noise variance larger 
%                                          than the data's dynamic range) optionalParams.maxBinSize=5 is 
%                                          recommended.
%                                      NOTE: optionalParams.maxBinSize must be odd and smaller or equal 
%                                      than 5; if not, the algorithm automatically converts it to the 
%                                      smallest odd value closest to the input and larger or equal than 1.
%                                      
%                                      If optionalParams.maxBinSize is not specified, the algorithm will 
%                                      estimate it internally.
%
%  'optionalParams.enableDeblurring' : boolean variable that enables deblurring. Default value is false.
%
% 'optionalParams.deblurringStrenght' : adjusts the deblurring PSF width. Only used if optionalParams.PSF 
%                                       is not specified. It must be a strictly positive scalar that is 
%                                       used to adjust the width of the default PSF used for deblurring.
%
%                 'optionalParams.PSF': 2D PSF used for deblurring. If given as input, it overwrites the 
%                                       default isotropic PSF and it ignores optionalParams.deblurringStrenght.
%
%  OUTPUT:
%
%      'noisy' : noisy data read from inputPath (M x N x F double array)
%
%   'denoised' : denoised data (M x N x F double array)
%
%  'deblurred' : deblurred data (if deblurring is executed, otherwise empty) (M x N double array)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright (c) 2006-2022 Tampere University.
% All rights reserved.
% This work (software, material, and documentation) shall only
% be used for nonprofit noncommercial purposes.
% Any unauthorized use of this work for commercial or for-profit purposes
% is prohibited.
%
% AUTHOR:
%     L. Azzari
%     email: lucio.azzari@tuni.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% check depndencies and add subfolder paths for auxiliary functions
fprintf('*--------------------------------------------------------------*\n');
fprintf('Processing starts\n');
checkDependencies();

%% load data
noisy = double(tiffreadVolume(inputPath));

%% set up default processing parameters and check optional inputs
if ~exist('optionalParams','var')
    optionalParams.useDefaultParams = true;
else
    optionalParams.useDefaultParams = false;
end

[allProcessingParameters] = getProcessingParameters(noiseModel,...
                                                    noisy,...
                                                    optionalParams);
fprintf('Processing parameters defined...\n');

%% noise estimation
noiseParams = estimateAllNoiseParams(noisy,noiseModel,1);
fprintf('Noise estimated...\n');

%% denoising
denoised = chunckRF3D(noisy,noiseParams,...
                      allProcessingParameters.maxBinSize,...
                      allProcessingParameters.filterStrenght,...
                      allProcessingParameters.enableEstimationPSD);
output = denoised;
fprintf('Sequence denoised...\n');

%% deblurring
if allProcessingParameters.enableDeblurring
    regParams = 1e-4*sqrt(max(noisy(:))/300);
    deblurred = applyDeblurring(denoised,...
                                allProcessingParameters.PSF,...
                                regParams);
    output = deblurred;
    fprintf('Sequence deblurred...\n');
else
    deblurred = [];
end

%% write output
writeTIFF(output,outputPath)
fprintf('Output saved into %s\n',outputPath);
fprintf('Process finished correctly\n');
fprintf('*--------------------------------------------------------------*\n');
