function err2 = get_baseline(dataX, dataY, wSet, config) 
    % train
    Xtrain = dataX(wSet, :);
    ytrain = dataY(wSet, :);
    model = fitlm(Xtrain, ytrain);

%     [pred, ~] = predict(model, dataX);
%     err = evaluate_recovery(wSet, dataY, pred, config);
%     plot_scatter(dataY, pred, wSet);

    mdl = get_lasso(Xtrain, ytrain);
    pred2 = mdl.b0 + dataX * mdl.b;
    err2 = evaluate_recovery(wSet, dataY, pred2, config);
%     fprintf('Lasso:\n');
%     print_result(err2);
end


