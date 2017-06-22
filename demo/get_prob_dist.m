function [p, z]= get_prob_dist(graph, config)

    [n, k] = size(graph.Vk);
    p = zeros(n, 1);

    if 1 == config.samplingMode
        % Puy random sampling
        for i = 1:n
            delta = zeros(n, 1);
            delta(i) = 1;
            p(i) = norm(graph.Vk' * delta, 2)^2;
        end
        z = k;
    else
        % wavelet
        for i=1:n   
             p(i) = config.kernel(graph.Dk)' .* graph.Vk(i,:) ...
                                                * graph.Vk(i,:)';            
             % scale = 1?
        end
        z = sum(p);
    end
    p = p / z;
end