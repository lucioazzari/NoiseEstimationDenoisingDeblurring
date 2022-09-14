function allOK = checkDependencies()

allOK = true;

rf3dPackage = exist('RF3D.m','file');
clipPoisGausPackage = exist('function_ClipPoisGaus_stdEst2D.p','file');
invansc_v3Package = exist('GenAnscombe_forward.m','file');

if ~rf3dPackage     
    fprintf('The software is missing the RF3D package. Please download the package from: \n%s\nunzip it and add it to Matlab source path (see demo).\n\n','https://webpages.tuni.fi/foi/GCF-BM3D/RF3D_v1p1p1.zip')
    allOK = false;
end

if ~clipPoisGausPackage     
    fprintf('The software is missing the ClipPoiGaus package. Please download the package from: \n%s\nunzip it and add it to Matlab source path (see demo).\n\n','https://webpages.tuni.fi/foi/ClipPoisGaus_stdEst2D_v232.zip')
    allOK = false;
end

if ~invansc_v3Package     
    fprintf('The software is missing the invans package. Please download the package from: \n%s\nunzip it and add it to Matlab source path (see demo).\n\n','https://webpages.tuni.fi/foi/invansc/invansc_v3.zip')
    allOK = false;
end