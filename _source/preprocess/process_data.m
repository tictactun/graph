function [X, y] = process_data(inputParams)
   
    data = csvread(inputParams('filename'), 1, 0);    
%     X = data(:, inputParams('xleft'): inputParams('xright'));
    X = data(:, 1:end-5);
    y = data(:, end-4:end); % 5 features
    y = y(:, inputParams('yOffset'));

    % Remove outliers & Normalize
    [X, y] = remove_outlier(X, y);
%     X = normc(X);
    for i =1:size(X, 2)
        [X(:, i), ~, ~] = scale_feature(X(:, i));
    end
%     y = normc(y);
end

function d = normalize(data)
    mu = mean(data);
    sd = std(data);
    d = (data - mu) ./ sd;
end

function [data, y] = remove_outlier(data, y)
    outlierSet = isoutlier(y);
%     outlierSet = y > 1700;
%     normalSet = setdiff(1:size(data, 1), outlierSet);
    data = data(~outlierSet, :);
    y = y(~outlierSet, :);
end