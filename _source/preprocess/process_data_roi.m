function data = process_data_roi()
    load ../dataset/usubj_ids.mat
    load ../dataset/models_subjID_mmem2.mat models
    
    m = 100;
    cols = [31:42, 81:90];
    n = length(cols);
    data = zeros(m + 1, 7 * n + 1);
    
    data(1, 1) = 1;
    data(2:end, 1) = usubj_ids;
    
    nUis = 6;
    for i = 1:n
        
        start = (nUis + 1) * (i - 1) + 2;
        % alpha
        data(1, start) = start;
        data(2:end, start) = models{cols(i)}.alppha;
        
        % ui
        ui = zeros(m, nUis);
        a = models{cols(i)}.Ui;
        for k = 1:m
            U = triu(a(:, :, k)); 
            v = U(:);
            ui(k, :) = v(v ~= 0);
        end
        s = start + 1;
        e = start + nUis;
        data(1, s:e) = s:e;
        data(2:end, s:e) = ui;
    end
    csvwrite('../dataset/roi.csv', data);
end