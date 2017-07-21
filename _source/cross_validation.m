function cross_validation(kFolds, originX, originY, inputParams, config)
    % params
    nIters = 1000;    
    rAvai = inputParams('rAvaiSamples');
    rMax = inputParams('rMaxSamples');
    nVertices = size(originX, 1);
    % For cv
    nAvaiSamples = ceil(rAvai * nVertices);
    step = ceil((nVertices - nAvaiSamples) / kFolds) - 1;
    
    % Error
    errcount = 0;  
    graph_err = 0;
    graph_pre = 0;
    lasso_err = 0;
    lasso_pre = 0;
    
    parfor iter = 1:nIters
        p = randperm(nVertices);
        dataX = originX(p, :);
        dataY = originY(p, :);      
         % for each fold
        for k = 1:kFolds
            avaiSampleSet = step * (k - 1) + (1:nAvaiSamples);
            try
                [reData, wSet] = recover(dataX, dataY, avaiSampleSet, ...
                    inputParams, config);
            catch
                errcount = errcount + 1;
                continue;
            end
            % Evaluation
            % Graph
            err_graph = evaluate_recovery(wSet, dataY, reData, config);
            graph_err =  graph_err + err_graph('meTest');
            graph_pre = graph_pre + err_graph('accTest');
            % Lasso
            w = 1:ceil(rMax * nVertices);
            err_lasso = get_baseline(dataX, dataY, w, config);      
            lasso_err = lasso_err + err_lasso('meTest');
            lasso_pre = lasso_pre + err_lasso('accTest');
        end
    end
    
    % Evaluation
    tests = {'accTest', 'accTrain', 'rmseTest', ...
        'rmseTrain', 'meTest', 'meTrain'};
    report = containers.Map;
    lasso = containers.Map;
    for i = 1:length(tests)
        report(tests{i}) = 0;
        lasso(tests{i}) = 0;
    end    
    iters = (nIters * kFolds - errcount);
    report('meTest') = graph_err / iters;
    report('accTest') = graph_pre / iters;
    lasso('meTest') = lasso_err / iters;
    lasso('accTest') = lasso_pre / iters;
    % Display        
    fprintf('\t------Evaluation------\n');   
    fprintf('No of exceptions: %d\n', errcount); 
    fprintf('Graph completion:\n');
    print_result(report);  
    % baseline result    
    fprintf('Linear Regression:\n');
    print_result(lasso); 
end