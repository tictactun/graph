%% Graph evaluation using m-sample validation set
% val set must consist of the first m samples of graph
function score = evaluate_graph(graph, val)
    m = size(val, 1); % number of validation samples
    a = graph(1:m, 1:m); % adjacency matrix of 1st m vertices
    
    % val to adj distance using CSF data
    sig = 0.7;
    s = zeros(m, m);
    for i = 1:m
        for j = (i + 1): m
            s(i, j) = get_similarity(val(i, :), val(j, :), sig);
            s(j, i) = s(i, j);
        end
        s(i, i) = 0; % this is for adj matrix, not distance matrix
    end
    
    % normalize both 2 matrices
    
    % norm 2 or correlation?
%     score = norm(a - d, 2); 
    score = corr2(a, d);
end