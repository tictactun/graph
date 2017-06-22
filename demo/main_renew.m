clc;
clear;
close all;

% Input: a dog mesh, a vector of values on M vertices
% Output: recovered signal - all values on N vertices
% Implement both 2 algorithms

% Initialize essential params and variables
meshFileName = 'dog8.mat';
nSamples = 200;

KERNEL_T = 1;
alpha = 0.01;
gamma = 0.01;
% Kernel
kernel{1} = @(x) exp(-KERNEL_T * x); 

% Load dataset
surf = load_mesh(meshFileName);
nVertices = length(surf.vertices); % #vertices
nBands = ceil(0.5 * nVertices);

% Calculate Laplacian graph
[sortedEValues, sortedEVectors] = construct_laplacian(surf);
Vk = sortedEVectors(:, 1:nBands);
Dk = sortedEValues(1:nBands);

% Define a sample function on vertices
verticeValues = get_vertices_sample(sortedEVectors, nBands);

% Select and Recover algorithm
[g, wSet] = select_and_recover(nVertices, nSamples, ...
                            verticeValues, Vk, Dk, kernel, alpha, gamma);

g2 = baseline(Vk, Dk, nSamples, verticeValues, gamma, kernel);

% Visualize Result
f = verticeValues;
fHat = sortedEVectors' * f; 
gHat = Vk' * g;
g2Hat = Vk' * g2;
visualize(surf, nSamples, sortedEValues, Dk, f, fHat, g, gHat, g2Hat,  ...
                                                                    wSet);

% Evaluation
evaluate(verticeValues, g, wSet);
evaluate(verticeValues, g2, wSet);

%% Function

% load mesh file
function surf = load_mesh(filename)
    load(filename);
    
    vtx(:, 1) = surface.X;
    vtx(:, 2) = surface.Y;
    vtx(:, 3) = surface.Z;
    
    surf.vertices = vtx;
    surf.faces = surface.TRIV;
    surf = reducepatch(surf, 0.3);
end

% construct the laplacian matrix from a surface
function [sortedEValues, sortedEVectors] = construct_laplacian(surf)
    % Adjacency matrix
    A = triangulation2adjacency(surf.faces, surf.vertices);
    % Diagonal matrix
    digValues = diag(sum(A, 1)); % sum of weights
    D = full(digValues);
    % Laplacian matrix
    L = D - A;
    L = full(L);
    % Eigenvalues & eigenvectors
    [eVectorsMatrix, eValuesMatrix] = eig(L);
    % sort eigen values and vectors
    eValues = diag(eValuesMatrix);
    [sortedEValues, idx] = sort(eValues, 'ascend');
    sortedEVectors = eVectorsMatrix(:, idx);
end

% function define on vertices
function f = get_vertices_sample(V, nBands)
    % sampling: recover from the band-limited data (consistency)
    fHatLimited = normrnd(0, 1, nBands, 1);
    fHatLimited(abs(fHatLimited) < 1) = 0;
    
    % For all vertices
    fHat = V(:, 1:nBands) * fHatLimited;
    fHat = fHat/norm(fHat);
    
    % For the image space
    f = V' * fHat; 
end

% SR algorithm
function [g, wSet] = select_and_recover(nVertices, nSamples, ...
                   verticesValues, eVectors, eValues, kernel, alpha, gamma)
    opt.g = kernel;
    opt.mode = 2;
    [p, Z]= sample_prob(eVectors, eValues, opt);
    I = p.*Z;
    % For the second paper
%     I = eVectors.^2 * kernel(eValues);
    wSet = [];
    g = zeros(nVertices, 1);
    
    while length(wSet) < nSamples
        % Select step: delta(v|pi) = I(v) (definition)
        [maxIValue, maxId] = max(I);
        wSet(end + 1) = maxId; % we can check here
        
        % Recover step
        M = sampling_matrix(wSet, nVertices);
        y = verticesValues(wSet, :);
        gHat = recover_from_samples(p(wSet), y, gamma, M, ...
                                            eVectors, eValues);
        g = eVectors * gHat;
        
        % Update importance => duplicate if 1 vertex appears twice
        error = norm(y - g(wSet), 2);
        acc = 1 - error/norm(y, 2);
        if acc < 0.01
            acc = 0.01;
        elseif acc > 1.5
            acc = 0.5;
        end
        s = acc;
        
        delta = zeros(nVertices, 1);
        delta(maxId) = 1;
        Ds = eVectors * (exp(-s * eValues) .* (eVectors' * delta));
        
        beta = maxIValue / max(Ds); % ensure I(j +1) (id) = 0
        I = I - beta * Ds;
    end
    wSet = unique(wSet);
end

% Baseline methods
function g2 = baseline(Uk, Dk, nSamples, verticeValues, gamma,kernel)
    opt.g = kernel;
    opt.mode = 2;
    p_orig = sample_prob(Uk, Dk, opt);
    opt.mode = 3;   
    % opt = 1: random sampling with replacement, 
    % 2: select m nodes with higher prob. 
    [w_orig, M_orig, P] = random_sampling(p_orig, nSamples, opt);
    % opt.t = t;
    % [w_orig, M_orig] = adaptive_sampling(p, m, Dk, Vk, opt);
    y = verticeValues(w_orig,:);
    g2_hat = recover_from_samples(p_orig(w_orig), y, gamma, M_orig, Uk, Dk);     
    g2 = Uk * g2_hat; 
end

% Norm 2 error
function [err, err_w, err_notw] = evaluate(trueVals, predVals, wSet)

    nVertices = length(trueVals);
    not_w = setdiff(1:nVertices, wSet);

    err = norm(trueVals - predVals, 2);
    err_w = norm(trueVals(wSet) - predVals(wSet), 2);
    err_notw = norm(trueVals(not_w) - predVals(not_w), 2);
    
    fprintf('L2 norm error on all vertices - new: %f\n', err);
    fprintf('L2 norm error on sampled vertices - new: %f\n', err_w);
    fprintf('L2 norm on unsampled vertices - new: %f\n', err_notw);
    fprintf('\n');
end

% Visualize 
function visualize(surf, nSamples, D, Dk, f, fHat, g, gHat, g2Hat, wSet)
    nVertices = length(surf.vertices);
    close all

    figure(1);
    hold on;
    scatter(D(1:end), fHat(1:end), 'b', 'Linewidth', 1);
    scatter(Dk(1:end), gHat(1:end), 'r*');
    scatter(Dk(1:end), g2Hat(1:end), 'g*');
    legend('Signal in Frequency', 'Estimation', 'Old', ... 
                    'Location', 'southeast');
    tit = strcat(num2str(nSamples), ' Subjects Sampled out of ', ... 
                                            num2str(nVertices));
    title(tit);
    axis([0 max(Dk) -1 1]);
    hold off

    figure(2);
    draw_surf(surf, f); camlight; colormap jet; title('Ground Truth');
    scale = caxis;

    figure(3); 
    
    subplot(1,2,1);
    draw_surf(surf, g); camlight; colormap jet; title('Our Estimation'); 
    caxis([scale]);
    
    subplot(1,2,2);
    draw_surf(surf, f); camlight; colormap jet; hold on;
    scatter3(surf.vertices(wSet, 1), surf.vertices(wSet, 2), ...
                    surf.vertices(wSet, 3), 100, f(wSet), 'filled');
    title('Our Sampling');
    hold off
end
