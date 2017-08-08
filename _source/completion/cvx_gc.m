function f = cvx_gc(y, M, Pw, lGraph, config)
    k = size(lGraph.Dk, 1);
    lh = diag(lGraph.Dk);
    cvx_begin
        variables f(k)
        minimize(norm(f' * lh, Inf))
        subject to
            norm(diag(Pw) * (M * lGraph.Vk * f - y), 2) <= 0.001;
    cvx_end
end