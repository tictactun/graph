function lGraph = construct_graph(dataX, config)
   
    lGraph.nVertices = size(dataX, 1);
    
    % construct graph based on the construction data
    A = construct_adjacency(dataX, config);
      
    % normalize graph
    normA = normalize_matrix(A);

    % Calculate Laplacian graph
    [V, D] = construct_laplacian(normA);
    
    nBands = ceil(config.rBand * lGraph.nVertices);    
    lGraph.Vk = V(:, 1:nBands);
    lGraph.Dk = D(1:nBands);  
end

% normalized matrix
function normA = normalize_matrix(A)
    normA =  A - min(A(:));
    normA = normA ./ max(normA(:));
end