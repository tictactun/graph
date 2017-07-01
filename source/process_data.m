function [X, y] = process_data(inputParams)
   
    data = csvread(inputParams('filename'), 1, 0);    
    %{
    % train dataset
    ntrain = ceil(input.rtrain * input.dataSize);
    data = dataset(1:ntrain, :);
    %}
   
    X = data(:, inputParams('xleft'):end-5);
    y = data(:, end-4:end); % 5 features
    y = y(:, inputParams('yOffset'));

    % Remove outliers & Normalize
%     [X, y] = remove_outlier(X, y);
    X = normc(X);
    y = normc(y);
end

function scaledData = scale_feature(data)
    range = max(data) - min(data);
    if range == 0
        scaledData = ones(size(data, 1), 1);
    else
        scaledData = (data - min(data)) / range;  
    end
end

function d = normalize(data)
    mu = mean(data);
    sd = std(data);
    d = (data - mu) ./ sd;
end

function [data, y] = remove_outlier(data, y)
    outlierSet = isoutlier(y);
    normalSet = setdiff(1:length(data), outlierSet);
    data = data(normalSet, :);
    y = y(normalSet, :);
end