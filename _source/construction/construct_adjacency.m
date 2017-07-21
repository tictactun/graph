function A = construct_adjacency(data, config, mdl)
    % params & variables
    nVertices = size(data, 1);
    % undirected graph => distance matrix (not adj matrix)
    % Similarity matrix
    matrixMode = 1;
    s = zeros(nVertices, nVertices);
    % should ensure that s(i, j) = 0 because of adjacency matrix
    switch (matrixMode)
        case 1 % normal
            for i = 1:nVertices
                for j = i+1:nVertices
                    s(i, j) = get_similarity(data(i, :), data(j, :), ...
                        config('preSigma'), config, mdl);
                    s(j, i) = s(i, j);
                end
            end
        case 2 % random
            for i = 1:nVertices
                for j = i+1:nVertices
                    s(i, j) = rand(1);
                    s(j, i) = s(i, j);
                end
            end            
        case 3 % training
            load Atrue.mat A
            Y = A(1:nVertices, 1:nVertices);
            b = train_connection(data, Y);
            for i = 1:nVertices
                for j = i+1:nVertices
                    d = abs(data(i, :) - data(j, :));
                    s(i, j) = logistic([1 d] * b);
                    s(j, i) = s(i, j);
                end
            end
    end
   
    % sparsification: mutual kNN or b-matching or thresholding
    % similarity => not distance
    k = config('kNeighbors');
    if  k > 0
        [~, s, ~] =  get_kNN(k, s);
        % re-weighting: Gaussian or LLS
        % sig = dk/3; % ref from Tony
    end
    [A, ~] = prune(nVertices, s, config('sim'), config('binary'));
end