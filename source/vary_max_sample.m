function report = vary_max_sample(lGraph, config, maxSamples) 
    % Recover and get accuracy
    tests = {'accTest', 'accTrain', 'rmseTest', 'rmseTrain', 'meTest', ...
        'meTrain'};
    report = containers.Map;
    for i = 1:length(tests)
        report(tests{i}) = zeros(length(maxSamples), 1);
    end
    for i = 1:length(maxSamples)
        lGraph.rMaxSamples = maxSamples(i);
        % Recover
        [reData, wSet] = recover_graph(lGraph, config);
        % Evaluation
        err = evaluate_recovery(wSet, ...
                        lGraph.data, reData, config('epsilon'));
        for k = 1:length(tests)
            t = report(tests{k});
            t(i) = err(tests{k});
            report(tests{k}) = t;
        end
    end
end