function out = binning(inp, mode, count)
% Perform binning.
%   :param inp: 3-D input
%   :param mode: either 'angle' (1st dim), 'displacement' (2nd & 3rd), or 'all'
%   :param count: bin size

    sz = size(inp);
    if strcmp(mode, 'all')
        sz = ceil(sz/count);
    elseif strcmp(mode, 'displacement')
        sz = [sz(1), ceil(sz(2)/count), ceil(sz(3)/count)];
    elseif strcmp(mode, 'angle')
        sz = [ceil(sz(1)/count), sz(2), sz(3)];
    end

    if strcmp(mode, 'displacement') || strcmp(mode, 'all')
        out = zeros([size(inp, 1), sz(2), sz(3)]);
        for ix = 1:size(out, 1)
            out(ix, :, :) = bin_B_h(squeeze(inp(ix, :, :)), count);
        end
        inp = out;
    end

    if strcmp(mode, 'angle') || strcmp(mode, 'all')
        out = bin_1D(inp, count, 1);
    end

end