function  plate = createPlateStruct( plateN )
%CREATE_PLATE_STRUCTURE create empty structs for each plate folder.

plateTemplate = struct(...
			'experimentStr',[]...
			,'plateStr',[]...
			,'folderName',[]...
			,'baseFolder',[]...
			,'local_quench',[]...
			,'filePrefix',[]...
			,'conditionStr',{{}} ...
			,'condWells',{{}}...
			,'condWellsControl',{{}}...
		);

for i=1:plateN
	
	plate(i) = plateTemplate;
	
end

end
