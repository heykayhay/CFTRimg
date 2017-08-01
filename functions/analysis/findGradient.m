function [ maxGradient,maxGradientLocation ] = findGradient( imageStruct )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

redImage = imread(imageStruct.redPath);

cellN = imageStruct.cellN(end);
redBackground = imageStruct.redBackground;

maxGradient = zeros(cellN,1);
maxGradientLocation = zeros(cellN,1);

for i=1:cellN
	
	boundingBox = imageStruct.boundingBox(i,:);

	redCropped = boundingBoxToCroppedImage(redImage,boundingBox);
	
	redCropAdj = im2double(redCropped) - redBackground;
	
	cellMask = cellBinarize(redCropped);
	
	distanceMap = makeDistanceMap(cellMask);
	distanceGroups = distanceMap - min(distanceMap(:)) + 1;
	distanceLabels = unique(distanceMap) + (unique(distanceMap) >= 0);

	redMeanData = splitapply(@mean,redCropAdj(:),distanceGroups(:));
	
	newStart = 1;
	newEnd = length(redMeanData);
	maxGradientLocation(i) = 25;
	
	while maxGradientLocation(i) > 20 || maxGradientLocation(i) < -20
		
		redGradient = gradient(redMeanData(newStart:newEnd));
		maxGradient(i) = max(redGradient);
		tmp = (redGradient == maxGradient(i)) ...
			.* distanceLabels(newStart:newEnd);
		if max(tmp) == 0
			maxGradientLocation(i) = min(tmp);
			newStart = newStart + 10;
		else
			maxGradientLocation(i) = max(tmp);
			newEnd = newEnd - 10;
		end
		
	end
	
end

end

