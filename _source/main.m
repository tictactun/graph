%{
    Project: Graph completion
    File: main
    Author: Tuan Dinh
    From the orignial verison of WonHwa 
    Description: graph completion 
%}

function main(runMode)
    warning off;
    if nargin < 1
        runMode = 0;
    end
    
    [inputParams, config] = init();    
    % Load csv file into 2 parts: construction and completion
    [dataX, dataY] = process_data(inputParams);     
    %{
    dataY = dataY(:, inputParams('yOffset'));
    load ../mmd/Xs.mat Xsource
    dataX = Xsource;
    dataX = normc(dataX);
    %}
    
    if 0 == runMode
        recover(dataX, dataY, inputParams, config);
    else
        kFold = 5;
        cross_validation(kFold, dataX, dataY, inputParams, config);
    end
end