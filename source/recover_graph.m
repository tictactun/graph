% Input: a dog mesh, a vector of values on M vertices
% Output: recovered signal - all values on N vertices
% Implement both 2 algorithms

function [f, wSet] = recover_graph(lGraph, config)
    if 1 == config.alg
        % ECCV: random sampling 
        [p, ~] = get_prob_dist(lGraph, config);
        wSet = lGraph.preWSet;
        Pw = p(wSet);
    else
        % Select and Recover algorithm
        [wSet, Pw] = select_and_recover(lGraph, config);
%         Pw = ones(length(wSet), 1) / lGraph.nVertices;
    end
    % recover
    y = lGraph.data(wSet, :);
    M = get_projection_matrix(lGraph.nVertices, wSet);
    % update for the last recovery
%     config.gamma = 0.1;
    
    fHat = recover_from_samples(y, M, Pw, lGraph, config);
    f = lGraph.Vk * fHat;   
end 







