function [upperbound, lowerbound] = get_conductance(bin)
     % Load setup
    [inputParams, config] = setup();    
    % Load csv file into 2 parts: construction and completion
    [dataX, dataY] = process_data(inputParams);  
    dataY = dataY(:, inputParams('yOffset'));
%     load ../hao/Xs.mat Xsource
%     dataX = Xsource;
    % Pre-game - it should be repeated everytime new sample is coming
    nAvaiSamples = inputParams('rAvaiSamples') * size(dataY, 1);
    avaiSampleSet = 1:nAvaiSamples; % can be updated
    if inputParams('rAvaiSamples') > 0
        [X, model] = pregame(dataX, dataY, avaiSampleSet, config);
        dataX = X;
        config('disModel') = model;
    end
    
    config('binary') = bin;
    
    thresholds = 10 * (1:9);
    upperbound = zeros(length(thresholds), 1);
    lowerbound = zeros(length(thresholds), 1);
    for i = 1:length(thresholds)
        config('sim') = thresholds(i);
         % construct graph based on the construction data
        A = construct_adjacency(dataX, config);
        % normalize graph
%         normA = normalize_matrix(A);
        % Calculate Laplacian graph
        [V, D] = construct_laplacian(A);
        % descending 
        lamda2 = D(end - 1);
        lowerbound(i) = lamda2/2;
        upperbound(i) = sqrt(2 * lamda2);        
    end
end