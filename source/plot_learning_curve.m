function plot_learning_curve(mode)

    % Load setup
    [input, config] = setup();    
    % Load csv file into 2 parts: construction and completion
    [dataX, dataY] = process_data(input);  

    if mode == 1
        rMaxSamples = 0.6 + [0:7] * 0.05;
        rAvaiSamples = 0.4;
        config.alg = 2;
    else
        rMaxSamples = 1;
        rAvaiSamples = 0.6 + [0:7] * 0.05;
        config.alg = 1;
    end
  
    report.accTest = zeros(length(rAvaiSamples), length(rMaxSamples));
    report.accTrain = zeros(length(rAvaiSamples), length(rMaxSamples));
    report.rmseTest = zeros(length(rAvaiSamples), length(rMaxSamples));
    report.rmseTrain = zeros(length(rAvaiSamples), length(rMaxSamples));
    report.meTest = zeros(length(rAvaiSamples), length(rMaxSamples));
    report.meTrain = zeros(length(rAvaiSamples), length(rMaxSamples));

    kFold = 5;
    learned = false;
    selected = false;
    xCols = [];
    for r=1:length(rAvaiSamples)
%         config.rBand = rAvaiSamples(r)
        fprintf('rAvai = %.2f\n', rAvaiSamples(r));
        nAvaiSamples = ceil(rAvaiSamples(r) * size(dataY, 1));
        step = ceil((size(dataY, 1) - nAvaiSamples) / kFold) - 1;
        for k = 0:kFold-1
%             fprintf('Fold = %d\n', k);
            avaiSampleSet = step * k + [1:nAvaiSamples];
            if input.rAvaiSamples > 0 && selected == false
                selected = true;
                avaiX = dataX(avaiSampleSet, :);
                avaiY = dataY(avaiSampleSet, :);
                % correlation
                if config.nSelectedFeatures > 0
                    xCols = select_features(avaiX, avaiY, ...
                                            config.nSelectedFeatures);
                end
                if ~isempty(xCols)
                    avaiX = avaiX(:, xCols);
                    dataX = dataX(:, xCols);
                end
                % distance learning
                if config.learningMode > 0 && learned == false
                   learned = true;
                   config.disModel = learn_distance(avaiX, avaiY, ...
                                                config.learningMode);
                end                
            end

            % construct graph: using selected features - new learned distance
            myGraph = construct_graph(dataX, config);

            % data
            myGraph.data = dataY; % f includes unseen data, for the testing purpose
            myGraph.preWSet = avaiSampleSet;
            myGraph.rMaxSamples = input.rMaxSamples;

            acc = vary_max_sample(myGraph, config, rMaxSamples);
            
            report.accTest(r, :)    = report.accTest(r, :) 	+ acc.accTest;
            report.accTrain(r, :) 	= report.accTrain(r, :) + acc.accTrain;
            report.rmseTest(r, :) 	= report.rmseTest(r, :) + acc.rmseTest;
            report.rmseTrain(r, :)  = report.rmseTrain(r, :) + acc.rmseTrain;
            report.meTest(r, :)     = report.meTest(r, :)	+ acc.meTest;
            report.meTrain(r, :)	= report.meTrain(r, :)	+ acc.meTrain;
        end
        report.accTest(r, :)    = report.accTest(r, :)  / kFold ;
        report.accTrain(r, :)   = report.accTrain(r, :) / kFold	;
        report.rmseTest(r, :) 	= report.rmseTest(r, :) / kFold	;
        report.rmseTrain(r, :)  = report.rmseTrain(r, :)/ kFold ;
        report.meTest(r, :)     = report.meTest(r, :)	/ kFold	;
        report.meTrain(r, :)     = report.meTrain(r, :)	/ kFold	;
    end

    close all

    if length(rAvaiSamples) == 1
        rSamples = rMaxSamples;
    else
        rSamples = rAvaiSamples;
    end
    
    figure(); hold on
    title('Acurracy for 15% interval');
    plot(rSamples, report.accTrain(:), rSamples, report.accTest(:));   
    legend('Sampled', 'Unsampled', 'Location', 'northeast');
    legend('boxoff');
    xlabel('Maximum samples');
    ylabel('Accuracy in %');

    figure(); hold on
    title('Norm 2');
    ylabel('Norm 2');
%     ylabel('RMSE');
%     title('RMSE');
    plot(rSamples, report.rmseTrain(:), rSamples, report.rmseTest(:));   
    legend('Sampled', 'Unsampled', 'Location', 'northeast');
    legend('boxoff');
    xlabel('Maximum samples');
        
    figure(); hold on
    title('Percentage Error distribution');
    plot(rSamples, report.meTrain(:), rSamples, report.meTest(:));
    xlabel('Available samples');
    ylabel('Average error in %');
    legend('Sampled', 'Unsampled', 'Location', 'northeast');
    legend('boxoff');
    hold off;
end