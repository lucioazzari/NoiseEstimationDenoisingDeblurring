function [PSD] = estimatePSD(data)

useMAD = true;
bs = [8,8];

dd = diff(data,1,3);

maxNumEl = 5*1e6;

splitData = false;
if numel(dd) > maxNumEl
    splitData = true;
end

if ~splitData
    [PSD] = estPSD_DCT(dd,bs,useMAD);
else
    maxNumChunks = 5;
    
    numSlicesPerChunk = floor(size(dd,3) / max(1,ceil(numel(dd)/maxNumEl)));
    PSD = [];
    
    count = 0;
    allIdx = 1:numSlicesPerChunk:(size(dd,3)-numSlicesPerChunk+1);
    for ii = allIdx
        ddTmp = dd(:,:,ii:ii+numSlicesPerChunk-1);
        [tmp] = estPSD_DCT(ddTmp,bs,useMAD);
        PSD = cat(3,PSD,tmp);
        count = count+1;
        if count > maxNumChunks
            break;
        end
    end
    PSD = median(PSD,3);
end

PSD(1) = max([PSD(1,2) PSD(2,1) PSD(2,2)]);

end

function [PSD] = estPSD_DCT(z,bs,useMAD)
% step = round(bs/4);
step = [3 3];

% MAD_third = @(x) 1/0.6745*median(abs(x-repmat(median(x,3),[1 1 size(x,3)])),3);

MAD_third = @(x) 1.4826 * mad(x,1,3);

clear w;

ind = 0;
for iF = 1:size(z,3)
    for iR = 1:step(1):(size(z,1)-bs(1)+1)
        for iC = 1:step(2):(size(z,2)-bs(2)+1)
            ind = ind + 1;
            w(:,:,ind) = dct2(z(iR:(iR + bs(1) -1), iC:(iC + bs(2) - 1),iF));
        end
    end
end

if useMAD
    PSD = (MAD_third(w)).^2;
else
    PSD = var(w,[],3);
end
end
