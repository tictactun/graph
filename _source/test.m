function [metric_graph, metric_lasso] = test(dataX, dataY, ...
                                            inputParams, config)
    % Params
    nVertices = size(dataX, 1);
    rAvai = inputParams('rAvaiSamples');
    rMax = inputParams('rMaxSamples');
    
    nAvaiSamples = ceil(rAvai * nVertices);
    avaiSampleSet = 1:nAvaiSamples;
%     avaiSampleSet = randi(nVertices, nAvaiSamples, 1);    
    % Recover
    [reData, wSet] = recover(dataX, dataY, avaiSampleSet, ...
            inputParams, config);
    % Evaluation
    metric_graph = evaluate_recovery(wSet, dataY, reData, config);             
    % baseline result - w or wSet
    w = 1: ceil(rMax * nVertices);
    metric_lasso = get_baseline(dataX, dataY, wSet, config);
end