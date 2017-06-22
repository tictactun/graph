function report = vary_max_sample(lGraph, config, maxSamples) 
    % Recover and get accuracy
    report.accTrain = [];
    report.accTest = [];
    report.rmseTrain = [];
    report.rmseTest = [];
    report.meTest = [];
    report.meTrain = [];
%     report.eDistLst = zeros(lGraph.nVertices, 1);
    
    for i = 1:length(maxSamples)
        lGraph.rMaxSamples = maxSamples(i);
%         fprintf('Max Samples = %.2f\n', lGraph.rMaxSamples);
        % Recover
        [reData, wSet] = recover_graph(lGraph, config);
        % Evaluation
        [acc, rmse , err] = evaluate_recovery(wSet, ...
                        lGraph.data, reData, config.epsilon);
        report.accTrain(end + 1) = acc.train;
        report.accTest(end  + 1) = acc.test;
        report.rmseTrain(end + 1) = rmse.train;
        report.rmseTest(end  + 1) = rmse.test;
        report.meTest(end + 1) = err.test;
        report.meTrain(end + 1) = err.train;
%         report.eDistLst = report.eDistLst + eDist;
    end
%     report.eDistLst = report.eDistLst / length(maxSamples);
end