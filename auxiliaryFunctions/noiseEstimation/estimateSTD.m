function estSTD = estimateSTD(data)

dd = diff(data,1,3);

% estSTD = std(dd(:));
estSTD = 1.4826 * mad(dd(:),1);