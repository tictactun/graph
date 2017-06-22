% Input: a dog mesh, a vector of values on M vertices
% Output: recovered signal - all values on N vertices
% Implement both 2 algorithms

function [f, wSet] = recover_graph(alg, graph, config)

    if 1 == alg
        % ECCV: random sampling 
        [p, ~] = get_prob_dist(graph, config);
        wSet = graph.preWSet;
        Pw = p(wSet);
    else
        % Select and Recover algorithm
        [wSet, Pw] = select_and_recover(graph, config);
%         Pw = ones(length(wSet), 1) / graph.nVertices;
    end
    % recover
    y = graph.data(wSet, :);
    M = get_projection_matrix(graph.nVertices, wSet);
    config.gamma = 0.01;
    fHat = recover_from_samples(y, M, Pw, graph, config);
    f = graph.Vk * fHat;   
end 







