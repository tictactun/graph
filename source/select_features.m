function xCols = select_features(trainX, trainY, nSelectedFeatures)
    % Correlation
    coValues = zeros(size(trainX, 2), 1);
    for i =1:size(trainX, 2)
        coValues(i) = corr(trainX(:, i), trainY);
    end
    coValues(isnan(coValues)) = 0;
    [~, dInds] = sort(coValues, 'descend');
    xCols = dInds(1:min(nSelectedFeatures, size(trainX, 2)));
    xCols = xCols(coValues(xCols) > 0);
    
%     for i = 1:length(xCols)
%         fprintf('%f\n', coValues(xCols(i)));
%     end
end