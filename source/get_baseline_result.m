% Baseline methods
function g2 = get_baseline_result(graph, kernel)
    
    p_orig = sample_prob(graph, config, mode);
    opt.mode = 3;   
    % opt = 1: random sampling with replacement, 
    % 2: select m nodes with higher prob. 
    [w_orig, M_orig, P] = random_sampling(p_orig, nSamples, opt);
    % opt.t = t;
    % [w_orig, M_orig] = adaptive_sampling(p, m, Dk, Vk, opt);
    y = verticeValues(w_orig,:);
    g2_hat = recover_from_samples(p_orig(w_orig), y, gamma, M_orig, Uk, Dk);     
    g2 = Uk * g2_hat; 
end
