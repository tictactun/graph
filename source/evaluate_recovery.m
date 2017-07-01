% Norm 2 error
function err = evaluate_recovery(wSet, trueData, predData, e)
    % Data
    nVertices = size(trueData, 1);
    notW = setdiff(1:nVertices, wSet);
    
    tSampled = trueData(wSet, :);
    pSampled = predData(wSet, :);
    
    tUnSampled =  trueData(notW, :);
    pUnSampled = predData(notW, :);

    % For precision
    err = containers.Map;
    err('accTest') = get_accuracy(tUnSampled, pUnSampled, e); 
    err('accTrain') = get_accuracy(tSampled, pSampled, e);
    
    % mean error %
    eDist = 100 * abs((trueData - predData) ./ (trueData));
    err('meTest')   = mean(eDist(notW));
    err('meTrain')  = mean(eDist(wSet));
    
    % For RMSE
    err('rmseTest') = get_rmse(tUnSampled, pUnSampled);
    err('rmseTrain') = get_rmse(tSampled, pSampled);
end

function error = get_rmse(y, p)
    n = length(y);
%     error = norm(y - p, 2) / sqrt(n);
    error = norm(y - p, 2);   
end

function accuracy = get_accuracy(y, p, e)
    correct  = sum(abs(y - p) <= abs(e * y));
    accuracy = 100 * (correct / length(y));
end

function accuracy = get_error(y, p)
    err = sum(abs((y - p) ./ y));
    accuracy = 100 * (err / length(y));
end