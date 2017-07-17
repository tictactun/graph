function [dataX, model] = pregame(dataX, dataY, avaiSampleSet, config)
    
    avaiX = dataX(avaiSampleSet, :);
    avaiY = dataY(avaiSampleSet, :);
    % correlation
    if config('nSelected') > 0
        % rotate data
        for i = 1:size(avaiX, 2)
            [cov, ~] = max(corr(avaiX(:, i), avaiY));
            if cov < 0
                dataX(:, i) = 1 - dataX(:, i);
            end
        end
        avaiX = dataX(avaiSampleSet, :);
        
        [xCols, cov] = select_features(avaiX, avaiY, config('nSelected'));
        dataX = dataX(:, xCols) .* cov';
        
        % make great
%         [xCols, degree, cov10] = make_feature_great(avaiX, avaiY, ...
%                         config('nSelected'));
%         dataX = dataX(:, xCols);
%         for i = 1:length(xCols)
%             dataX(:, i) = (dataX(:, i) .^ degree(i)).* cov10(i);
%         end

        avaiX = dataX(avaiSampleSet, :);
    end
    % distance learning
    model = false;
    if config('learningMode') > 0
        model = learn_distance(avaiX, avaiY, config('learningMode'));
    end                
end