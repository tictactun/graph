% Norm 2 error
function err = evaluate_recovery(wSet, trueData, predData, config)
    % Data
    nVertices = size(trueData, 1);
    notW = setdiff(1:nVertices, wSet);
    
    tSampled = trueData(wSet, :);
    pSampled = predData(wSet, :);
    
    tUnSampled =  trueData(notW, :);
    pUnSampled = predData(notW, :);

    % For precision
    err = containers.Map;
    err('accTest') = get_accuracy(tUnSampled, pUnSampled, config); 
    err('accTrain') = get_accuracy(tSampled, pSampled, config);
    
    % mean error %
    eDist = 100 * abs((trueData - predData) ./ (trueData));
    err('meTest')   = mean(eDist(notW));
    err('meTrain')  = mean(eDist(wSet));
    
    % For RMSE
    err('rmseTest') = get_rmse(tUnSampled, pUnSampled);
    err('rmseTrain') = get_rmse(tSampled, pSampled);
%     err('rmseTest') = mean(eDist);
%     err('rmseTrain') = 0;
end

function error = get_rmse(y, p)
    error = norm(y - p, 2);   
end

function precision = get_accuracy(y, p, config)
    %{
    correct  = sum(abs(y - p) <= abs(e * y));
    accuracy = 100 * (correct / length(y));
    %}
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