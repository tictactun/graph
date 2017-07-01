function [xCols, cov] = select_features(trainX, trainY, nSelectedFeatures)
    % Correlation
    coValues = zeros(size(trainX, 2), 1);
    for i =1:size(trainX, 2)
        coValues(i) = corr(trainX(:, i), trainY);
    end
    coValues(isnan(coValues)) = 0;
    [~, dInds] = sort(abs(coValues), 'descend');
    xCols = dInds(1:min(nSelectedFeatures, size(trainX, 2)));
    xCols = xCols(abs(coValues(xCols)) > 0.1);
    cov = coValues(xCols);
    
    for i = 1:length(xCols)
        fprintf('%f %d \n', coValues(xCols(i)), xCols(i));
    end
end

