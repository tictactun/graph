function mdl = train_connection(X, A, trainMode)
    % using logistic regression
    m = size(X, 1); 
    neg = 0;
    pos = sum(A(:) == 1) / 2;

    Xnew = [];
    ynew = [];
    
    for i = 1:m-1
        for j = i+1:m 
            if A(i, j) == 1 || neg <= pos * 3
                if A(i, j) == 0
                    if rand() > 0.5
                        neg = neg + 1;
                    else
                        continue;
                    end
                end
                d = abs(X(i, :) - X(j, :));
                Xnew(end + 1, :) = d; %exp(-d.^2/0.25);
                ynew(end + 1, :) = A(i, j);
            end
        end
    end   
    
    switch (trainMode)
        case 1 % logistic
            count = length(ynew);
            mdl = glmfit(Xnew, [ynew ones(count, 1)], ...
                 'binomial', 'link', 'logit');    
        case 2 % nb
            mdl = fitcnb(Xnew, ynew);
        case 3 % svm
            mdl = fitcsvm(Xnew, ynew);
        case 4 % ensemble
            mdl = fitensemble(Xnew, ynew, 'AdaBoostM1', 100,'Tree');
        case 5 % random forest
            mdl = TreeBagger(10, Xnew, ynew);
    end
    
    
    % For testing 
%     for i = 1:m-1
%         for j = i+1:m 
%             Xnew(end + 1, :) = abs(X(i, :) - X(j, :));
%             ynew(end + 1, :) = A(i, j);
%         end
%     end 
    if 1 == trainMode
        pred = zeros(length(ynew), 1);
        for i = 1:length(ynew)
            pred(i, :) = logReg([1 Xnew(i, :)] * mdl);
        end
    elseif 5 == trainMode
        [labels, ~, ~] = predict(mdl, Xnew);
        pred = zeros(length(labels), 1);
        for i = 1:length(labels)
            label = labels(i);
            pred(i, :) = str2double(label{1});
        end
    else
        pred = predict(mdl, Xnew);
    end
        
    get_accuracy(ynew, pred, 0.5, 1)
end