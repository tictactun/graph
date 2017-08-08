function generate_exps()
    
    [inputPars, configs] = init();    
    [dataX, dataY] = process_data(inputPars); 
    
    configs('binary')        = 0;
    configs('learningMode')  = 0; 
    configs('matrixMode')    = 1;
    inputPars('rAvaiSamples') = 0.3; % percentage of available samples
    inputPars('rMaxSamples')  = 0.5;
    
    % using cross validation - rmse
    filenames = {'../dataset/data_full.csv'; '../dataset/data702.csv'; ...
        '../dataset/data_roi1.csv'};
    
    cvMode = 1; % 1 for grpah completion; 2 for baselines; 3 for both
    datasets = 3; %[1; 2; 3];
    selectionMode = [0] ;% 10];
    sparseMode = 10 * [0:9]';
%     sparseMode = [1:4]';
    
    d = [size(datasets, 1), size(selectionMode, 1), size(sparseMode, 1)];
    [v3, v2, v1] = ndgrid(1:d(3),1:d(2), 1:d(1));
    products = [datasets(v1,:), selectionMode(v2,:), sparseMode(v3, :)];
    
    crmse = zeros(size(products, 1), 1);
    CI = zeros(size(products, 1), 2);
%     products = csvread('mat/myExp.csv', 1, 0);
%     [wSet, ~] = find(isnan(products(:, 6)));
%     product = products(wSet, :);
    
    nIters = 1000;
    parfor i = 1:size(products, 1)
        % clone
        config = configs;        
        inputParams = inputPars;
        
%         config('matrixMode')    = 2;
        params = products(i, :);
        inputParams('filename') = filenames{params(1)};
        config('nSelected')     = params(2); 
        config('sim')           = params(3);
%         config('baselineMode') = params(3);
        try 
            metrics = cross_validation(nIters, ...
                dataX, dataY, inputParams, config, cvMode);
            crmse(i) = metrics.m;
            CI(i, :) = metrics.CI;
        catch e
            crmse(i) = 1000;
            fprintf('Exception here\n');
            e
        end
    end
    try
        products = round(products, 3);
        CI = round(CI, 3);
        T = table(products(:, 1), products(:, 2), products(:, 3), ...
                crmse, CI(:, 1), CI(:, 2));
        T.Properties.VariableNames = {'Dataset' 'NoFeatures' ...
            'Baseline' 'relRMSE', 'lower', 'upper'};
        writetable(T,'mat/3050/graph21.csv', 'Delimiter', ','); 
    catch
        keyboard;
    end
end