% Norm 2 error
function [acc, error] = evaluate_recovery(wSet, trueData, predData, e)
    % Data
    nVertices = size(trueData, 1);
    notW = setdiff(1:nVertices, wSet);
    
    tSampled = trueData(wSet, :);
    pSampled = predData(wSet, :);
    
    tUnSampled =  trueData(notW, :);
    pUnSampled = predData(notW, :);

    % For precision
    acc.avg = get_accuracy(trueData, predData, e);
    acc.test = get_accuracy(tUnSampled, pUnSampled, e); 
    acc.train = get_accuracy(tSampled, pSampled, e);
    
    % For RMSE
    error.avg = get_rmse(trueData, predData);
    error.test = get_rmse(tUnSampled, pUnSampled);
    error.train = get_rmse(tSampled, pSampled);
end

function error = get_rmse(y, p)
    n = length(y);
    error = norm(y - p, 2) / sqrt(n) ;
end

function accuracy = get_accuracy(y, p, e)
    correct = sum(abs(y - p) <= e);
    accuracy = 100 * correct / length(y);
end