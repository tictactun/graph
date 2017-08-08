%{
    Project: Graph completion
    File: main
    Author: Tuan Dinh
    Developed from the orignial verison of WonHwa Kim
    Description: graph completion 
%}

%{
    @param
        runMode int 0 for single shot, 1 for cross validation
                    default value is 0
    @return 
%}
function main(runMode)
    warning off;
    if nargin < 1
        runMode = 0;
    end
    
    [inputPars, configs] = init();    
    % Load csv file into 2 parts: construction and completion
    [dataX, dataY] = process_data(inputPars);       
    %{
    dataY = dataY(:, inputParams('yOffset'));
    load ../mmd/Xs.mat Xsource
    dataX = Xsource;
    dataX = normc(dataX);
    %}
    
    if 0 == runMode
        [metrics, metric_lasso] = test(dataX, dataY, ...
            inputPars, configs);
        metrics = metrics(6);
        metric_lasso = metric_lasso(6);
    else
        nIters = 100; % number of iters
        metrics = cross_validation(nIters, ...
            dataX, dataY, inputPars, configs, runMode);
        metrics = metrics.m;
    end
    
    % Display
    fprintf('\t------Evaluation------\n');           
    fprintf('Graph completion:\n');
    print_result(metrics);  
    
    % Baseline result    
%     fprintf('Linear Regression:\n');
%     print_result(metric_lasso);
end