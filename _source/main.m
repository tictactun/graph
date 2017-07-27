%{
    Project: Graph completion
    File: main
    Author: Tuan Dinh
    From the orignial verison of WonHwa 
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
        test(dataX, dataY, inputPars, configs);
    else
        kFolds = 5; % number of folds 
        nIters = 1000; % number of iters
        cross_validation(kFolds, nIters, dataX, dataY, inputPars, configs);
    end
end