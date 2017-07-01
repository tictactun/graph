function [p, z]= get_prob_dist(lGraph, config)

    [n, k] = size(lGraph.Vk);
    p = zeros(n, 1);

    if 1 == config('samplingMode')
        % Puy random sampling
        for i = 1:n
            delta = zeros(n, 1);
            delta(i) = 1;
            p(i) = norm(lGraph.Vk' * delta, 2)^2;
        end
        z = k;
    else
        % wavelet
        for i=1:n   
            kernel = config('kernel');
            p(i) = kernel(lGraph.Dk)' .* lGraph.Vk(i,:) ...
                                                * lGraph.Vk(i,:)';            
             % scale = 1?
        end
        z = sum(p);
    end
    p = p / z;
end