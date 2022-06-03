%% download and unzip necessary external files
url = 'https://webpages.tuni.fi/foi/GCF-BM3D/RF3D_v1p1p1.zip';
RF3DFld = 'RF3D';
unzip(url, RF3DFld);

url = 'https://webpages.tuni.fi/foi/ClipPoisGaus_stdEst2D_v232.zip';
ClipPoisGausFld = 'ClipPoisGaus';
unzip(url, ClipPoisGausFld);

url = 'https://webpages.tuni.fi/foi/invansc/invansc_v3.zip';
invanscFld = 'invansc';
unzip(url, invanscFld);

%% add extracted files to matlab path and check dependencies
addpath(RF3DFld)
addpath(ClipPoisGausFld)
addpath(invanscFld)

checkDependencies();

%% create synthetic data
% read Matlab built-in video
vidObj = VideoReader('xylophone.mp4');
vidframes = read(vidObj,[100 Inf]);
sz = size(vidframes);
% convert RGB frames to grayscale
data = zeros(sz([1,2,4]));
for indFrame=1:sz(end)
    data(:,:,indFrame) = im2double(rgb2gray(vidframes(:,:,:,indFrame)));
end
clear vidframes sz

%% add noise
a = 5e-4;
b = 5e-5;
noisyData = data + sqrt(max(0,a.*data + b)).*randn(size(data));
noisyData = max(0,min(1,noisyData));

%% save data as a multipage TIFF at 16 bit
addpath(genpath('auxiliaryFunctions'));

demoSequencePath = 'demoSequance.tif';
writeTIFF(uint16(noisyData*(2^16-1)),demoSequencePath)

%% clear space and run processing
clearvars -except demoSequencePath
processingType = 'all';
outputPath = 'processedSequence.tif';
[data,denoised,deblurred] = processData(demoSequencePath,outputPath,processingType);
