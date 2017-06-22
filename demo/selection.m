function [w M] = selection(m, I, Vk, Dk, t)

l=1;
N = size(Vk,1);

while(1)
    [val id] = max(I);    
    w(l) = id;
    
    M = sampling_matrix(w, N);
    
    y = f(w,:);

    if l==1
        % matlab lasso does not solve 1-dim case so use least-square...
        g_hat = recover_from_samples(p(w), y, gamma, M, Vk, Dk);     
    else
        [g_hat, stats] = lasso(M*Vk,y, 'Lambda', lambda);    
    end
    g = Vk*g_hat;    
    
    % update
    err = abs(f(w)-g(w));    
    acc = abs(1 - mean(err./abs(f(w))));
    
    if acc < 0.01
        acc = 0.01;
    elseif acc > 1.5
        acc=1.5;
    end    
    s = acc;
    
%     fprintf('%d. Sampling %dth vertex... Accuracy : %f --- max(I) = %f\n', l, id, acc, max(I));
    
    delta = zeros(N,1);    
    delta(id) = 1;    
    
    Ds = Vk*(exp(-acc*Dk).*(Vk'*delta));        
    Ds = I(id)*Ds/max(Ds);
    I = I - Ds;
    I(I<0) = 0;
    
    if length(unique(w)) == m
        break;
    end    
    l = l+1;
end

w = unique(w)';
M = sampling_matrix(w,N);