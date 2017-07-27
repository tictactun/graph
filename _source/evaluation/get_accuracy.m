function score = get_accuracy(y, p, t, metric)
    % measure
    nTruePos = sum(y >= t);
    nPredPos = sum(p >= t);
    tp = sum((y >= t) .* (p >=t));
    tn = sum((y < t) .* (p < t));
    switch (metric)
        case 1
            precision = tp / nPredPos * 100;
            score = precision;
        case 2
            recall = tp / nTruePos * 100;
            score = recall;
        otherwise
            accuracy = (tp + tn) / length(y) * 100;
            score = accuracy;
    end
end
