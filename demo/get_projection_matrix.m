function P = get_projection_matrix(n, inds)
    m = length(inds);
    P = zeros(m, n);
    for i=1:m
       P(i, inds(i)) = 1;
    end
end 
