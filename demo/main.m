%{
    Project: Graph completion
    File: main
    Author: Tuan Dinh
    Description: graph completion 
%}

% Data: (1199, 33), last 6 missing features, top 147 is full
% 1 header row, 1 id columns
function main(alg, f) 

    if nargin == 0
        alg = 2;
    end
    fprintf('Alg: %d\n', alg);

    % Parameters setting
    config.kernel = @(x) exp(-0.05 * x); % scaling function
    config.kernelMode = 1;
    config.samplingMode = 2;
    config.alpha = 0.01; % vertex selection update param
    config.gamma = 1; % regularization param
    config.nBand = 0.8; % k-band limited
    config.maxSamples = 200; % maximum number of samples able to acquire
    config.lambda = .0001;
     % acceptable error interval
    
    %% load a mesh
    load dog8.mat

    vtx(:,1) = surface.X;
    vtx(:,2) = surface.Y;
    vtx(:,3) = surface.Z;
    surf.vertices = vtx;
    surf.faces = surface.TRIV; % ?
    surf = reducepatch(surf, 0.3); % ?

    % Input setting
    N = length(surf.vertices); % number of vertices
    nAvaSamples = 0;    % #available samples
    %% construct graph 
    A = triangulation2adjacency(surf.faces, surf.vertices);

    D = diag(sum(A,1));
    D = full(D);

    L = D - A;
    L = full(L);

    [V, D] = eig(full(L)); % full SVD?? 

    D = diag(D);
    [D, idx] = sort(D, 'ascend');
    V = V(:, idx);

    graph.data = f; % function on vertices
    graph.nVertices = N;

    nBands = ceil(config.nBand * graph.nVertices);
    graph.Vk = V(:, 1:nBands);
    graph.Dk = D(1:nBands);    
    graph.preWSet = 1:nAvaSamples; % available samples

    % Recover
    [reData, wSet] = recover_graph(alg, graph, config);
    % g2 = get_baseline_result(Vk, Dk, nSamples, data, gamma, kernel);

    % Evaluation
    e = max(abs(graph.data(:))) * 0.05;
    [acc, rmse] = evaluate_recovery(wSet, graph.data, reData, e);
    % evaluate(data, g2, wSet);
    
    print_result(e, acc, rmse, graph.data);
    
    not_w = setdiff(1:N, wSet);
    err_w = norm(f(wSet) - reData(wSet),2); 
    err_notw = norm(f(not_w) - reData(not_w),2);
    
    fprintf('Sampled vertices  : %f\n', err_w);
    fprintf('Unsampled vertices: %f\n', err_notw);
    fprintf('\n');

    % Visualize Result
%     plot(1:datasetSize, graph.data, 1:datasetSize, reData)
%     close all
% 
%     f_hat = V' * f;
%     g_hat = graph.Vk' * reData;
%     
%     figure(1);hold on;
%     scatter(D(1:end), f_hat(1:end), 'b', 'Linewidth', 1);
%     scatter(graph.Dk(1:end), g_hat(1:end), 'r*');
%     
%     
%     tit = strcat(num2str(m), ' Subjects Sampled out of ', num2str(N));
%     title(tit);
%     axis([0 max(graph.Dk) -1 1]);
%     hold off
% 
%     figure(2);
%     draw_surf(surf, f);camlight;colormap jet;title('Ground Truth')
%     scale = caxis;
% 
%     figure(3);subplot(1,2,1);
%     draw_surf(surf, reData);camlight;colormap jet;title('Our Estimation');caxis([scale]);
%     subplot(1,2,2);
%     draw_surf(surf, f);camlight;colormap jet;hold on;
%     scatter3(surf.vertices(wSet,1), surf.vertices(wSet,2), ... 
%         surf.vertices(wSet,3), 100, f(wSet), 'filled')
%     title('Our Sampling')
%     hold off
end



function print_result(e, acc, rmse, trueData) 
    fprintf('Test - Train\n');     
    fprintf('Accurcy: %.2f %.2f %% \n', acc.test, acc.train);
    fprintf('RMSE   : %.5f %.5f - ', rmse.test, rmse.train);
    fprintf('in range: [%.1f %.1f]\n', min(trueData), max(trueData));
    fprintf('\n');
end