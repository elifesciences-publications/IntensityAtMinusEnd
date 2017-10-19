%% FIT MINUS-END PUNCTA INTENSITY DATA WITH SIGMOIDAL FUNCTION
% AND USE THIS TO CALCULATE TIME TO HALF-MAXIMUM INTENSITY

% 'ablatTraceData' input: output of punctaMeasure, containing intensity of 
% punctum at k-fiber minus-end, over time.

% 'ablatTraceData' output: intensity values over time for each punctum
% tracked, now normalized using sigmoidal fit.

% 'sigmTimeToHalfMaxPooled': time from ablation to half-maximum punctum
% intensity, for each punctum tracked, calculated using sigmoidal fit.

function [sigmTimeToHalfMaxPooled, ablatTraceData] = sigmFitNorm(ablatTraceData);

for i = 1:length(ablatTraceData)
    x=ablatTraceData(i).timeSinceAblation;
    y=ablatTraceData(i).IntDenSubtractMinusNegOne;
    % define a vector p containing constants in sigmoidal function
    f1 = @(p,x) p(1) ./ (1 + exp(-(x-p(2))/p(3)));
    % do fit
    p = nlinfit(x,y,f1,[0 20 50 5]);
    
    %"solve" for final intensity plateau
    ablatTraceData(i).sigmPlateau=p(1); 
    
    %normalize using sigmoidal fit
    ablatTraceData(i).sigmNorm=ablatTraceData(i).IntDenSubtractMinusNegOne/ablatTraceData(i).sigmPlateau;
    
    %plot fits for all traces individually
    figure()
    line(x,f1(p,x),'color','r')
    hold on;
    scatter(x,y);
    
    %solve for time to half-maximum intensity
    sigmTimeToHalfMaxPooled(i,1)= -p(3)*(log(p(1)/((p(1)/2))-1))+p(2);
end