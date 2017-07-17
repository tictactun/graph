function [xCols, degree, cov10] = make_feature_great(data, y, nSelected)
    
    nFeatures = size(data, 2);
    
    % First filter by correlation 0.1
    coValues = zeros(nFeatures, 1);
    for i = 1:nFeatures 
        coValues(i) = mean(corr(data(:, i), y));
    end
    coValues(isnan(coValues)) = 0;
    xCols = 1:nFeatures;
    xCols = xCols(abs(coValues) > 0.1);
%     xCols(end + 1) = 9;
%     xCols(end + 1) = 22;
    cov10 = coValues(xCols);
    
    % Strengthen
    n = length(xCols);
    epsilon = 0.0001;
    degree = ones(n, 1);
    for i=1:n
        col = xCols(i);
        bestCov = cov10(i);
        d = 1;
        e = 100;
        while e >= epsilon
            d = d + 1;
            cov = mean(corr(data(:, col) .^ d, y));
            e = abs(cov) - abs(bestCov);
            if cov ~= cov
                break;
            end
            bestCov = cov;
        end
        degree(i) = d - 1;
        cov10(i) = bestCov;
    end
    
    % Final filter by correlation greater than 0.2
    [~, dInds] = sort(abs(cov10), 'descend');
    cols = dInds(1:min(nSelected, n));
%     cols = cols(abs(cov10(cols)) > 0.2);
    
    xCols = xCols(cols);
    degree = degree(cols);
    cov10 = cov10(cols);

%     for i = 1:length(xCols)
%         fprintf('%f %d \n', cov10(i), xCols(i));
%     end
end