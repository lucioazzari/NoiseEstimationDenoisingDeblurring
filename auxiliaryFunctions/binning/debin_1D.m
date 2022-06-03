function y_j=debin_1D(yBin,size_z,h,niter,d)
% 1-D debinning, modified from:
%
% L. Azzari and A. Foi, "Variance Stabilization for Noisy+Estimate
% Combination in Iterative Poisson Denoising", submitted, March 2016
%
% http://www.cs.tut.fi/~foi/invansc/
%
%  L. Azzari and Alessandro Foi - Tampere University of Technology - 2016 - All rights reserved.
% -----------------------------------------------------------------------------------------------


if h>1
    
    % binning
    hHalf  =  (h-double(mod(h,2)==1))/2;
    modPad=h-mod(size_z-1,h)-1;
    
    % how many pixels per bin? (may be different near boundaries)
    % n_counter = conv2(padarray(ones(size_z),modPad,'symmetric','post'),ones(h),'same');
    n_counter = conv(padarray(ones(size_z, 1),modPad,'symmetric','post'),ones(h, 1),'same');
    
    % coordinates of bin counts
    x1c  = hHalf+double(mod(h,2)==1)+[0 : size(yBin,d)-1]*h;
    
    % coordinates of bin centers
    x1  = hHalf+1-double(mod(h,2)==0)/2+[0 : size(yBin,d)-1]*h;
    
    % coordinates of image pixels
    ix1 = 1 : size_z;
    
    y_j=0;
    for jj=1:max(1,niter)
        
        % residual
        if jj>1
            r_j=yBin-bin_1D(y_j,h,d);
            %disp(num2str(max(abs(r_j(:))))); % print out maximum of residual, to show convergence
        else
            r_j=yBin;
        end
        
        % interpolation
        y_j=y_j+interp1(x1',r_j./n_counter(x1c),ix1','spline');
        
    end
else
    
    y_j=yBin;
    
end

return