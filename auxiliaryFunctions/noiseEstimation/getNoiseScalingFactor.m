function [ratio] = getNoiseScalingFactor(data,noiseParams)

step = 8;

mm = [];
vv = [];
for ii=1:step:(size(data,3)-step+1)
    chunk = data(:,:,ii:ii+step-1);
    mm = cat(3,mm,mean(chunk,3));
    vv = cat(3,vv,var(chunk,[],3));
end

[qq] = quantile(mm(:),[0.05 0.95]);
ind_mm = mm>qq(1) & mm<qq(2);

[qq] = quantile(vv(:),[0.05 0.95]);
ind_vv = vv<qq(2);

ind_tot = ind_mm & ind_vv;

% scatter(mm(:),vv(:),'o')
% hold on
% scatter(mm(ind_tot),vv(ind_tot),'.')

p = polyfit(mm(ind_tot),vv(ind_tot),1);

dataMean = mean(mm(:));
ratio = polyval(p,dataMean) / polyval(noiseParams,dataMean);