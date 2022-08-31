function yhat=iterativeVST_denoising(z,p,binSize,filterStrenght,enableEstimationPSD)
%% Set binning and convex combination params
hS = binSize:-2:1;
lambdaS = [1 0.5*ones(1,numel(hS)-1)];

% lambdaS = [1 0.5 0.5];
% hS = [5 3 1];

%% Iterative denoising
yhat=z;
for indLoop=1:numel(lambdaS)  
    %% Get binning and convex combination params for current loop
    lambda=lambdaS(indLoop);  % lambda for current iteration
    h=hS(indLoop);            % bin size for current iteration
    
    %% Process data
    if lambda>0  % if lambda=0, there is no noise in z_i, thus previous estimate of yhat is not modified
        %% convex combination
        if indLoop>1
            z_i=lambda*z+(1-lambda)*yhat;
        else
            z_i=z;
        end
        
        %% Binning
        if size(z_i,3)>1
            z_B=binning(z_i,'all',h);
            scale_b = h^3;
        else
            z_B=bin_B_h(z_i,h);
            scale_b = h^2;
        end
        
        %% Apply forward VST
        a = p(1)*lambda^2;
        b = p(2)*scale_b*lambda^2;
        fz = apply_GenAncombe(z_B,[a b],true);
        
        %% AWGN DENOISING
        % Scale the image (BM3D processes inputs in [0,1] range)
        desiredRange = [0.05 0.95];
        [getScaledData,getInverseScaledData,getScalingVarianceFactor] = getScalingTransforms(fz,desiredRange);
        fz = getScaledData(fz);
        
        if enableEstimationPSD
            [PSD] = estimatePSD(fz);
%             PSD = PSD / mean(PSD(:));
        else
            PSD = ones(8);
        end
        
%         load('custom_PSD.mat','PSD');
        
        estSTD = sqrt(getScalingVarianceFactor(1));%estimateSTD(fz);
        
        D = RF3D(fz, filterStrenght*estSTD, 0, PSD, zeros(8),'dct');
        
        % Scale back to the initial VST range
        D = getInverseScaledData(D);
        
        %% Apply the inverse VST for convex combination z_i of Poisson z and estimate yhat
        yhat = apply_GenAncombe(D,[a b],false);
        
        %% Debinning
        if size(z_i,3)>1
            yhat=debinning(yhat,'all',h,size(z)); 
        else
            yhat=debin_Binv_h(yhat,size(z),h,9);
        end
    end
end