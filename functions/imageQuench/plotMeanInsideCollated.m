function plotMeanInsideCollated( conditionStruct,color )
%UNTITLED20 Summary of this function goes here
%   Detailed explanation goes here


meanYel = horzcat(conditionStruct.imageQuench.yelInsideOverT);

x=1:70;


% FIX ME
meanYelTest = mean(meanYel(:,1:4),2);
meanYelControl = mean(meanYel(:,5:8),2);

errYelTest = std(meanYel(:,1:4),0,2);
errYelControl = std(meanYel(:,5:8),0,2);
% FIX ME


lineSpecTest = strcat('-',color);
lineSpecControl= strcat('--',color);

plot(x,meanYelTest,lineSpecTest);
hold on;
plot(x,meanYelControl,lineSpecControl);
p1 = plot(nan,nan,'-k');
p2 = plot(nan,nan,'--k');
plot([4.5 5],[0 1.3],':k')
plot([24.5 24.5],[0 1.3],':k')
ylim([0 1.3])
xlim([0 70])
title(conditionStruct.mutation)
xlabel('Time point')
ylabel(sprintf('Norm. mean YFP signal\nwithin cells'))

legend([p1 p2],'test','control','location','southeast')

set(gca,'fontsize',16)






end

