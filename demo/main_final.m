clc;clear;close all;
rng(10);

%% load a mesh
load dog8.mat

vtx(:,1) = surface.X;
vtx(:,2) = surface.Y;
vtx(:,3) = surface.Z;
surf.vertices = vtx;
surf.faces = surface.TRIV; % ?
surf = reducepatch(surf, 0.3); % ?

N = length(surf.vertices); % number of vertices
%% parameters
m = 200;
k = ceil(.5*N);
% k = 300;
k_prob = ceil(.8*N);
gamma = 1;
lambda = .0001;

fprintf('Sample size: %d\n', m);
fprintf('number of estimations: %d\n', N-m);
%% construct graph 
A = triangulation2adjacency(surf.faces, surf.vertices);

D = diag(sum(A,1));
D = full(D);

L = D - A;
L = full(L);

%L = D^(-1/2) * L * D^(-1/2);
[V, D] = eig(full(L)); % full SVD?? 

D = diag(D);
[D idx] = sort(D, 'ascend');
V = V(:,idx);

%% define f
band = ceil(0.8*m); % meaning of band?
%band = 80;
f = normrnd(0,1,band,1); % size: band x 1
f(abs(f)<1) = 0;    % make it sparse
% Purpose of this: reconstruct f from a part of k vertices & k vectors?
f = V(:,1:band)*f;  % size = (N x band) x (band x 1) = N x 1
f = f/norm(f); 

f_hat = V'*f;

%% setup the probability
k = k_prob;    % number of eigenvectors
Vk = V(:,1:k);
Dk = D(1:k); % what is Dk: diagonal?

t = .05;

% Kernel 
h{1} = @(x)exp(-t*x);
%h{1} = @(x) x;

opt.g = h;
opt.mode = 2;
[p, Z]= sample_prob(Vk, Dk, opt);
I = p.*Z;

%figure;draw_surf(surf, p);
%% Selection based on the probability

% opt.mode = 1;    % opt = 1: random sampling with replacement, 2: select m nodes with higher prob. 
% [w, M, P] = random_sampling(p, m, opt);

Vk = V(:,1:k);
Dk = D(1:k);

l=1;
t=1;

while(1)    
%for l=1:5
    % select the largest leverage value
    [val id] = max(I);    
    w(l) = id;
    
    M = sampling_matrix(w, N); % projection operation
    y = f(w,:); % observation

    if l==1
        % matlab lasso does not solve 1-dim case so use least-square...
        g_hat = recover_from_samples(p(w), y, gamma, M, Vk, Dk);     
    else        
%         opts=[];
%         [g_hat, funVal]=mcLeastR(M*Vk, y, lambda, opts);        
%         [g_hat, stats] = lasso(M*Vk,y, 'Lambda', lambda);    
         g_hat = recover_from_samples(p(w), y, gamma, M, Vk, Dk);     
    end
    
    % signal recovery
    g = Vk*g_hat;        
    
    % update
    err = norm(f(w) - g(w),2);
    acc = 1-err/norm(f(w),2);
    
%     Why?
    if acc < 0.01
        acc = 0.01;
    elseif acc > 1.5
        acc=1.5;
    end    
    s = acc;
    
    fprintf('%d. Sampling %dth vertex... Accuracy : %f --- max(I) = %f\n', l, id, acc, max(I));
    
    delta = zeros(N,1);    
    delta(id) = 1;    
    
%    update s is not really same as the paper?
    Ds = Vk*(exp(-acc*Dk).*(Vk'*delta));      % right, t = 1 for kernel
    % distance to new vertex: closer is it, less important is it
    % max(Ds) should be equal to Ds(id) => I(j+1) (id) = 0 (satisfied)
    Ds = I(id)*Ds/max(Ds);
    I = I - Ds;
    I(I<0) = 0;
    
    if length(unique(w)) == m
        break;
    end    
    (unique(w)) == m
    
    l = l+1;
end

w = unique(w)'; % should check this during the process ???
M = sampling_matrix(w,N);

%% final estimation
y = f(w,:);
kk = k;
Uk = V(:,(1:kk));
Dk = D((1:kk));

gamma = .01;
g_hat = recover_from_samples(p(w), y, gamma, M, Uk, Dk);     
% g = Uk*g_hat;

% opts=[];
% [g_hat, funVal]=mcLeastR(M*Uk, y, lambda, opts);

%[B,STATS] = lasso(M*Uk,y, 'Lambda', lambda);
%g_hat = B;
g = Uk*g_hat;    

%% baseline
opt.mode = 2;
p_orig = sample_prob(Uk, Dk, opt);
opt.mode = 3;    % opt = 1: random sampling with replacement, 2: select m nodes with higher prob. 
[w_orig, M_orig, P] = random_sampling(p_orig, m, opt);
% opt.t = t;
% [w_orig, M_orig] = adaptive_sampling(p, m, Dk, Vk, opt);
g = Uk*g_hat;
y = f(w_orig,:);
g2_hat = recover_from_samples(p(w_orig), y, gamma, M_orig, Uk, Dk);     
g2 = Uk*g2_hat;

%% result
close all

figure(1);hold on;
scatter(D(1:end), f_hat(1:end), 'b', 'Linewidth', 1);
scatter(Dk(1:end), g_hat(1:end), 'r*');
scatter(Dk(1:end), g2_hat(1:end), 'g*');
legend('Signal in Frequency','Estimation','Old','Location','southeast');
tit = strcat(num2str(m), ' Subjects Sampled out of ', num2str(N));
title(tit);
axis([0 max(Dk) -1 1]);
hold off

figure(2);
draw_surf(surf, f);camlight;colormap jet;title('Ground Truth')
scale = caxis;

figure(3);subplot(1,2,1);
draw_surf(surf, g);camlight;colormap jet;title('Our Estimation');caxis([scale]);
subplot(1,2,2);
draw_surf(surf, f);camlight;colormap jet;hold on;
scatter3(surf.vertices(w,1),surf.vertices(w,2),surf.vertices(w,3), 100, f(w), 'filled')
title('Our Sampling')
hold off

%% Error
not_w = setdiff(1:N, w);

err = norm(f-g,2);
err_w = norm(f(w)-g(w),2);scale
err_notw = norm(f(not_w) - g(not_w),2);

err2 = norm(f-g2,2);
err2_w = norm(f(w)-g2(w),2);
err2_notw = norm(f(not_w) - g2(not_w),2);

fprintf('L2 norm error on all vertices - new: %f\n', err);
fprintf('L2 norm error on sampled vertices - new: %f\n', err_w);
fprintf('L2 norm on unsampled vertices - new: %f\n', err_notw);
fprintf('\n');

fprintf('L2 norm error on all vertices: %f\n', err2);
fprintf('L2 norm error on sampled vertices: %f\n', err2_w);
fprintf('L2 norm on unsampled vertices: %f\n', err2_notw);
fprintf('\n');
