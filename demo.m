%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This demo is meant to provide examples of how to use the processData
%  function that performs Noise Estimation, Denoising, and Deblurring
%  (NEDD).
%
%  The user can choose between two experiments. One with white noise (by
%  setting noiseModel = 'white') and one with colored noise (by setting
%  noiseModel = 'colored').
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% clear workspace
clearvars
clc

%% add processing functions to Matlab's path
addpath(genpath('auxiliaryFunctions'));

%% if not found, download and unzip necessary external files
allOK = checkDependencies();
if ~allOK
    url = 'https://webpages.tuni.fi/foi/GCF-BM3D/RF3D_v1p1p1.zip';
    RF3DFld = fullfile('downloadedPackages','RF3D');
    unzip(url, RF3DFld);

    url = 'https://webpages.tuni.fi/foi/ClipPoisGaus_stdEst2D_v232.zip';
    ClipPoisGausFld = fullfile('downloadedPackages','ClipPoisGaus');
    unzip(url, ClipPoisGausFld);

    url = 'https://webpages.tuni.fi/foi/invansc/invansc_v3.zip';
    invanscFld = fullfile('downloadedPackages','invansc');
    unzip(url, invanscFld);

    %% add extracted files to matlab path and check dependencies
    addpath(RF3DFld)
    addpath(ClipPoisGausFld)
    addpath(invanscFld)

    allOK = checkDependencies();
end

%% load data to be used for the demo
% read Matlab built-in video
vidObj = VideoReader(fullfile('data','testSequence.avi'));
vidframes = read(vidObj);
data = im2double(squeeze(vidframes));
clear vidframes sz

%% choose noise model
noiseModel = 'white';

%set signal-dependent noise function parameters
a = 10*5e-4;
b = 10*5e-5;

if strcmp(noiseModel,'white')%case of white noise
    noisyData = data + sqrt(max(0,a.*data + b)).*randn(size(data));
    noisyData = max(0,min(1,noisyData));
    noiseModel = 'white';
elseif strcmp(noiseModel,'colored')%case of colored noise
    kernel = fspecial('gaussian',13,1);
    kernel = kernel/sqrt(sum(kernel(:).^2));
    noisyData = data + sqrt(max(0,a.*data + b)).*convn(randn(size(data)),kernel,'same');
    
else
    error('Noise model not supported')
end

%% save data as a multipage TIFF at 16 bit
demoSequencePath = 'demoSequance.tif';
writeTIFF(uint16(noisyData*(2^16-1)),demoSequencePath)

%% clear space and run processing
clearvars -except demoSequencePath noiseModel

outputPath = 'processedSequence.tif';

optionalParams.maxBinSize = 1;
optionalParams.filterStrenght = 1;
optionalParams.enableDeblurring = true;
optionalParams.deblurringStrenght = 1;

[noisy,denoised,deblurred] = processData(demoSequencePath,outputPath,noiseModel,optionalParams);