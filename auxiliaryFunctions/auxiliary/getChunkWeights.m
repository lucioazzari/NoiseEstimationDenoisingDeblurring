function W = getChunkWeights(chunk,alpha)
%% implementation of Tukey windowing function
alpha = max(0,alpha);
sz = [size(chunk,1) size(chunk,2)];

Tukey_fun = @(k,M,a) 0.5*(1 + cos(pi*(abs(k-M)-a*M)/(1-a)/M)) .* (abs(k-M)>=(a*M)) + ...
                   1 .* (abs(k-M)<(a*M));


Nx = (sz(2)-1)/2;
Ny = (sz(1)-1)/2;

XX = 0:(sz(2)-1);
YY = 0:(sz(1)-1);

wXX = Tukey_fun(XX,Nx,alpha);
wYY = Tukey_fun(YY,Ny,alpha);

W = wXX .* wYY';