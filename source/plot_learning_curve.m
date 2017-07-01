function plot_learning_curve(mode)

    % Setting
    [inputParams, config] = setup();   
    config('alg') = 2;
    config('rMaxSamples') = 0.8;
    config('rAvaiSamples') = 0.2;
    kFold = 5;
    
    % Load csv file into 2 parts: construction and completion
    [dataX, dataY] = process_data(inputParams);  

    % values
    ranges = containers.Map;
    ranges('rMaxSamples')   = 0.6 + (0:7) * 0.05;
    ranges('rAvaiSamples')  = 0.2 + (0:7) * 0.05;
    ranges('preSigma')      = 0.02 + 0.02 * (0:20); %sigma
    ranges('nSelectedFeatures') = 1 + 2 * (0:10); % 
    ranges('gamma')         = 0.01 + 0.3 * (0:40); % gamma
    ranges('rBand')         = 0.1 + (0:18) * 0.05; % 
    ranges('kNeighbors')    = 1 + 1 * (0:20); % knn
    range = ranges(mode);
    if strcmp('rMaxSamples', mode) 
        rMaxSamples = ranges('rMaxSamples');
        range = 1; % 1 round only
    else
        rMaxSamples = config('rMaxSamples');
    end

    % metrics
    tests = {'accTest', 'accTrain', 'rmseTest', 'rmseTrain', 'meTest', ...
        'meTrain'};
    report = containers.Map;
    for i = 1:length(tests)
        report(tests{i}) = zeros(length(range), length(rMaxSamples));
    end
    
    for r = 1:length(range)
        % modify values
        config(mode) = range(r);   
        fprintf('rAvai = %.2f\n', range(r));
        % new available dataset
        nAvaiSamples = ceil(config('rAvaiSamples') * size(dataY, 1));
        step = ceil((size(dataY, 1) - nAvaiSamples) / kFold) - 1;
        % for each fold
        for k = 1:kFold
            % pre-game
            avaiSampleSet = step * (k - 1) + (1:nAvaiSamples);
            if inputParams('rAvaiSamples') > 0
                [X, model] = pregame(dataX, dataY, avaiSampleSet, config);
                dataX = X;
                config('disModel') = model;
            end

            % construct graph: using selected features
            myGraph = construct_graph(dataX, config);

            % data
            myGraph.data = dataY; % f includes unseen data
            myGraph.preWSet = avaiSampleSet;
            myGraph.rMaxSamples = inputParams('rMaxSamples');
            
            scores = vary_max_sample(myGraph, config, rMaxSamples);
            % collect score
            for i = 1:length(tests)
                t = report(tests{i});
                t(r, :) = t(r, :) + scores(tests{i})';
                report(tests{i}) = t;
            end
        end
        % Average
        for i = 1:length(tests)
            report(tests{i}) = report(tests{i}) / kFold ;
        end
    end

    % Visualize
    close all
    plot_it('Norm 2', mode, 'Norm 2', ranges(mode), ...
        report, {'rmseTrain', 'rmseTest'});
%     plot_it('Percentage Error distribution', mode, 'Average error', ...
%         ranges(mode), report, {'meTrain', 'meTest'});    
end

function plot_it(name, labelx, labely, samples, report, terms)
    figure(); hold on
    title(name);
    value1 = report(terms{1});
    value2 = report(terms{2});
    plot(samples, value1(:), samples, value2(:));  
    legend('Sampled', 'Unsampled', 'Location', 'northeast');
    legend('boxoff');
    xlabel(labelx);
    ylabel(labely);
end