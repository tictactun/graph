% SR algorithm
function wSet = select_and_recover_t(graph, config)
    % the initial leverage ~ importance values
    I = init_leverage(graph, config);
    % selected vertices set
    wSet = graph.preWSet;
    % TUNING: better gloabal error with less samples ???
    maxIter = ceil(config.maxSamples * graph.nVertices);
    for j = 1:maxIter
        % Select step: delta(v|pi) = I(v) (definition)
        I(wSet) = 0; % should be -inf, how about all negative I ?
        [maxIValue, maxId] = max(I);
        % we can check here, set all observed vertices 0
        wSet(end + 1) = maxId; 
        deltaI = get_recovery_error(wSet, maxIValue, maxId, graph, config); 
        I = I - deltaI;
    end
    wSet = unique(wSet);
end

% conditional importance => need to invest more 
function I = init_leverage(graph, config)
%     I = graph.Vk.^2 * config.kernel(graph.Dk);
    [p, z]= get_prob_dist(graph, config);
    I = p .* z;          
    totalDeltaI = zeros(graph.nVertices, 1);
    for i = 1:length(graph.preWSet)
        % for each indepdent vertex
        idx = graph.preWSet(i);
        w = idx;
        maxIValue = I(idx);
        maxId = idx;
        % Recover step
        deltaI = get_recovery_error(w, maxIValue, maxId, graph, config); 
        totalDeltaI = totalDeltaI + deltaI;
    end
    I = I - totalDeltaI;
end

% get recovery error after each iteration
function deltaI = get_recovery_error(wSet, maxIValue, maxId, graph, config) 
    y = graph.data(wSet, :);
    M = get_projection_matrix(graph.nVertices, wSet);
    Pw = ones(length(wSet), 1) / graph.nVertices;
    
    % we dont need probability here? or do we?
    % recover
    fHat = recover_from_samples(y, M, Pw, graph, config);
    f = graph.Vk * fHat;
    
    % get recovery error and update scale
    error = norm(y - f(wSet), 2);
    s = config.alpha * error;

    % calculate closeness
    deltaDirac = zeros(graph.nVertices, 1);
    deltaDirac(maxId) = 1;
    Cs = graph.Vk *(config.kernel(s * graph.Dk).*(graph.Vk' * deltaDirac));
    
    % closeness parameter
    eta = maxIValue / max(Cs); % ensure I(j +1) (id) = 0
    
    % reduction amount
    deltaI = eta * Cs;
end