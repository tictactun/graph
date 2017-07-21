% Norm 2 error
function err = evaluate_recovery(wSet, trueData, predData, config)
    % Data
    nVertices = size(trueData, 1);
    notW = setdiff(1:nVertices, wSet);
    
    tSampled = trueData(wSet, :);
    pSampled = predData(wSet, :);
    
    tUnSampled =  trueData(notW, :);
    pUnSampled = predData(notW, :);

    err = zeros(6, 1);
    % mean error %
    eDist = 100 * abs((trueData - predData) ./ (trueData));
    err(1)  = mean(eDist(notW));
    err(2)  = mean(eDist(wSet));
    
    % For precision
    err(3) = get_accuracy(tUnSampled, pUnSampled, config); 
    err(4) = get_accuracy(tSampled, pSampled, config);
        
    % For RMSE
    err(5) = get_rmse(tUnSampled, pUnSampled);
    err(6) = get_rmse(tSampled, pSampled);
end

function error = get_rmse(y, p)
    error = norm(y - p, 2);   
end

function precision = get_accuracy(y, p, config)
    t = config('threshold');
    % measure
    nTruePos = sum(y >= t);
    nPredPos = sum(p >= t);
    tp = sum((y >= t) .* (p >=t));
    tn = sum((y < t) .* (p < t));
    precision = tp / nPredPos * 100;
    recall = tp / nTruePos * 100;
    accuracy = (tp + tn) / length(y) * 100;
end

function accuracy = get_error(y, p)
    err = sum(abs((y - p) ./ y));
    accuracy = 100 * (err / length(y));
end