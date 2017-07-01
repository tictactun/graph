% SR algorithm
function [wSet, Pw] = select_and_recover(lGraph, config)
    % the initial leverage ~ importance values
    [I, p] = init_leverage(lGraph, config);
    % selected vertices set
    wSet = lGraph.preWSet;
    % TUNING: better gloabal error with less samples ???
    maxIter = ceil(lGraph.rMaxSamples * lGraph.nVertices) - length(wSet);
    for j=1:maxIter
        % Select step: delta(v|pi) = I(v) (definition)
        [~, maxId] = max(I);
        [minIValue, ~] = min(I(I > 0));

        wSet(end + 1) = maxId; 
        deltaI = get_recovery_error(wSet, p(wSet), minIValue, maxId, ...
                        lGraph, config);
        I = I - deltaI;
        I(wSet) = 0;
    end
    wSet = unique(wSet);
    Pw = p(wSet);
end

% conditional importance => need to invest more 
function [I, p] = init_leverage(lGraph, config)
%     I = lGraph.Vk.^2 * kernel(lGraph.Dk);
    [p, z]= get_prob_dist(lGraph, config);
    I = p .* z;
    if ~isempty(lGraph.preWSet)
        I(lGraph.preWSet) = 0;
        maxId = lGraph.preWSet;
        [minIValue, ~] = min(I(I > 0)); % i should be 
        deltaI = get_recovery_error(lGraph.preWSet, p(lGraph.preWSet), ...
                    minIValue, maxId, lGraph, config); 
        I = I - deltaI;
        I(I < 0) = 0;
    end
end

% get recovery error after each iteration
function deltaI = get_recovery_error(wSet, Pw, minIValue, ...
                                            maxId, lGraph, config) 
    y = lGraph.data(wSet, :);
    M = get_projection_matrix(lGraph.nVertices, wSet);
%     Pw = ones(length(wSet), 1) / graph.nVertices;
    
    % recover
    fHat = recover_from_samples(y, M, Pw, lGraph, config);
    f = lGraph.Vk * fHat;
    
    % get recovery error and update scale
    error = norm(y - f(wSet), 2);
    s = config('alpha') * error;
%     acc = 1 - error / (norm(f(wSet), 2) + 0.001);
%     if acc < 0.01
%         acc = 0.01;
%     elseif acc > 1.5
%         acc = 1.5;
%     end    
%     s = acc / 0.05; % change kernel
    
    % calculate closeness
    deltaDirac = zeros(lGraph.nVertices, 1);
    deltaDirac(maxId) = 1;
    kernel = config('kernel');
    Cs = lGraph.Vk *(kernel(s * lGraph.Dk).*(lGraph.Vk' * deltaDirac));
    
    % closeness parameter
    [maxCs, ~] = max(Cs);
    eta = minIValue / maxCs; % ensure I(j +1) (id) = 0
    
    % reduction amount
    deltaI = eta * Cs;
end