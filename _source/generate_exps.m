% 1 for graph completion, 2 for baseline, 3 for random matrix
function generate_exps(expMode)

    toSavePath = 'files/3050/graph.csv';
    
    [inputPars, configs] = init();    
    [dataX, dataY] = process_data(inputPars); 
    % default setup
    nIters = 1000;
    configs('binary')        = 0;
    configs('learningMode')  = 0; 
    inputPars('rAvaiSamples') = 0.3; % percentage of available samples
    inputPars('rMaxSamples')  = 0.5;    
    if expMode == 3 % random matrix
        configs('matrixMode')    = 2;
    else
        configs('matrixMode')    = 1;
    end
    
    % using cross validation - rmse
    filenames = {'cog'; 'cogGen'; 'cogGenRoi'};    
    alg = 1; % 1 for grpah completion; 2 for baselines
    datasets = 3; %[1; 2; 3];
    selectionMode = [0] ;% 10];
    if expMode == 2
        sparseMode = [1:4]';
    else
        sparseMode = 10 * [0:9]';
    end
    % grid generator
    d = [size(datasets, 1), size(selectionMode, 1), size(sparseMode, 1)];
    [v3, v2, v1] = ndgrid(1:d(3),1:d(2), 1:d(1));
    products = [datasets(v1,:), selectionMode(v2,:), sparseMode(v3, :)];
    % metrics
    crmse = zeros(size(products, 1), 1);
    CI = zeros(size(products, 1), 2);
    
    parfor i = 1:size(products, 1)
        % clone
        config = configs;        
        inputParams = inputPars;
        params = products(i, :);
        % modify
        inputParams('filename') = strcat(strcat('../dataset/data_', ...
                                        filenames{params(1)}), '.csv');
        config('nSelected') = params(2); 
        if expMode == 2
            config('baselineMode') = params(3);
        else
            config('sim') = params(3);
        end
        metrics = cross_validation(nIters, dataX, dataY, ...
                        inputParams, config, alg);
        crmse(i) = metrics.m;
        CI(i, :) = metrics.CI;        
    end
    % Save to files
    try
        products = round(products, 3);
        CI = round(CI, 3);
        T = table(products(:, 1), products(:, 2), products(:, 3), ...
                crmse, CI(:, 1), CI(:, 2));
        if expMode == 3
            bname = 'Baseline';
        else
            bname = 'Percentile';
        end
        T.Properties.VariableNames = {'Dataset' 'NoFeatures' ...
           bname  'relRMSE', 'lower', 'upper'};
        writetable(T, toSavePath, 'Delimiter', ','); 
    catch
        keyboard;
    end
end