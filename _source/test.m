function metrics = test(dataX, dataY, inputParams, config, alg)        
    nVertices = size(dataX, 1);
    if alg == 1
        rAvai = inputParams('rAvaiSamples');
        nAvaiSamples = ceil(rAvai * nVertices);
        avaiSampleSet = 1:nAvaiSamples;
        %     avaiSampleSet = randi(nVertices, nAvaiSamples, 1);  % random
        [recoveredData, wSet] = recover(dataX, dataY, avaiSampleSet, ...
            inputParams, config);
    else        
        rMax = inputParams('rMaxSamples');
        wSet = 1: ceil(rMax * nVertices);
        recoveredData = get_baseline(dataX, dataY, wSet, config);
    end
    % Evaluation
    metrics = evaluate_recovery(wSet, dataY, recoveredData, config);             
end