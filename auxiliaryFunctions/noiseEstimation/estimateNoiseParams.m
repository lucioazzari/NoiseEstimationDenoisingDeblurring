function [noiseParams] = estimateNoiseParams(data,binSize)

zBin = binning(data, 'all', binSize);

MM = max(zBin(:));

zBinNorm = [];
for ii=1:size(zBin,3)
    zBinNorm = cat(2, zBinNorm, zBin(:,:,ii) / MM);
end

[p] = callClipPoiGau(zBinNorm);

clear zBinNorm zBin

% because we are measuring this [a/MM,b*h^3/MM^2] we have to compute the
% correct a and b
noiseParams = [p(1)*MM, p(2)/binSize^3*MM^2];