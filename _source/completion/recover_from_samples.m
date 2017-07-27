function f_hat = recover_from_samples(y, M, Pw, lGraph, config)   
    warning off;
    kmode = config('kernelMode');
    switch (kmode)
        case 1
            lh = diag(lGraph.Dk);
        case 2 
            kernel = config('kernel');
            lh = kernel(diag(lGraph.Dk)); 
        case 3 
            lh = lGraph.Vk * lGraph.Vk';
        case 4
            % introduce I values 
            lh = 1;
    end

    lambda = config('gamma');
    regMode = 2;
    
    if regMode == 2
        % solving eq (10) in the paper
        MV = M * lGraph.Vk;
        Pw_inv = diag(1 ./ Pw);

        A = MV' * Pw_inv * MV + lambda * lh;
        B = MV' * Pw_inv * y;

        f_hat = A\B; 
    else
        Pw_inv = diag(1 ./ Pw.^2); 
        A = Pw_inv * M;
        y = Pw_inv * y;    
        rel_tol = 0.01;
        lambda = 0.01;

        [f, ~] = l1_ls(A,y,lambda,rel_tol);
        f_hat = lGraph.Vk * f;
    end
end 
