function pred = get_baseline(dataX, dataY, wSet, config) 
    % train
    Xtrain = dataX(wSet, :);
    ytrain = dataY(wSet, :);
    
    learnMode = config('baselineMode');
    switch (learnMode)
        case 1
            mdl = fitlm(Xtrain, ytrain);
            pred = predict(mdl, dataX);
        case 2
            mdl = get_lasso(Xtrain, ytrain);
            pred = mdl.b0 + dataX * mdl.b;
        case 3 % regresssion tree
            mdl = fitrtree(Xtrain, ytrain);
            pred = predict(mdl, dataX);
        otherwise % ensemble
            mdl = fitrensemble(Xtrain, ytrain);
            pred = predict(mdl, dataX);
    end
end


