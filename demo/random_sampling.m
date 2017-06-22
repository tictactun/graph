function [w, M, P] = random_sampling(p, m, opt)

P = diag(p);

if nargin < 3
    opt.mode = 1;
end

N = length(p);
mode = opt.mode;

if mode == 1
    w = randsample(N,m,true,p);
elseif mode == 2
    [val w] = sort(p, 1, 'descend');
    w = w(1:m);
elseif mode == 3
    w = datasample(1:N, m, 'Replace', false, 'Weights', p); % without replacement
end

% sampling matrix
M = zeros(m,N);
for i=1:m
    for j=1:N
        if j == w(i)
            M(i,j) = 1;
        end
    end
end
