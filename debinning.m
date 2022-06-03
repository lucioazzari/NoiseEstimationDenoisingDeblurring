function out = debinning(inp, mode, count, sz)
% Perform debinning.
%   :param inp: 3-D input
%   :param mode: either 'angle' (1st dim), 'displacement' (2nd & 3rd), or 'all'
%   :param count: bin size
%   :param sz: output size (=original size before binning)

    if strcmp(mode, 'displacement') || strcmp(mode, 'all')
        out = zeros([size(inp, 1), sz(2), sz(3)], 'single');
        for ix = 1:size(out, 1)
           out(ix, :, :) = debin_Binv_h(squeeze(inp(ix, :, :)),sz(2:end), count, 20);
        end
        inp = out;
    end

    if strcmp(mode, 'angle') || strcmp(mode, 'all')
        out = debin_1D(inp, sz(1), count, 20, 1);
    end


end