function [dataX, mdl] = pregame(dataX, dataY, avaiSampleSet, config)
    
    avaiX = dataX(avaiSampleSet, :);
    avaiY = dataY(avaiSampleSet, :);
    % correlation
%     mdl = get_lasso(avaiX, avaiY);
%     dataX = dataX(:, mdl.b ~= 0);
%     avaiX = dataX(avaiSampleSet, :);
        
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
%         mdl = get_lasso(avaiX, normc(avaiY));
%         [~, dInds] = sort(abs(mdl.b), 'descend');
%         xCols = dInds(1:min(config('nSelected'), size(avaiX, 2)));
%         cov = mdl.b(xCols);
        dataX = dataX(:, xCols) .* cov';
        
        % make great
%         [xCols, degree, cov10] = make_feature_great(avaiX, avaiY, ...
%                         config('nSelected'));
%         dataX = dataX(:, xCols);
%         for i = 1:length(xCols)
%             dataX(:, i) = (dataX(:, i) .^ degree(i)).* cov10(i);
%         end
    end
    % distance learning
%     coeff = pca(dataX);
%     dataX = dataX * coeff;
    avaiX = dataX(avaiSampleSet, :);
    
    mdl = false;
    learnmode = config('learningMode');
    if  learnmode > 0
        if learnmode == 4    
            avaiY = avaiY >= config('threshold');
        end
        mdl = learn_distance(avaiX, avaiY, learnmode);
    end                
end