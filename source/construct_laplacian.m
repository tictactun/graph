% construct the laplacian matrix from an adjacency matrix
function [sortedV, sortedD] = construct_laplacian(A)
    % Diagonal matrix
    digValues = diag(sum(A, 1)); % sum of weights
    diagMatrix = full(digValues);
    % Laplacian matrix
    L = diagMatrix - A;
    L = full(L);
    
    % normalized 
%     L = diagMatrix^(-0.5) * L * diagMatrix^(-0.5);
    
    % Eigenvalues & eigenvectors
    [V, D] = eig(L);
    
    % sort eigen values and vectors
    eValues = diag(D);
    [sortedD, idx] = sort(eValues, 'descend');
    sortedV = V(:, idx);
end