function [PSD] = estimatePSD_v2(data)

useMAD = true;

bs = [8,8,8];
step = [8 8 8];

MAD_third = @(x) 1.4826 * mad(x,1,3);

clear all_PSDs;

count = 0;
for iF = 1:step(3):(size(data,3)-bs(3)+1)
    for iR = 1:step(1):(size(data,1)-bs(1)+1)
        for iC = 1:step(2):(size(data,2)-bs(2)+1)
            count = count + 1;
            chunk = data(iR:(iR + bs(1) -1), iC:(iC + bs(2) - 1),iF:(iF + bs(3) -1));
            clear w;
            for ind =1:bs(3)
                w(:,:,ind) = dct2(chunk(:,:,ind));
            end
            if useMAD
                all_PSDs(:,:,count) = (MAD_third(w)).^2;
            else
                all_PSDs(:,:,count) = var(w,[],3);
            end
        end
    end
end

PSD = median(all_PSDs,3);
PSD(1) = max([PSD(1,2) PSD(2,1) PSD(2,2)]);