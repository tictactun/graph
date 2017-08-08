function plot_dataset(dataset)
%     fname = strcat(strcat('mat/3050/', string(dataset)), '.csv');
    fname = 'mat/3050/graph21.csv';
    data = csvread(fname, 1, 0);
    sparseValue = 10 * [0:9]';
    n = length(sparseValue);
    m = size(data, 1) / n;
    sparse = zeros(m, n);
    left = zeros(m, n);
    right = zeros(m, n);
    sparseIdx = 3;
    for i = 1:n
        sparse(:, i) = data(data(:, sparseIdx) == sparseValue(i), end -2);
        left(:, i) = data(data(:, sparseIdx) == sparseValue(i), end - 1);
        right(:, i) = data(data(:, sparseIdx) == sparseValue(i), end);
    end

    colors = ['r', 'b'];
    figure(); hold on
    title(strcat('# selected features - Dataset: ', string(dataset)));
    for i=1:m
        X = sparseValue;
%         plot(X, sparse(i, :)', colors(i));
        errorbar(X, sparse(i, :), right(i, :) - left(i,:));
%         fill([X fliplr(X)], [right(i, :)' fliplr(left(i, :)')], 'y', 'LineStyle','--');
    end
    legend('0', '10', 'Location', 'northeast');
    legend('boxoff');
    xlabel('Threshold (% -- quantile)');
    ylabel('% Error (relative RMSE)');
end