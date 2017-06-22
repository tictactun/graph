function xCols = select_features(trainX, trainY, nSelectedFeatures)
    % Correlation
    coValues = zeros(size(trainX, 2));
    for i =1:size(trainX, 2)
        coValues(i) = corr(trainX(:, i), trainY);
    end
    [~, dInds] = sort(coValues, 'descend');
    xCols = dInds(1:min(nSelectedFeatures, size(trainX, 2)));
end