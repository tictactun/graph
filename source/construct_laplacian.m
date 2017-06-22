% construct the laplacian matrix from an adjacency matrix
function [sortedEVectors, sortedEValues] = construct_laplacian(A)
    % Diagonal matrix
    digValues = diag(sum(A, 1)); % sum of weights
    D = full(digValues);
    % Laplacian matrix
    L = D - A;
    L = full(L);
    
    % normalized 
%     L = D^(-0.5) * L * D^(-0.5);
    
    % Eigenvalues & eigenvectors
    [eVectorsMatrix, eValuesMatrix] = eig(L);
    % sort eigen values and vectors
    eValues = diag(eValuesMatrix);
    [sortedEValues, idx] = sort(eValues, 'ascend');
    sortedEVectors = eVectorsMatrix(:, idx);
end