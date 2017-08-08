function metrics = get_confidence_interval(x)            
    SEM = std(x)/sqrt(length(x));               % Standard Error
    ts = tinv([0.025  0.975],length(x)-1);      % T-Score
    CI = mean(x) + ts*SEM;
    metrics.CI = CI;
    metrics.m = mean(x);
end