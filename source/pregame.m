function [X, model] = pregame(dataX, dataY, avaiSampleSet, config)
    
    avaiX = dataX(avaiSampleSet, :);
    avaiY = dataY(avaiSampleSet, :);
    % correlation
    X = dataX;
    if config('nSelectedFeatures') > 0
        [xCols, degree, cov10] = make_feature_great(avaiX, avaiY, ...
                        config('nSelectedFeatures'));
        X = dataX(:, xCols);
        for i=1:length(xCols)
            X(:, i) = (X(:, i) .^ degree(i)) .* cov10(i);
        end
        avaiX = X(avaiSampleSet, :);
    end
    % distance learning
    model = false;
    if config('learningMode') > 0
        model = learn_distance(avaiX, avaiY, config('learningMode'));
    end                
end