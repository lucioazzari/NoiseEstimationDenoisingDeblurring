function zBin=bin_1D(z,h,d)
% 1-D binning, modified from:
%
% L. Azzari and A. Foi, "Variance Stabilization for Noisy+Estimate
% Combination in Iterative Poisson Denoising", submitted, March 2016
%
% http://www.cs.tut.fi/~foi/invansc/
%
%  L. Azzari and Alessandro Foi - Tampere University of Technology - 2016 - All rights reserved.
% -----------------------------------------------------------------------------------------------

if h>1
    hHalf  =  (h-double(mod(h,2)==1))/2;
    modPad=h-mod(size(z,d)-1,h)-1;

    % zBin = conv2(padarray(z,modPad,'symmetric','post'),ones(h),'same');
    zBin = convn(padarray(z,[(d==1) * modPad, (d==2) * modPad, (d==3) * modPad],'symmetric','post'), ...
        ones(1 + (d==1) * (h - 1), 1 + (d==2) * (h - 1), 1 + (d==3) * (h - 1)),'same');

    % n_counter = conv2(padarray(ones(size(z)),modPad,0,'post'),ones(h),'same');  % how many pixels per bin? (may be different near boundaries)

    % coordinates of bin centres
    samples1  = hHalf+double(mod(h,2)==1) : h : size(zBin,d)-hHalf;

    if d == 1
        zBin=zBin(samples1,:,:);
    elseif d == 2
        zBin=zBin(:, samples1, :);
    else
        zBin=zBin(:, :, samples1);
    end
else
    zBin=z;
end


return

