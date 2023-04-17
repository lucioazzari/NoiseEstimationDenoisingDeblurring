function D = chunckRF3D(data,noiseParams,maxBinSize,filterStrenght,enableEstimationPSD)

if all(size(data(:,:,1)) > 512)

    if isempty(gcp('nocreate'))
        parpool;
    end
    pctRunOnAll warning off
    
    % divide a sequence in 9 spatially overlapping chuncks that will the be
    % reconstracuted after individual processing
    
    maxChunckSize = 512;
    numChunckPerDim = ceil(max(size(data(:,:,1)))/maxChunckSize);
%     numChunckPerDim = 3;
    overlap = 0.25; % 25% of overlap bewteen chunks
    
    seqSize = size(data);
    lenChunk = ceil(seqSize / numChunckPerDim);
    
    chunkNumber = combvec(1:numChunckPerDim,1:numChunckPerDim);
    chuncksCoo = cell(1,size(chunkNumber,2));
    chuncks = cell(1,size(chunkNumber,2));
    
    %% denoise chuncks
    parfor indChunk = 1:size(chunkNumber,2)
        
        indVer = chunkNumber(2,indChunk);
        indHor = chunkNumber(1,indChunk);
        
        sV = max(1, round((indVer - 1)*lenChunk(1) + 1 - lenChunk(1)*overlap/2));
        eV = min(seqSize(1),round(sV + lenChunk(1) - 1 + lenChunk(1)*overlap/2));
        
        sH = max(1, round((indHor - 1)*lenChunk(2) + 1 - lenChunk(2)*overlap/2));
        eH = min(seqSize(2),round(sH + lenChunk(2) - 1 + lenChunk(2)*overlap/2));
        
        dataWorker = data(sV:eV,sH:eH,:);
        D = iterativeVST_denoising(dataWorker,noiseParams,maxBinSize,filterStrenght,enableEstimationPSD);
        
        chuncksCoo{indChunk} = [sV,eV;sH,eH];
        chuncks{indChunk} = D;
    end
    
    %% reassemble chunks
    D = zeros(size(data));
    weights = zeros(size(data));
    for indChunk = 1:size(chunkNumber,2)
        
        coo = chuncksCoo{indChunk};
        
        sV = coo(1,1);
        eV = coo(1,2);
        
        sH = coo(2,1);
        eH = coo(2,2);
        
        D_chunck = chuncks{indChunk};

        alpha = 0.5;
        W = max(eps('single'),getChunkWeights(D_chunck,alpha));
        
        D(sV:eV,sH:eH,:) = D(sV:eV,sH:eH,:) + D_chunck.*W;
        
        weights(sV:eV,sH:eH,:) = weights(sV:eV,sH:eH,:) + W;
    end
    
    D = D./weights;
else
    warning off
    D = iterativeVST_denoising(data,noiseParams,maxBinSize,filterStrenght,enableEstimationPSD);
end