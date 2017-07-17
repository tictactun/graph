function A = ensemble_graph(data, config)
    nVertices = size(data, 1);    
    % set of random rows
    A = zeros(nVertices, nVertices);
    maxIter = 5000;
    p = 90;
    nOut = 25;
    for k = 1:maxIter
        s = zeros(nVertices, nVertices);
        wSet = randi(nVertices, nOut, 1);
        % Adjacency matrix
        for i = 1:nVertices
            if ~ismember(i, wSet)
                for j = i:nVertices
                    if ~ismember(j, wSet)
                        s(i, j) = get_similarity(data(i, :), data(j, :),...
                            config('preSigma'), config);
                        s(j, i) = s(i, j);
                    end
                end
            end
        end
        % Thresholding
        [s, t] = prune(nVertices, s, p, config('binary'));
        A = A + s .* t;
    end
    p = 90;
    A = prune(nVertices, A, p, config('binary'));
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
