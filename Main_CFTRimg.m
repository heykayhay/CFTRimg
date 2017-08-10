
% close all other windows
close all
imtool close all

% add the functions to the path
addpath(genpath('functions'));

% mapLen = 256;
% mapVec = linspace(0,1,mapLen)';
% mapZeros = zeros(mapLen,1);
% redMap = [mapVec, mapZeros, mapZeros];
% yelMap = [mapVec, mapVec, mapZeros];
% colormap(redMap)

global SITEN

runMode = 'test'; % 'test' OR 'full'

%% IMPORT DATA

baseFolder = 'E:\Stella\'

% fullfile('~','Desktop','data'); 

if strcmp(runMode,'test')
	experimentStr = {'exp1'};
	exp = createExperimentStruct(experimentStr);

	exp(1).local_quench = {'60x'};
	exp(1).conditionStr = {'F508del/T1064W','F508del/T1064H','F508del/T1064M',};
	
	exp(1).condWells(1,:) = {'B02'};
	exp(1).condWells(2,:) = {'B03'};
	exp(1).condWells(3,:) = {'B04'};

	
	cond = createConditionStruct(exp);
	cond = findImagePaths(exp,cond);
		
elseif strcmp(runMode,'full')
	SITEN = 9;
	inputData
	cond = createConditionStruct(exp);
	cond = findImagePaths(exp,cond);
end

conditionN = length(cond);
cond(2).mutation{1} = 'F508del/R1070W';

disp('Completed importing data')

%% DECLARE GLOBAL VARIABLES

global BINNING EXTRA

BINNING = 1 / 1;
EXTRA = ceil(BINNING*20);


%% SEGMENTATION

close all

for j=1:conditionN
 	for i=1:cond(j).localImageN

		cond(j).imageLocal(i) = imgSegmentWatershed(cond(j).imageLocal(i));

	end
end

store = cond;

disp('Completed image segmentation')

%% FILTERING

cond = store;

for j=1:conditionN
	for i=1:cond(j).localImageN
		
		cond(j).imageLocal(i).cellN = cond(j).imageLocal(i).cellN(1);
		
		cond(j).imageLocal(i) = imgFilterEdges(cond(j).imageLocal(i));
		
% 		cond(j).imageLocal(i) = imgFindBackground(cond(j).imageLocal(i));
		
		cond(j).imageLocal(i) = imgFilterUnmasked(cond(j).imageLocal(i));
		
% 		cond(j).imageLocal(i) = imgFilterAbuttingCells(cond(j).imageLocal(i));
		
		cond(j).imageLocal(i) = imgFindCellDimensions(cond(j).imageLocal(i));

		cond(j).imageLocal(i) = imgFilterCellSize(cond(j).imageLocal(i));
		
	end
end

disp('Completed image filtering')

%% DISTANCE MAP

for j=1:conditionN
	for i=1:cond(j).localImageN
		
		cond(j).imageLocal(i) = distanceMap(cond(j).imageLocal(i));

	end
end

disp('Completed image processing')


%% ANALYSIS

close all

for i=1:length(cond)
	fullCellN = vertcat(cond(i).imageLocal.cellN);
	cond(i).localCellN = sum(fullCellN(:,end));
	cond(i) = collectRatioData(cond(i));
end

disp([cond.mutation])
disp(([cond.localHits]./[cond.localCellN])*100)
disp([cond.localCellN])

a=1;
b=3;

% for i=1:cond(a).imageLocal(b).cellN(end)
% 	figure
% 	plotMeanIntensity(cond(a).imageLocal(b),i)
% end
% [maxGrad, maxGradLoc] = findGradient(cond(a).imageLocal(b))

for i=1:length(cond)
	figure
	plotRedYelCorrEntire(cond(i))
	figure
	plotRedYelCorrMembrane(cond(i))
	figure
	plotRedYelCorrInterior(cond(i))
end

% 	figure
% for i=1:length(cond)
% 	subplot(3,3,i)
% 	plotRedYelCorrEntire(cond(i))
% 	subplot(3,3,i+3)
% 	plotRedYelCorrMembrane(cond(i))
% 	subplot(3,3,i+6)
% 	plotRedYelCorrInterior(cond(i))
% end

%% DISPLAY

close all

x=3;
y=5;

cond(x).imageLocal(y).cellN


[maxGrad, maxGradLoc] = findGradient(cond(x).imageLocal(y));
meanRedEntire = mean(cond(x).imageLocal(y).redEntire);

