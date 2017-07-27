function [scaledData, minData, rangeData] = scale_feature(data)
    rangeData = max(data) - min(data);
    minData = min(data);
    if rangeData == 0
        scaledData = ones(size(data, 1), 1);
    else
        scaledData = (data - minData) / rangeData;  
    end
end