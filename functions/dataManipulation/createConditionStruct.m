function  conditionStruct = createConditionStruct( experimentStruct )
%CREATECONDITIONS create empty structs for each condition as listed in
%'experimentStruct.conditionsStr'

conditionsStr = unique(horzcat(experimentStruct.conditionStr));

conditionsN = length(conditionsStr);
conditionTemplate = struct(...
			'mutation',[]...
			,'imageLocal',{{}}...
			,'imageQuench',{{}}...
			,'localImageN',[]...
			,'localCellN',[]...
			,'localHits',[]...
			,'quenchImageTestN',[]...
			,'quenchImageControlN',[]);

for i=1:conditionsN
	conditionStruct(i) = conditionTemplate;
	conditionStruct(i).mutation = conditionsStr{i};
end


