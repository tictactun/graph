function err = evaluate_recovery(wSet, trueData, predData, config)
    err = zeros(7, 1);
    err(1) = get_rrmse(trueData, predData);
    %Data
    errMode = config('errorMode');
    if errMode > 0
        nVertices = size(trueData, 1);
        notW = setdiff(1:nVertices, wSet);
        % observed
        tSampled = trueData(wSet, :);
        pSampled = predData(wSet, :);
        % unobserved
        tUnSampled =  trueData(notW, :);
        pUnSampled = predData(notW, :);

        %mean error %
        eDist = 100 * abs((trueData - predData) ./ (trueData));
        err(2)  = mean(eDist(notW));
        err(3)  = mean(eDist(wSet));
        %For precision
        t = config('threshold');
        err(4) = get_accuracy(tUnSampled, pUnSampled, t, errMode); 
        err(5) = get_accuracy(tSampled, pSampled, t, errMode);
        %For RMSE
        err(6) = get_rrmse(tUnSampled, pUnSampled);
        err(7) = get_rrmse(tSampled, pSampled);
        % recovery
%         e = config('threshold') * config('epsilon');
%         err(1) = get_error(tUnSampled, pUnSampled, e);
%         err(2) = get_error(tSampled, pSampled, e);
    end   
end

function error = get_rrmse(y, p)
    error = norm(y - p, 2) * 100; %/sqrt(length(y));   
end

function err = get_error(y, p, e)
    err = sum(abs(y - p) <= e);
    err = 100 * (err / size(y, 1));
end