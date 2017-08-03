function A = ensemble_graph(data, config, mdl)
    % params and vars
    maxIter = 1000;
    nOut = 20;
    
    sigma = config('preSigma');
    bin = config('binary');
    p = config('sim');
    
    % aggregated matrix
    nVertices = size(data, 1);    
    A = zeros(nVertices, nVertices);
    
    parfor k = 1:maxIter
        s = zeros(nVertices, nVertices);
        wSet = randi(nVertices, nOut, 1);
        % Adjacency matrix
        for i = 1:nVertices
            Xi = data(i, :);
            for j = i:nVertices
                Xj =  data(j, :);
                if ~ismember(j, wSet) || ~ismember(i, wSet)
                    s(i, j) = get_similarity(Xi, Xj, sigma, config, mdl);
                    s(j, i) = s(i, j);
                end
            end
        end
        % Thresholding
        [s, ~] = prune(nVertices, s, p, bin);
        A = A + s;
    end
    
    [A, ~] = prune(nVertices, A, p, bin);
end
