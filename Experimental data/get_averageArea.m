function [Average_area, StdDeviation] = get_averageArea(imageHeight, wallLeft, wallRight, LayerHeight)

    MM_PER_PIXEL = 0.5/(2016-1531);

    
% imageHeight is in the unit of pixel, LayerHeight is in the unit of mm.    
% Revise the LayerHeight to the unit of pixel, layerHeight.
% wallLeft and wallRight are of vector form. the size of each is
% imageHeight.

% Here simply round layerHeight to the nearest integer of the result.
% nLayer is the size of the sample.
layerHeight = floor(LayerHeight/MM_PER_PIXEL);
adjustRatio=LayerHeight/MM_PER_PIXEL-layerHeight;
nLayer = floor(imageHeight/layerHeight);

% Go through each row
% The area here is still in the unit of numbers of pixels.
areaGroup=zeros(nLayer,1);
for indLayer=1:nLayer
    for indRow=(indLayer-1)*layerHeight+1:indLayer*layerHeight-1
        areaGroup(indLayer)=areaGroup(indLayer)+wallRight(indRow)-wallLeft(indRow);
    end
    indRow=indRow+1;
    areaGroup(indLayer)=areaGroup(indLayer)+adjustRatio*(wallRight(indRow)-wallLeft(indRow));    
end

% average_Area and stdDeviation are in the unit of pixel
average_Area=mean(areaGroup');
stdDeviation=std(areaGroup');

% transform the unit
Average_area=average_Area*MM_PER_PIXEL^2;
StdDeviation=stdDeviation*MM_PER_PIXEL^2;

        


