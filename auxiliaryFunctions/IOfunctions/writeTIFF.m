function writeTIFF(data,filePath)

imwrite(data(:,:,1), filePath)
for ii=1:size(data,3)
    imwrite(data(:,:,ii), filePath, 'writemode', 'append')
end