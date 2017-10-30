function resultsStructArray = populateResultsLocal( resultsStructArray ...
	,normStructArray)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

conditionN	= length(resultsStructArray);
plateN			= length(normStructArray);

for k=1:conditionN
	
	currentCondition = resultsStructArray(k).mutation;
	count = 1;
	
	for j=1:plateN
		
		normStruct = normStructArray(j);
		locationVec = strcmp(currentCondition,normStruct.mutation);
		
		for i=1:length(locationVec)
			
			if locationVec(i) == 1
				resultsStructArray(k).yelEntire(count) = normStruct.yelEntire(i);
				resultsStructArray(k).yelMembrane(count) = normStruct.yelMembrane(i);
				resultsStructArray(k).redEntire(count) = normStruct.redEntire(i);
				count = count+1;
			end
			
		end
		
	end
	
end

end