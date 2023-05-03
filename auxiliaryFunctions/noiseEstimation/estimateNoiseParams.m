function [noiseParams] = estimateNoiseParams(data,binSize)

zBin = binning(data, 'all', binSize);

MM = max(zBin(:));

zBinNorm = [];
for ii=1:min(15,size(zBin,3))
    zBinNorm = cat(2, zBinNorm, zBin(:,:,ii) / MM);
end

[p] = callClipPoiGau(zBinNorm);
if sign(p(1))==-1
    disable_clipping = true;
    [p] = callClipPoiGau(zBinNorm,disable_clipping);
end
if sign(p(1))==-1
    disable_clipping = true;
    [p] = callClipPoiGau(zBinNorm,disable_clipping);
end
if sign(p(1))==-1
    disable_clipping = true;
    sign_ind_noise_model = true;
    [p] = callClipPoiGau(zBinNorm,disable_clipping,sign_ind_noise_model);
end

clear zBinNorm zBin

% because we are measuring this [a/MM,b*h^3/MM^2] we have to compute the
% correct a and b
noiseParams = [p(1)*MM, p(2)/binSize^3*MM^2];