function estSTD = estimateSTD(data)

dd = diff(data,1,3);

estSTD = std(dd(:));