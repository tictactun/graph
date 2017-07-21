 function plot_learning_curve(param)
    % Setting
    [inputParams, configs] = init();     
    % Load csv file into 2 parts: construction and completion
    [dataX, dataY] = process_data(inputParams);  
    
    nVertices = size(dataX, 1);
    kFolds = 2;
    
    % values
    ranges = containers.Map;
    ranges('rMaxSamples')   = 0.6 + (0:7) * 0.05;
    ranges('rAvaiSamples')  = 0.2 + (0:6) * 0.05;
    ranges('preSigma')      = 0.02 + 0.02 * (0:20); %sigma
    ranges('nSelected')     = 1 + 4 * (0:10); % 
    ranges('gamma')         = 0.01 + 0.02 * (0:20); % gamma
    ranges('rBand')         = 0.1 + (0:18) * 0.05; % 
    ranges('kNeighbors')    = 1 + 1 * (0:40); % knn
    ranges('sim')           = 10 * (1:9);
    ranges('simKernel')     = 1:6;
    interval = ranges(param);

    % metrics
    %{
    if strcmp('rMaxSamples', param) 
        rMaxSamples = ranges('rMaxSamples');
        interval = 1; % 1 round only
    else
        rMaxSamples = configs('rMaxSamples');
    end
    tests = {'accTest', 'accTrain', 'rmseTest', 'rmseTrain', 'meTest', ...
        'meTrain'};
    report = containers.Map;
    for i = 1:length(tests)
        report(tests{i}) = zeros(length(interval), length(rMaxSamples));
    end
    %}
    metrics = zeros(6, length(interval));
    count = zeros(length(interval), 1);
    
    for r = 1:length(interval)
        fprintf('%s  = %.2f\n', param, interval(r));
        % clone
        config = configs;
        inputPars = inputParams;
        if strcmp('rMaxSamples', param) ||strcmp('rAvaiSamples', param)
            inputPars(param) = interval(r);
        else            
            config(param) = interval(r);   
        end
        
        % new available dataset
        rAvai = inputParams('rAvaiSamples');
        nAvaiSamples = ceil(rAvai * nVertices);
        step = ceil((nVertices - nAvaiSamples) / kFolds) - 1;
        
        for k = 1:kFolds
            avaiSampleSet = step * (k - 1) + (1:nAvaiSamples);
            try
                [reData, wSet] = recover(dataX, dataY, avaiSampleSet, ...
                    inputPars, config);
            catch e
                count(r) = count(r) + 1;
                continue;
            end
            % Evaluation
            err_graph = evaluate_recovery(wSet, dataY, reData, config);
            metrics(:, r) = metrics(:, r) + err_graph;
        end        % Average
        iters = kFolds - count(r);
        metrics(:, r) = metrics(:, r) ./ iters;
    end

    fprintf("No of error cases: \n");
    for i = 1:length(interval)
        fprintf('%d: %d\n', i, count(i));
    end
    
    % Visualize
    close all
    plot_it('Percentage Error distribution', param, 'Average error', ...
        ranges(param), metrics(1, :), metrics(2, :)); 
%     plot_it('Precision', mode, 'Precision', ranges(mode), ...
%         report, {'accTrain', 'accTest'});
%     plot_it('Norm', mode, 'Norm', ranges(mode), ...
%         report, {'rmseTrain', 'rmseTest'});
end

function plot_it(name, labelx, labely, samples, value1, value2)
    figure(); hold on
    title(name);
    plot(samples, value1, samples, value2);  
    legend('Observed', 'UnObserved', 'Location', 'northeast');
    legend('boxoff');
    xlabel(labelx);
    ylabel(labely);
end