% SR algorithm
function [wSet, Pw] = select_and_recover(graph, config)
    % the initial leverage ~ importance values
    [I, p] = init_leverage(graph, config);
    % selected vertices set
    wSet = graph.preWSet;
    % TUNING: better gloabal error with less samples ???
    while length(unique(wSet)) < config.maxSamples
        % Select step: delta(v|pi) = I(v) (definition)
%         I(wSet) = 0; % should be -inf, how about all negative I ?
        [maxIValue, maxId] = max(I);
        % we can check here, set all observed vertices 0
        wSet(end + 1) = maxId; 
        deltaI = get_recovery_error(wSet, p(wSet), maxIValue, maxId, graph, config); 
        I = I - deltaI;
        I(I < 0) = 0;
    end
    wSet = unique(wSet);
    Pw = p(wSet);
end

% conditional importance => need to invest more 
function [I, p] = init_leverage(graph, config)
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
        deltaI = get_recovery_error(w, p(w), maxIValue, maxId, graph, config); 
        totalDeltaI = totalDeltaI + deltaI;
    end
    I = I - totalDeltaI;
    I(I < 0) = 0;
end

% get recovery error after each iteration
function deltaI = get_recovery_error(wSet, Pw, maxIValue, ...
                                            maxId, graph, config) 
    y = graph.data(wSet, :);
    M = get_projection_matrix(graph.nVertices, wSet);
%     Pw = ones(length(wSet), 1) / graph.nVertices;
    
    % we dont need probability here? or do we?
    % recover
    fHat = recover_from_samples(y, M, Pw, graph, config);
    f = graph.Vk * fHat;
    
    % get recovery error and update scale
    error = norm(y - f(wSet), 2);
%     s = config.alpha * error;
    acc = 1-error/norm(f(wSet),2);
    if acc < 0.01
        acc = 0.01;
    elseif acc > 1.5
        acc=1.5;
    end    
    s = acc / 0.05; % change kernel
    
    % calculate closeness
    deltaDirac = zeros(graph.nVertices, 1);
    deltaDirac(maxId) = 1;
    Cs = graph.Vk *(config.kernel(s * graph.Dk).*(graph.Vk' * deltaDirac));
    
    % closeness parameter
    eta = maxIValue / max(Cs); % ensure I(j +1) (id) = 0
    
    % reduction amount
    deltaI = eta * Cs;
end