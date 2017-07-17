
% Machine learning approaches
function mdl = learn_distance(X, y, mode)
%     X = randn(100,5);
%     y = X*[1;0;3;0;-1]+randn(100,1);
    y = normc(y) / size(y, 2);
    if mode == 1
        mdl = train1(X, y);
    elseif mode == 2
        mdl = train2(X, y);
    elseif mode == 3 
        mdl = get_lasso(X, y);
    end
end

% we should do {feature scaling; cross valuation}

% approach 1: learn directly CSF
function model = train1(X, y)
    % regularizer: lasson to sparsify
%     model = fitlm(X, y);
    model = mvregress(X, y);
end

function sim = rbf(d, sigma) 
    sim = exp(-d .^2 ./(2 * sigma^2));
end
% approach 2: learn CSF pair similarity
function model = train2(X, y)
    % generate difference dataset
    sigma = 0.1;
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
    model = get_lasso(Xnew, ynew);
end
