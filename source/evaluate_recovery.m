% Norm 2 error
function [acc, rmse, err] = evaluate_recovery(wSet, trueData, predData, e)
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
    
    % mean error %
    eDist = 100 * abs((trueData - predData + 0.0001) ./ (trueData + 0.0001));
    err.train = mean(eDist(wSet));
    err.test = mean(eDist(notW));
    
    % For RMSE
    rmse.avg = get_rmse(trueData, predData);
    rmse.test = get_rmse(tUnSampled, pUnSampled);
    rmse.train = get_rmse(tSampled, pSampled);
end

function error = get_rmse(y, p)
    n = length(y);
%     error = norm(y - p, 2) / sqrt(n);
    error = norm(y - p, 2);   
end

function accuracy = get_accuracy(y, p, e)
    correct = sum(abs(y - p) <= e * y);
    accuracy = 100 * (correct / length(y));
end

function accuracy = get_error(y, p)
    err = sum(abs((y - p) ./ y));
    accuracy = 100 * (err / length(y));
end