%% sparsification
function [p, s, dk] = get_kNN(k, simMatrix)
    % kNN: there may be more than k edges
    nVertices = size(simMatrix, 1);
    p = zeros(nVertices, nVertices);
    s = zeros(nVertices, nVertices);
    sk = 0; % total distance of each sample to its kth neigbor
    for i = 1:nVertices
        [~, ind] = sort(simMatrix(i, :), 'descend');
        bestKInd = ind(1:k);
        
        % projection matrix
        p(i, bestKInd) = 1;
        p(bestKInd', i) = 1; %transpose
        
        % apply to sim matrix
        s(i, bestKInd) = simMatrix(i, bestKInd);
        s(bestKInd', i) = simMatrix(bestKInd', i);
        
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

