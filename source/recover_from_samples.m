function f_hat = recover_from_samples(y, M, Pw, lGraph, config)   
    if 1 == config('kernelMode')
        lh = diag(lGraph.Dk);
    elseif 2 ==config('kernelMode')
        kernel = config('kernel');
        lh = diag(kernel(lGraph.Dk)); 
    else
        lh = 1;
    end

    % solving eq (10) in the paper
    MV = M * lGraph.Vk;
    Pw_inv = diag(1 ./ Pw); % is this correct?
    
    A = MV' * Pw_inv * MV + config('gamma') * lh;
    B = MV' * Pw_inv * y;
   
    f_hat = A\B; 
end 
