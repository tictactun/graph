function extract_ds_1()
    fname = 'mat/3050/graph123.csv';
    data = csvread(fname, 1, 0);
    for ds = 1:3
       sdata = data(data(:, 1) == ds, :);
       fname = strcat(strcat('mat/3050/graph', string(ds)), '.csv');
       csvwrite(fname, sdata);
    end
%     T = table(data(:, 1), data(:, 1), data(:, 1), data(:, 1), data(:, 1));
%     T.Properties.VariableNames = {'Dataset' 'NoFeatures' ...
%         'Percentile' 'reRMSE', 'leftInt', 'rightInt'};
%     writetable(T, fname, 'Delimiter', ',');
end