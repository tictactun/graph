function A = learn_metric(X, y)
    % construct C
    A = MetricLearning(@ItmlAlg, y, X);
    return;
    
    params = SetDefaultParams(struct());
    A0 = eye(size(X, 2));
    
    % Choose the number of constraints to be const_factors times the number of
    % distinct pairs of classes
    % Determine similarity/dissimilarity constraints from the true labels
    [l, u] = ComputeDistanceExtremes(X, 10, 90, A0);
    m = length(y);
%     C = zeros(num_constraints, 4);
    C = [];
    load Atrue.mat A
    A = A(1:m, 1:m);
    nNeg = 2 * sum(A(:) == 1);
    for i = 1:m
        for j = i+1:m
            if A(i, j) == 1
                C(end + 1,:) = [i j 1 u];
            elseif nNeg > 0
                nNeg = nNeg - 1;
                C(end + 1,:) = [i j -1 l];
            end
        end
    end

    try    
        A = feval(@ItmlAlg, C, X, A0, params);
    catch   
        disp('Unable to learn mahal matrix');
        A = zeros(size(X, 2), size(X, 2));
    end  
end