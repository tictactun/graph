function [normDataX, dataY] = process_data(input)
    dataset = csvread(input.filename, 1, 1);    
    dataset = dataset(1:input.dataSize, input.nRedundantFeatures + 1:end);
    
    ntrain = ceil(input.rtrain * input.dataSize);
    data = dataset(1:ntrain, :);
    % feature scaling - normalization
    dataX = data(:, 1:input.nXfeatures);
    dataY = data(:, input.nXfeatures + 1:end);
%     dataY = dataX; % for testing graph construction
    
%     outlierSet = isoutlier(dataY);
%     normalSet = setdiff(1:length(dataY), outlierSet);
%     dataX = dataX(normalSet, :);
%     dataY = dataY(normalSet, :);

    normDataX = normc(dataX);
    dataY = scale_feature(dataY(:, input.yFeatureIdx));
%     normDataY = normc(dataY);
end

function scaledData = scale_feature(data)
    range = max(data) - min(data);
    if range == 0
        scaledData = ones(size(data, 1), 1);
    else
        scaledData = (data - min(data)) / range;  
    end
end
