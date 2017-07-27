function test(dataX, dataY, inputParams, config)
    % Params
    nVertices = size(dataX, 1);
    rAvai = inputParams('rAvaiSamples');
    rMax = inputParams('rMaxSamples');
    
    nAvaiSamples = ceil(rAvai * nVertices);
    avaiSampleSet = 1:nAvaiSamples;
%     avaiSampleSet = randi(nVertices, nAvaiSamples, 1);

%     u = mean(dataY);
%     sigma = std(dataY);
%      
%     dataY = (dataY - u)./sigma;
    
    % Recover
    [reData, wSet] = recover(dataX, dataY, avaiSampleSet, ...
            inputParams, config);
    
%     dataY = dataY .* sigma + u;
%     reData = reData .* sigma + u;
    
    % Evaluation
    fprintf('\t------Evaluation------\n');
    err1 = evaluate_recovery(wSet, dataY, reData, config);           
    fprintf('Graph completion:\n');
    print_result(err1);    
    
    % baseline result - w or wSet
    w = 1: ceil(rMax * nVertices);
    err2 = get_baseline(dataX, dataY, wSet, config);
    fprintf('Lasso:\n');
    print_result(err2); 

    % visualize
%     notW = setdiff(1:nVertices, wSet);
%     plot_scatter(dataY, reData, notW);
end