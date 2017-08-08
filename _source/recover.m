function [reData, wSet] = recover(dataX, dataY, avaiSampleSet, ...
            inputParams, config)
    % Params
    mdl = false;
    if inputParams('rAvaiSamples') > 0
        [dataX, mdl] = pregame(dataX, dataY, avaiSampleSet, config);
    end

    % construct graph
    myGraph = construct_graph(dataX, avaiSampleSet, config, mdl);
    myGraph.data = dataY; % f includes unseen data
    myGraph.preWSet = avaiSampleSet;
    myGraph.rMaxSamples = inputParams('rMaxSamples');
    
    % Recover
    [reData, wSet] = recover_graph(myGraph, config);   
end