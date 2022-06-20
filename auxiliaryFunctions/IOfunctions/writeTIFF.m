function writeTIFF(data,filePath)

data = uint16(data);

imwrite(data(:,:,1), filePath)
for ii=2:size(data,3)
    imwrite(data(:,:,ii), filePath, 'writemode', 'append')
end