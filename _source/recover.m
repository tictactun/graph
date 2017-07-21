
% Should  modify to make it realistic => get 1 new index only
function [reData, wSet] = recover(dataX, dataY, avaiSampleSet, ...
            inputParams, config)
    % Params
    rAvai = inputParams('rAvaiSamples');
    rMax = inputParams('rMaxSamples');
    
    mdl = false;
    if rAvai > 0
        [X, mdl] = pregame(dataX, dataY, avaiSampleSet, config);
        dataX = X;
    end

    % construct graph
    myGraph = construct_graph(dataX, config, mdl);
    myGraph.data = dataY; % f includes unseen data
    myGraph.preWSet = avaiSampleSet;
    myGraph.rMaxSamples = rMax;
    
    % Recover
    [reData, wSet] = recover_graph(myGraph, config);   
end