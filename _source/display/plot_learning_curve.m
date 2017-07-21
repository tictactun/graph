function plot_learning_curve(param)
    % Setting
    [inputParams, config] = init();     
    rAvai = inputParams('rAvaiSamples');
    rMax = inputParams('rMaxSamples');
    nVertices = size(originX, 1);
    kFolds = 5;
    
    % Load csv file into 2 parts: construction and completion
    [dataX, dataY] = process_data(inputParams);  
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
    if strcmp('rMaxSamples', param) 
        rMaxSamples = ranges('rMaxSamples');
        interval = 1; % 1 round only
    else
        rMaxSamples = config('rMaxSamples');
    end

    % metrics
    tests = {'accTest', 'accTrain', 'rmseTest', 'rmseTrain', 'meTest', ...
        'meTrain'};
    report = containers.Map;
    for i = 1:length(tests)
        report(tests{i}) = zeros(length(interval), length(rMaxSamples));
    end
    
    count = zeros(length(interval), 1);
    for r = 1:length(interval)
        try 
            % modify values
            config(param) = interval(r);   
            fprintf('%s  = %.2f\n', param, interval(r));
            % new available dataset
            nAvaiSamples = ceil(rAvai * nVertices);
            step = ceil((nVertices - nAvaiSamples) / kFolds) - 1;
            % for each fold
            for k = 1:kFolds
                % pre-game
                avaiSampleSet = step * (k - 1) + (1:nAvaiSamples);
                mdl = false;
                if rAvai > 0
                    [X, mdl] = pregame(dataX, dataY, avaiSampleSet, config);
                    dataX = X;                    
                end

                % construct graph: using selected features
                myGraph = construct_graph(dataX, config, mdl);
                myGraph.data = dataY; % f includes unseen data
                myGraph.preWSet = avaiSampleSet;
                myGraph.rMaxSamples = rMax;

                scores = vary_max_sample(myGraph, config, rMaxSamples);
                % collect score
                for i = 1:length(tests)
                    t = report(tests{i});
                    t(r, :) = t(r, :) + scores(tests{i})';
                    report(tests{i}) = t;
                end
                count(r) = count(r) + 1;
            end
        catch
            fprintf('Error\n');
        end
    end
    % Average
    for i = 1:length(tests)
        report(tests{i}) = report(tests{i}) / kFolds ;
    end
    
    value2 = report('meTest');
    for i = 1:length(interval)
        fprintf('%.4f\n', value2(i));
    end
    for i = 1:length(interval)
        fprintf('%d: %d\n', i, count(i));
    end
    
    % Visualize
    close all
%     plot_it('Precision', mode, 'Precision', ranges(mode), ...
%         report, {'accTrain', 'accTest'});
    plot_it('Percentage Error distribution', param, 'Average error', ...
        ranges(param), report, {'meTrain', 'meTest'}); 
%     plot_it('Norm', mode, 'Norm', ranges(mode), ...
%         report, {'rmseTrain', 'rmseTest'});
end

function plot_it(name, labelx, labely, samples, report, terms)
    figure(); hold on
    title(name);
    value1 = report(terms{1});
    value2 = report(terms{2});
    plot(samples, value1(:), samples, value2(:));  
    legend('Observed', 'Unobserved', 'Location', 'northeast');
    legend('boxoff');
    xlabel(labelx);
    ylabel(labely);
end