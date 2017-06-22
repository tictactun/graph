%{
    Project: Graph completion
    File: main
    Author: Tuan Dinh
    Description: graph completion 
%}

% Data: (1199, 33), last 6 missing features, top 147 is full
% 1 header row, 1 id columns
function main
    % Load setup
    [input, config] = setup();    
    % Load csv file into 2 parts: construction and completion
    [dataX, dataY] = process_data(input);  
    
    % pre training 
    nAvaiSamples = input.rAvaiSamples * size(dataY, 1);
    avaiSampleSet = 1:nAvaiSamples; % can be updated
    if input.rAvaiSamples > 0
        avaiX = dataX(avaiSampleSet, :);
        avaiY = dataY(avaiSampleSet, :);
        % correlation
        if config.nSelectedFeatures > 0
            xCols = select_features(avaiX, avaiY, ...
                                    config.nSelectedFeatures);
            avaiX = avaiX(:, xCols);
            dataX = dataX(:, xCols);
        end
        % distance learning
        if config.learningMode > 0
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
    
    % Recover
    [reData, wSet] = recover_graph(myGraph, config);
    
    % Evaluation
    [acc, rmse, err] = evaluate_recovery(wSet, myGraph.data, reData, ...
        config.epsilon);
            
    % recover graph
    print_result(acc, rmse, err);    
    
    % visualize
    visualize(0, myGraph.data, reData, wSet);
end