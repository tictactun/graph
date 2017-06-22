function f_hat = recover_from_samples(y, M, Pw, lGraph, config)   
    if 1 == config.kernelMode 
        lh = diag(lGraph.Dk);
    else
        lh = diag(config.kernel(lGraph.Dk)); 
    end

    % solving eq (10) in the paper
    MV = M * lGraph.Vk;
    Pw_inv = diag(1 ./ Pw); % is this correct?
    
    A = MV' * Pw_inv * MV + config.gamma * lh;
    B = MV' * Pw_inv * y;
    
    C = MV' * Pw_inv * MV;
    D = MV' * Pw_inv * y; 
    E = config.gamma * ones(1, lGraph.nVertices) * lGraph.Vk * lh;

    f_hat = A\B; % Is this correct?
%     f_hat = inv(A) * B;
%     f_hat = C\(D + E');
    %x_hat = inv(A'*A) * A'*B;
end 
