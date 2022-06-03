function [getScaledData,getInverseScaledData,getScalingVarianceFactor] = getScalingTransforms(data,desiredRange)

if desiredRange(2)<=desiredRange(1)
    error('Wrong range entry');
end

maxData = max(data(:));
minData = min(data(:));

rangeData = maxData-minData;
newRangeData = desiredRange(2) - desiredRange(1);

%% shift and scale data to [0 1]
shiftTo01 = @(dataToShift,mm,range) (dataToShift - mm)/range;

%% variance scaling function
getScalingVarianceFactor = @(varianceToScale) varianceToScale / rangeData^2 * newRangeData^2;

%% data scaling function
getScaledData = @(dataToScale) shiftTo01(dataToScale,minData,rangeData)*newRangeData + desiredRange(1);% scale and shift data to [desiredRange]

%% inverse of %% data scaling function
getInverseScaledData = @(dataToInverseScale) shiftTo01(dataToInverseScale,desiredRange(1),newRangeData)*rangeData + minData;