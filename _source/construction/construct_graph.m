function lGraph = construct_graph(dataX, config, mdl)   
    lGraph.nVertices = size(dataX, 1);
    
    % construct graph based on the construction data    
    if config('ensembleMode')
        A = ensemble_graph(dataX, config, mdl);
    else
        A = construct_adjacency(dataX, config, mdl);
    end
    
    % normalize graph
    normA = normalize_matrix(A);

    % Calculate Laplacian graph
    % for binary => dont need to normalize
    [V, D] = construct_laplacian(normA);
    
    nBands = ceil(config('rBand') * lGraph.nVertices);    
    lGraph.Vk = V(:, 1:nBands);
    lGraph.Dk = D(1:nBands);  
    
    %{     
    % Plot
    figure(); hold on;
    for i = 1:3
        Vk = V(:, i:i+1);
        A12 = A * Vk;
        subplot(3, 1, i);
        scatter(A12(:, 1), A12(:, 2), 'filled', 'b');
        xlabel(i);
        ylabel(i + 1);
        title('Cheap graph');
    end
    %}
end

% normalized matrix
function normA = normalize_matrix(A)
    normA =  A - min(A(:));
    normA = normA ./ max(normA(:));
end