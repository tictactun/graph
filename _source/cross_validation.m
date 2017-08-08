function metrics =  cross_validation(nIters, originX, originY, ...
                    inputParams, config, alg)
    % Params
    rAvai = inputParams('rAvaiSamples');
    rMax = inputParams('rMaxSamples');
    nVertices = size(originX, 1);
    % For cv
    nAvaiSamples = ceil(rAvai * nVertices);
    avaiSampleSet = 1:nAvaiSamples;
    % Error
    errIdx = config('errIdx');
    nMetrics = config('nMetrics');
    errorCount = 0;
    % 7 metrics
    errors = zeros(nIters, nMetrics) - 1;
    parfor iter = 1:nIters
        p = randperm(nVertices);
        dataX = originX(p, :);
        dataY = originY(p, :); 
        try 
            if alg == 1
                [reData, wSet] = recover(dataX, dataY, avaiSampleSet, ...
                    inputParams, config);
            else
                wSet = 1: ceil(rMax * nVertices);
                reData = get_baseline(dataX, dataY, wSet, config);
            end
            err = evaluate_recovery(wSet, dataY, reData, config);
            errors(iter, :) = err;
        catch
            errorCount = errorCount + 1;
        end
    end
%     iters = (nIters * kFolds - errCount);
%     fprintf('No of exceptions: %d\n', errCount); 
    errors = errors(errors(:, errIdx) > -1, :);
    metrics = get_confidence_interval(errors(:, errIdx));
end