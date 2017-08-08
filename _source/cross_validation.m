
function metrics =  cross_validation(nIters, oriX, oriY, ...
                    inputParams, config, eMode)
    % Params
    rAvai = inputParams('rAvaiSamples');
    rMax = inputParams('rMaxSamples');
    nVertices = size(oriX, 1);
    % For cv
    nAvaiSamples = ceil(rAvai * nVertices);
    avaiSampleSet = 1:nAvaiSamples;

    % Error
    errCount = 0;  
    errIdx = 6;
    metricGraph = zeros(nIters, errIdx);
    metricLasso = zeros(nIters, errIdx);
    
    parfor iter = 1:nIters
        p = randperm(nVertices);
        dataX = oriX(p, :);
        dataY = oriY(p, :);      
         % for each fold
        try
            [reData, wSet] = recover(dataX, dataY, avaiSampleSet, ...
                inputParams, config);
        catch
            errCount = errCount + 1;
            continue;
        end
        % Evaluation
        if eMode ~= 2
            % Graph
            err_graph = evaluate_recovery(wSet, dataY, reData, config);
            metricGraph(iter, :) = err_graph;
        end
        if eMode ~= 1
            % Lasso            
            w = 1:ceil(rMax * nVertices);
            err_lasso = get_baseline(dataX, dataY, w, config);      
            metricLasso(iter, :) = err_lasso;
        end
    end

%     iters = (nIters * kFolds - errCount);
    if eMode ~= 2
        metrics = get_confidence(metricGraph(:, errIdx));
    end
    if eMode ~= 1
        metrics = get_confidence(metricLasso(:, errIdx));
    end
%     fprintf('No of exceptions: %d\n', errCount); 
end

function metrics = get_confidence(x)            
    SEM = std(x)/sqrt(length(x));               % Standard Error
    ts = tinv([0.025  0.975],length(x)-1);      % T-Score
    CI = mean(x) + ts*SEM;
    metrics.CI = CI;
    metrics.m = mean(x);
end