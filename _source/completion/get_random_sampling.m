function [w, projMatrix, dpMatrix] = get_random_sampling(p, m, opt)

    dpMatrix = diag(p);
    n = length(p);

    mode = 1;
    if nargin >= 3
        mode = opt.mode;
    end
    
    switch(mode)
        case 1 
            w = randsample(n, m, true, p);
        case 2
            [~, w] = sort(p, 1, 'descend');
            w = w(1:m);
        case 3
            % without replacement
            w = datasample(1:n, m, 'Replace', false, 'Weights', p); 
    end
    
    % sampling matrix
    projMatrix = get_projection_matrix(n, w);
end
