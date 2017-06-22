function [p Z]= sample_prob(V, D, opt)

if nargin < 2
    opt.mode = 1;
end

k = size(V,2);
N = size(V,1);
p = zeros(N,1);

if opt.mode == 1
    for i=1:N
        delta = zeros(N,1);
        delta(i) = 1;
        p(i) = norm(V' * delta,2)^2;
    end
    p = p/k;
    Z = k;
else
    g = opt.g;
    %J = length(g);
   
    %dim = 1:k;
    %for s = 1:J
    tmp = zeros(N,1);
    for i=1:N   
        %tmp(i) = g{s}(D(dim))'.*V(i,dim)*V(i,dim)';
        tmp(i) = g{1}(D)'.*V(i,:)*V(i,:)';            
    end
    %map{s} = tmp/sum(tmp);    % sampling probability
    %end
    Z = sum(tmp);
    p = tmp/Z;

%     tmp = cell2mat(map);    
%     tmp = tmp(:,1:J);
%     tmp = max(tmp,[],2);
%     Z = sum(tmp);
%    p = tmp./Z;       
    
end