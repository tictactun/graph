function mdl = train_connection(X, A)
    % using logistic regression
    m = size(X, 1); 
    count = 0;
    neg = 0;
    pos = sum(A(:) == 1) / 2;
    
%     s = nchoosek(m, 2);
%     Xnew = zeros(s, size(X, 2));
%     ynew = zeros(s, 1);
    Xnew = [];
    ynew = [];
    
    for i = 1:m-1
        for j = i+1:m 
            if A(i, j) == 1 || neg < pos * 2
                if A(i, j) == 0
                    neg = neg + 1;
                end
                count = count + 1;
                Xnew(end + 1, :) = abs(X(i, :) - X(j, :));
                ynew(end + 1, :) = A(i, j);
            end
        end
    end
    mdl = glmfit(Xnew, [ynew ones(count, 1)], 'binomial', 'link', 'logit');
end