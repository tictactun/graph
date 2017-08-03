%{
    Project: Graph completion
    File: main
    Author: Tuan Dinh
    Revised from the orignial verison of WonHwa Kim
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
    
%     [dataY, minY, rangeY] = scale_feature(dataY);
%     configs('threshold') = (configs('threshold') - minY) / rangeY;
    
%     [dataY, inds] = sort(dataY, 'ascend');
%     dataX = dataX(inds, :);  
    % transform to keep montonically increasing order
    
    %{
    dataY = dataY(:, inputParams('yOffset'));
    load ../mmd/Xs.mat Xsource
    dataX = Xsource;
    dataX = normc(dataX);
    %}
    
    if 0 == runMode
        [metric_graph, metric_lasso] = test(dataX, dataY, ...
            inputPars, configs);
    else
        kFolds = 5; % number of folds 
        nIters = 100; % number of iters
        [metric_graph, metric_lasso] = cross_validation(kFolds, ...
            nIters, dataX, dataY, inputPars, configs, 2);
    end
    % Display        
    fprintf('\t------Evaluation------\n');           
    fprintf('Graph completion:\n');
    print_result(metric_graph);  
    % Baseline result    
    fprintf('Linear Regression:\n');
    print_result(metric_lasso);
end