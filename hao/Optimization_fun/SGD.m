
function [W] = SGD(problem,W0,options)
W = W0;
Wbest = W0;
mmdbest = problem.cost(Wbest);
S = options.subsetS;
RS = randi([1,options.maxiter],[1,S]);
for k = 1:options.maxiter 
    grad_Batch = zeros(size(W));
    for mb = 1:problem.batch
        grad = problem.egrad(W);
        grad_Batch =grad_Batch+grad;
    end
    grad_Batch = grad_Batch./problem.batch;
    step = problem.stepsize(k);
    if strcmp(problem.M,'Stief')
        W = exponential(W,grad_Batch,-step);
    elseif strcmp(problem.M,'Eucli')
        W = W-step.*grad_Batch;
    end
    if ismember(k,RS)
        mmdcurrent = problem.cost(W);
        if mmdcurrent<mmdbest
            Wbest = W;
            mmdbest = mmdcurrent;
        end
    end
end
W = Wbest;
end