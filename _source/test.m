function test(dataX, dataY, inputParams, config)
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
    fprintf('\t------Evaluation------\n');
    err = evaluate_recovery(wSet, dataY, reData, config);           
    fprintf('Graph completion:\n');
    print_result(err);    
    
    % baseline result - w or wSet
    w = 1: ceil(rMax * nVertices);
    err2 = get_baseline(dataX, dataY, w, config);
    fprintf('Linear Regression:\n');
    print_result(err2); 

    % visualize
%     plot_scatter(myGraph.data, reData, wSet);
end