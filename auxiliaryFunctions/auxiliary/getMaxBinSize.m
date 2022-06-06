function [binSize,SNR] = getMaxBinSize(data)

[SNR] = getRoughSNR(data);
if SNR > 4
    binSize = 1;
elseif SNR > 1.5
    binSize = 3;
else
    binSize = 5;
end