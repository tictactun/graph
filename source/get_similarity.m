%% similarity
function sim = get_similarity(x1, x2, sigma, config)
    % current: Euclidean distance
    if config('learningMode') == 1
        mdl = config('disModel');
        x1 = x1 * mdl;
        x2 = x2 * mdl;
        d = norm(x1 - x2, 2);
    elseif config('learningMode') == 2
        mdl = config('disModel');
        x = abs(x1 - x2);
        d = mdl.b0 + x * mdl.b;
    elseif config('learningMode') == 3
        mdl = config('disModel');
        x1 = mdl.b0 + x1 * mdl.b;
        x2 = mdl.b0 + x2 * mdl.b;
        d = norm(x1 - x2, 2);
    else
        d = norm(x1 - x2, 2); 
    end
    
    gamma = 1 / length(x1);
    switch config('simKernel') 
        case 1 % norm
            sim = d;
        case 2 % laplacian
            d = norm(x1 - x2, 1);
            sim = exp(-gamma * d);
        case 3 % rbf
            sim = exp(-d^2/(2 * sigma^2));
        case 4 % linear
            sim = x1 * x2';
        case 5 % poly 3
            sim = (gamma * x1 * x2' + 1)^3;
        case 6 % sigmoid
            sim = tanh(0.5 * x1 * x2');
    end
    
end