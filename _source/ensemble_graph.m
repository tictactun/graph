function A = ensemble_graph(data, config)
    nVertices = size(data, 1);    
    % set of random rows
    A = zeros(nVertices, nVertices);
    maxIter = 1000000;
    p = 90;
    nOut = 20;
    sigma = config('preSigma');
    bin = config('binary');
    parfor k = 1:maxIter
        s = zeros(nVertices, nVertices);
        wSet = randi(nVertices, nOut, 1);
        % Adjacency matrix
        for i = 1:nVertices
            Xi = data(i, :);
            for j = i:nVertices
                Xj =  data(j, :);
                if ~ismember(j, wSet) || ~ismember(i, wSet)
                    s(i, j) = get_similarity(Xi, Xj, sigma, config);
                    s(j, i) = s(i, j);
                end
            end
        end
        % Thresholding
        [s, t] = prune(nVertices, s, p, true);
        A = A + s;
    end
    p = 90;
    A = prune(nVertices, A, p, true);
end

function [s, threshold] = prune(nVertices, s, p, bin)
    threshold = prctile(s(:), p);
    for i = 1:nVertices
        for j = i:nVertices
            if s(i, j) <= threshold
                s(i, j) = 0;
            elseif bin == true
                s(i, j) = 1;
            end
            s(j, i) = s(i, j);
        end
    end
end
