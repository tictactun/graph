function report = cv()
    [input, config] = setup();
    % Load csv file into 2 parts: construction and completion
    [dataX, dataY] = process_data(input); 
    
    maxSamples = [8:18] * 0.05;
    
    report.avgAccTest = zeros(length(maxSamples), 1);
    avgAccTrain = zeros(length(maxSamples), 1);
    avgRmseTest = zeros(length(maxSamples), 1);
    avgRmseTrain = zeros(length(maxSamples), 1);
    
    kFold = 5;
    
    for i = 1:kFold
        fprintf('Fold = %d\n', i);
        config.start = ceil(length(dataY) / 10) * (i -1);
        [accTrain, accTest, rmseTrain, rmseTest] = ...
            main(2, dataX, dataY, config, maxSamples);
        avgAccTest = avgAccTest + accTest;
        avgAccTrain = avgAccTrain + accTrain;
        avgRmseTest = avgRmseTest + rmseTest;
        avgRmseTrain = avgRmseTrain + rmseTrain;
    end
    report.avgAccTest = avgAccTest / kFold;
    report.avgAccTrain = avgAccTrain / kFold;
    report.avgRmseTest = avgRmseTest / kFold;
    report.avgRmseTrain = avgRmseTrain / kFold;
end
