function checkDependencies()

rf3dPackage = exist('RF3D.m','file');
clipPoisGausPackage = exist('function_ClipPoisGaus_stdEst2D.p','file');
invansc_v3Package = exist('GenAnscombe_forward.m','file');

if ~rf3dPackage     
    error('The software is missing the RF3D package. Please download the package from: \n%s\nunzip it and add it to Matlab source path (see demo).','https://webpages.tuni.fi/foi/GCF-BM3D/RF3D_v1p1p1.zip')
end

if ~clipPoisGausPackage     
    error('The software is missing the ClipPoiGaus package. Please download the package from: \n%s\nunzip it and add it to Matlab source path (see demo).','https://webpages.tuni.fi/foi/ClipPoisGaus_stdEst2D_v232.zip')
end

if ~invansc_v3Package     
    error('The software is missing the invans package. Please download the package from: \n%s\nunzip it and add it to Matlab source path (see demo).','https://webpages.tuni.fi/foi/invansc/invansc_v3.zip')
end