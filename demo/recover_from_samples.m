function f_hat = recover_from_samples(y, M, Pw, graph, config)   
    if 1 == config.kernelMode 
        lh = diag(graph.Dk);
    else
        lh = diag(config.kernel(graph.Dk)); % Why this?
    end

    % solving eq (10) in the paper
    MV = M * graph.Vk;
    Pw_inv = diag(1 ./ Pw); % is this correct?
    
    A = MV' * Pw_inv * MV + config.gamma * lh;
    B = MV' * Pw_inv * y;

    f_hat = A\B; % Is this correct?
    %x_hat = inv(A'*A) * A'*B;
end 
