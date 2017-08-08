function [X, y] = process_data(inputParams)
   
    data = csvread(inputParams('filename'), 1, 0);    
%     X = data(:, inputParams('xleft'): inputParams('xright'));
    X = data(:, 1:end-5);
    y = data(:, end-4:end); % 5 features
    y = y(:, inputParams('yOffset'));

    % Remove outliers & Normalize
    [X, y] = remove_outlier(X, y);
     X = X/norm(X,'fro');
     y = y/norm(y);
end

function [data, y] = remove_outlier(data, y)
    outlierSet = isoutlier(y);
    data = data(~outlierSet, :);
    y = y(~outlierSet, :);
end