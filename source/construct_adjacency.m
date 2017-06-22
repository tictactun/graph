function A = construct_adjacency(data, config)
    % params & variables
    nVertices = size(data, 1);
    % undirected graph => distance matrix (not adj matrix)
    s = zeros(nVertices, nVertices);
    for i = 1:nVertices
        for j = (i + 1): nVertices
            s(i, j) = get_similarity(data(i, :), data(j, :), ...
                config.preSigma, config);
            s(j, i) = s(i, j);
        end
        s(i, i) = 0;
    end
    
    % sparsification: mutual kNN or b-matching or thresholding
    k = config.kNeighbors;
    [p, dk] = get_kNN(k, s);
    
    % re-weighting: Gaussian or LLS
    sig = dk/3; % ref from Tony
    a = zeros(nVertices, nVertices);
    for i = 1:nVertices
        for j = (i + 1):nVertices
            if p(i, j) == 1
                a(i, j) = get_similarity(data(i, :), data(j, :), ...
                        sig, config);
                a(j, i) = a(i, j);
            end
        end
        a(i, i) = 0; % just make sure
    end
    A = a;
end

%% similarity

% Gaussian kernel
function sim = rbf(x, sigma) 
    sim = exp(-x/(2 * sigma^2));
end

% calculate distance between a pair of nodes
function sim = get_similarity(x1, x2, sigma, config)
    % should use ML to learn this distance
    % current: Euclidean distance
    if config.learningMode > 0
        [d, ~] = predict(config.disModel, abs(x1 - x2));     
    else
        d = norm(x1 - x2, 2); 
    end
    sim = rbf(d, sigma);
end


%% sparsification
function [p, dk] = get_kNN(k, simMatrix)
    % kNN: there may be more than k edges
    nVertices = size(simMatrix, 1);
    p = zeros(nVertices, nVertices);
    sk = 0; % total distance of each sample to its kth neigbor
    for i = 1:nVertices
        [~, ind] = sort(simMatrix(i, :), 'descend');
        bestKInd = ind(1:k);
        p(i, bestKInd) = 1;
        p(bestKInd', i) = 1; %transpose
        % keep track of kth neighbor
        sk = sk + simMatrix(i, ind(k));
    end
    dk = sk / nVertices;
end

% tough
function get_bMatching()
end

% tough
function get_LLS()
end


