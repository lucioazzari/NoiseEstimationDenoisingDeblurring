function [SNR] = getRoughSNR(data)

dd = diff(data,1,3);

mm2 = mean(data(:))^2;
vv = var(dd(:));

SNR = mm2/vv;