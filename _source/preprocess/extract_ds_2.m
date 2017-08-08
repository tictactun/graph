function extract_ds_2(dataset, dsSize)
    data1 = csvread('mat/myExp3.csv', 1, 0);
    data2 = csvread('mat/myExp32.csv', 1, 0);
    
    set11 = data1(data1(:, 1) == dataset, :);
    set12 = data2(data2(:, 1) == dataset, :);
    set1 = [set12; set11];
    set1(:, end) = set1(:, end) * sqrt(dsSize) * 100;
    
    name = strcat(strcat('mat/set', string(dataset)), '.csv');
    csvwrite(name, set1);
     
    % Plot
    sparseValue = [0, 50, 80, 90];
    n = length(sparseValue);
    m = size(set1, 1) / n;
    sparse = zeros(m, n);
    for i = 1:n
        sparse(:, i) = set1(set1(:, 4) == sparseValue(i), end);
    end

    colors = ['r', 'g', 'b', 'k'];
    styles = ['-', ':'];
    figure(); hold on
    title(strcat('Selection-Learning-Weighted: Dataset ', string(dataset)));
    for i=1:m
        c = colors(ceil((i - 0.5) / 2));
        s = styles(mod(i, 2) + 1);
        r = strcat(c, s);
        plot(sparseValue, sparse(i, :), r);
    end
    legend('0-0-0', '0-0-1', '0-3-0', '0-3-1', ...
        '10-0-0', '10-0-1', '10-3-0', '10-3-1', ...
        'Location', 'northeast');
    legend('boxoff');
    xlabel('Threshold (% -- quantile)');
    ylabel('% Error (relative RMSE)');
end