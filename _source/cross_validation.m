function cross_validation(kFolds, nIters, oriX, oriY, inputParams, config)
    % Params
    rAvai = inputParams('rAvaiSamples');
    rMax = inputParams('rMaxSamples');
    nVertices = size(oriX, 1);
    % For cv
    nAvaiSamples = ceil(rAvai * nVertices);
    step = ceil((nVertices - nAvaiSamples) / kFolds) - 1;
    
    % Error
    errCount = 0;  
    metric_graph = zeros(6, 1);
    metric_lasso = zeros(6, 1);
    
    parfor iter = 1:nIters
        p = randperm(nVertices);
        dataX = oriX(p, :);
        dataY = oriY(p, :);      
         % for each fold
        for k = 1:kFolds
            avaiSampleSet = step * (k - 1) + (1:nAvaiSamples);
            try
                [reData, wSet] = recover(dataX, dataY, avaiSampleSet, ...
                    inputParams, config);
            catch
                errCount = errCount + 1;
                continue;
            end
            % Evaluation
            % Graph
            err_graph = evaluate_recovery(wSet, dataY, reData, config);
            metric_graph = metric_graph + err_graph;
            % Lasso
            w = 1:ceil(rMax * nVertices);
            err_lasso = get_baseline(dataX, dataY, w, config);      
            metric_lasso = metric_lasso + err_lasso;
        end
    end
    % Average
    iters = (nIters * kFolds - errCount);
    metric_graph = metric_graph ./ iters;
    metric_lasso = metric_lasso ./ iters;
    % Display        
    fprintf('\t------Evaluation------\n');   
    fprintf('No of exceptions: %d\n', errCount); 
    fprintf('Graph completion:\n');
    print_result(metric_graph);  
    % Baseline result    
    fprintf('Linear Regression:\n');
    print_result(metric_lasso); 
end