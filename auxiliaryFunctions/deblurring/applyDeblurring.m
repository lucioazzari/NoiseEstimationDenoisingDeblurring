function [zRI,RI] = applyDeblurring(z,v,sigma2)

Xv = size(z,1);
Xh = size(z,2);
[ghy,ghx] = size(v);
big_v = zeros(Xv,Xh);

center_big_v        = ceil([Xv/2, Xh/2])+1;
start_big_v = center_big_v-floor(([ghy,ghy]-1)/2);
big_v(start_big_v(1):start_big_v(1)+ghy-1,start_big_v(2):start_big_v(2)+ghx-1) = v; % pad PSF with zeros to whole image domain, and center it

V = fft2(big_v); % frequency response of the PSF

Regularization_alpha_RI = 4e-4;
% sigma2 = max(eps,polyval(p,mean(z(:)))); %note eps is the minimum value of sigma2
RI= conj(V)./( (abs(V).^2) + Regularization_alpha_RI*Xv*Xh*sigma2);
RI(1)=1;

zRI = zeros(size(z));
for ii = 1:size(zRI,3)
    zRI(:,:,ii)  =ifftshift(real(ifft2(fft2(z(:,:,ii)).*RI)));   % RI OBSERVATION
end