for i=1:1 %cond(x).imageLocal(y).cellN(end)
	
	str1 = sprintf('max %g\nloc %g\nentire %g\nav. entire %g'...
		,round(maxGrad(i),4)...
		,maxGradLoc(i)...
		,cond(x).imageLocal(y).redEntire(i)...
		,meanRedEntire);
	
	str2 = sprintf('in %g\nout %g\nmem %g'...
		,round(cond(x).imageLocal(y).yelEntire(i),4)...
		,round(cond(x).imageLocal(y).yelOutside(i),4)...
		,round(cond(x).imageLocal(y).yelMembrane(i),4));
	
	dim1 = [.15 .65 .1 .1];
	dim2 = [.45 .65 .1 .1];
	
	figure
	subplot(5,3,1)
	cellDisplay(cond(x).imageLocal(y),'red',i)
	subplot(5,3,2)
	cellDisplay(cond(x).imageLocal(y),'yel',i)
	subplot(5,3,3)
	cellDisplay(cond(x).imageLocal(y),'bw',i)
	annotation('textbox',dim1,'String',str1,'FitBoxToText','on');
	annotation('textbox',dim2,'String',str2,'FitBoxToText','on');
	subplot(5,3,6)
	cellDisplay(cond(x).imageLocal(y),'overlay',i)
	subplot(5,1,[3,4,5],'fontsize',14)
	plotMeanIntensity(cond(x).imageLocal(y),i)
	
end


%% QUENCHING ANALYSIS

for j=1:conditionN
	
	quenchImageN = cond(j).quenchImageTestN + cond(j).quenchImageControlN;
	
	for i=1:quenchImageN
		
% 		cond(j).imageQuench(i) = findYelBackground(cond(j).imageQuench(i));
		
% 		cond(j).imageQuench(i) = findRedExpression(cond(j).imageQuench(i));
		
		cond(j).imageQuench(i) = findRedMaskChange(cond(j).imageQuench(i));
		
		cond(j).imageQuench(i) = findYelInsideOverTime(cond(j).imageQuench(i));
		
		cond(j).imageQuench(i) = calculateConcIodine(cond(j).imageQuench(i));
		
	end
end

disp('Completed quenching analysis')


%% QUENCHING PLOTS

ymin = zeros(conditionN,1);
ymax = zeros(conditionN,1);
for i=1:conditionN
	ymin(i) = min(vertcat(cond(i).imageQuench.yelInsideOverT));
	ymax(i) = max(vertcat(cond(i).imageQuench.yelInsideOverT));
end

disp([min(ymin), max(ymax)])

% m=4;
% 
% figure
% subplot(1,3,1)
% plotMeanInside(cond(1),m)
% subplot(1,3,2)
% plotMeanInside(cond(2),m)
% subplot(1,3,3)
% plotMeanInside(cond(3),m)

figure
subplot(1,3,1)
plotMeanInsideCollated(cond(1))
subplot(1,3,2)
plotMeanInsideCollated(cond(2))
subplot(1,3,3)
plotMeanInsideCollated(cond(3))



%% QUENCHING OUTPUT


for j=1:conditionN
	
	testLogical = zeros(length(cond(j).imageQuench),1);
	for i=1:length(cond(j).imageQuench)
		testLogical(i) = strcmp(cond(j).imageQuench(i).test_control,'test');
	end
	
	maxGradTest = zeros(sum(testLogical),1);
	maxGradControl = zeros(length(testLogical) - sum(testLogical),1);
	maxGradTestLoc = zeros(sum(testLogical),1);
	maxGradControlLoc = zeros(length(testLogical) - sum(testLogical),1.);
	
	maxGrad = vertcat(cond(j).imageQuench.maxGradIodine);
	maxGradLoc = vertcat(cond(j).imageQuench.maxGradLocation);
	
	counterTest = 1;
	counterControl = 1;
	for i=1:length(testLogical)
		if testLogical(i) == 1
			maxGradTest(counterTest) = maxGrad(i);
			maxGradTestLoc(counterTest) = maxGradLoc(i);
			counterTest = counterTest + 1;
		elseif testLogical(i) == 0
			maxGradControl(counterControl) = maxGrad(i);
			maxGradControlLoc(counterControl) = maxGradLoc(i);
			counterControl = counterControl + 1;
		end
	end
	
	fprintf('\n%s - Test\n',cond(j).mutation{1})
	disp([mean(maxGradTest),std(maxGradTest)])
	disp([mean(maxGradTestLoc),std(maxGradTestLoc)])
	
	fprintf('%s - Control\n',cond(j).mutation{1})
	disp([mean(maxGradControl),std(maxGradControl)])
	disp([mean(maxGradControlLoc),std(maxGradControlLoc)])
	
	
%  	disp([maxGradTest,maxGradTestLoc,maxGradControl,maxGradControlLoc])

	
end



