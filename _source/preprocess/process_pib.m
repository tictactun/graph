function process_pib()
    load ../dataset/FA_PIB_IDS.mat PIB IDS
    load ../dataset/WRAP_DTI_CSF_170215.mat data
    
    [~, ia, ib] = intersect(data.enum, IDS);
    X = data.CSF(ia, :);
    Y = PIB(ib, :);
    
    processedData = zeros(size(X, 1), size(X, 2) + 1);
    processedData(:, 1:size(X, 2)) = X;
    for i=1:size(X, 1)
        processedData(i, end) = mean(Y(i, :));
    end
    % 2 Nans => median, 1 colums Nan
    csvwrite('../dataset/data_pib.csv', processedData);
end