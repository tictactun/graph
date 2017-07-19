%{
    Project: Graph completion
    File: main
    Author: Tuan Dinh
    From the orignial verison of WonHwa 
    Description: graph completion 
%}

function main

    % Load setup
    [inputParams, config] = setup();    
    % Load csv file into 2 parts: construction and completion
    [dataX, dataY] = process_data(inputParams);  
    
    dataY = dataY(:, inputParams('yOffset'));
%     load ../mmd/Xs.mat Xsource
%     dataX = Xsource;
%     dataX = normc(dataX);
    % Pre-game - it should be repeated everytime new sample is coming
    nAvaiSamples = inputParams('rAvaiSamples') * size(dataY, 1);
    avaiSampleSet = 1:nAvaiSamples; % can be updated
    if inputParams('rAvaiSamples') > 0
        [X, model] = pregame(dataX, dataY, avaiSampleSet, config);
        dataX = X;
        config('disModel') = model;
    end

    % construct graph: using selected features - new learned distance
    myGraph = construct_graph(dataX, config);
    
    % data
    myGraph.data = dataY; % f includes unseen data, for the testing purpose
    myGraph.preWSet = avaiSampleSet;
    myGraph.rMaxSamples = inputParams('rMaxSamples');
    
    % Recover
    [reData, wSet] = recover_graph(myGraph, config);
    
    fprintf('\t------Evaluation------\n');
    % Evaluation
    err = evaluate_recovery(wSet, dataY, reData, config);           
    fprintf('Graph completion:\n');
    print_result(err);    
    
    % baseline result
%     w = 1: (inputParams('rMaxSamples') * size(dataY, 1));
%     err2 = get_baseline(dataX, dataY, w, config);
%     fprintf('Linear Regression:\n');
%     print_result(err2); 

    % visualize
%     plot_scatter(myGraph.data, reData, wSet);
end