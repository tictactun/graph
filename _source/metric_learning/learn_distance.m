
% Machine learning approaches
function mdl = learn_distance(X, y, mode)
%     y = normc(y) / size(y, 2);
    if mode == 1
        mdl = train1(X, y);
    elseif mode == 2
        mdl = train2(X, y);
    elseif mode == 3 
        mdl = get_lasso(X, y);
    elseif mode == 4
        mdl = learn_metric(X, y);
    elseif mode == 5
        mdl = train5(X, y);
    end
end

% we should do {feature scaling; cross valuation}

% approach 1: learn directly CSF
function mdl = train1(X, y)
    % regularizer: lasson to sparsify
    mdl = fitlm(X, y);
%     mdl = mvregress(X, y);
%     mdl = fitrtree(X, y);
end

% approach 2: learn CSF pair similarity
function mdl = train2(X, y)
    % generate difference dataset
    m = size(y, 1); 
    s = nchoosek(m, 2);
    Xnew = zeros(s, size(X,2));
    ynew = zeros(s, 1);
    count = 0;
    for i = 1:m-1
        for j = i+1:m 
            count = count + 1;
            Xnew(count, :) = abs(X(i, :) - X(j, :));
            ynew(count) = norm(y(i) - y(j), 2);
        end
    end
%     model = fitlm(Xnew, ynew);
%     model = mvregress(Xnew, ynew);
    mdl = get_lasso(Xnew, ynew);
end

function mdl = train5(X, y)
    % generate difference dataset
    m = size(y, 1); 
    load mat/A.mat A
    A = A(1:m, 1:m);
    
    Xnew = [];
    ynew = [];
    
    neg = 0;
    pos = sum(A(:) == 1) / 2;
    
    for i = 1:m-1
        for j = i+1:m 
            if A(i, j) == 1 || neg < pos * 2
                if A(i, j) == 0
                    neg = neg + 1;
                end
                Xnew(end + 1, :) = X(i, :) - X(j, :);
                ynew(end + 1, 1) = A(i, j);
            end
        end
    end
    mdl = fitcnb(Xnew, ynew);
end

