function A = construct_adjacency(data, config)
    % params & variables
    nVertices = size(data, 1);
    % undirected graph => distance matrix (not adj matrix)
    
    s = zeros(nVertices, nVertices);
%     % should ensure that s(i, j) = 0 because of adjacency matrix
%     for i = 1:nVertices
%         for j = i+1:nVertices
%             s(i, j) = get_similarity(data(i, :), data(j, :), ...
%                 config('preSigma'), config);
%             s(j, i) = s(i, j);
%         end
%     end

    load Atrue.mat
    m = size(data, 1);
    Y = A(1:m, 1:m);
    X = data;
    b = train_connection(X, Y);
    for i = 1:nVertices
        for j = i+1:nVertices
            d = abs(X(i, :) - X(j, :));
            s(i, j) = logistic([1 d] * b);
%             s(i, j) = rand(1);
            s(j, i) = s(i, j);
        end
    end

    p = config('sim');
    threshold = prctile(s(:), p);
%     threshold = 0.5;
    for i = 1:nVertices
        for j = i+1:nVertices
            if s(i, j) <= threshold
                s(i, j) = 0;
            elseif config('binary') == true
                s(i, j) = 1;
            end
            s(j, i) = s(i, j);
        end
    end
    A = s;
    
    % sparsification: mutual kNN or b-matching or thresholding
    % similarity => not distance
    k = config('kNeighbors');
    if  k > 0
        [p, dk] = get_kNN(k, s);
        % re-weighting: Gaussian or LLS
        sig = config('preSigma');
%         sig = dk/3; % ref from Tony
        a = zeros(nVertices, nVertices);
        for i = 1:nVertices
            for j = (i + 1):nVertices
                if p(i, j) == 1
                    a(i, j) = get_similarity(data(i, :), data(j, :), ...
                            sig, config);
                    a(j, i) = a(i, j);
                    if a(i, j) ~= a(i, j)
                        fprintf('Inf here\n');
                    end
                end
            end
            a(i, i) = 1; % just make sure
        end
        A = a;
    end
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


