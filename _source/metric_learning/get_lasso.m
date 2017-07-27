function mdl = get_lasso(Xtrain, ytrain)
    mdl.b = zeros(size(Xtrain, 2), size(ytrain, 2));
    mdl.b0 = zeros(1, size(ytrain, 2));
    for i = 1:size(ytrain, 2)
        y = ytrain(:, i);
        [B, FitInfo] = lasso(Xtrain, y);
%         B = ridge(ytrain, Xtrain, );
        [~, idx] = min(FitInfo.MSE);
        mdl.b(:, i) = B(:, idx);
        mdl.b0(:, i) = FitInfo.Intercept(idx);
    end
end