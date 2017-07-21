% Input: a dog mesh, a vector of values on M vertices
% Output: recovered signal - all values on N vertices
% Implement both 2 algorithms

function [f, wSet] = recover_graph(lGraph, config)
    if 1 == config('alg')
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
    
    try 
        fHat = recover_from_samples(y, M, Pw, lGraph, config);
    catch e
        fHat = zeros(size(lGraph.Vk, 2), 1);
        fprintf(e);
    end
        
    f = lGraph.Vk * fHat;  
    
    % post-processing
    threshold = config('threshold');
    f(f > 2 * threshold) = threshold - 1; % as negative
    f(f < 0) = threshold - 1;
    
    %{
    dataHat = lGraph.Vk' * lGraph.data;    
    samples = 1:length(fHat);    
    
    close all;
    figure(); hold on;
    title('Fourier transform');
    plot(samples, dataHat, samples, fHat);   
    legend('Ground truth', 'Recovered Signal', 'Location', 'northeast');
    legend('boxoff');
    xlabel('Frequency');
    ylabel('Value');
    %}
end 







