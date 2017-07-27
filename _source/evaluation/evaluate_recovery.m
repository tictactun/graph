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
%     err(1)  = mean(eDist(notW));
%     err(2)  = mean(eDist(wSet));
    
    e = config('threshold') * config('epsilon');
    err(1) = get_error(tUnSampled, pUnSampled, e);
    err(2) = get_error(tSampled, pSampled, e);
    
    % For precision
    t = config('threshold');
    err(3) = get_accuracy(tUnSampled, pUnSampled, t, config('errorMode')); 
    err(4) = get_accuracy(tSampled, pSampled, t, config('errorMode'));
        
    % For RMSE
    err(5) = get_rmse(tUnSampled, pUnSampled);
    err(6) = get_rmse(tSampled, pSampled);
end

% this makes more sense
function err = get_error(y, p, e)
    err = sum(abs(y - p) <= e);
    err = 100 * (err / size(y, 1));
end

function error = get_rmse(y, p)
    error = norm(y - p, 2);   
end