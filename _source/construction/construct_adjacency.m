function AMatrix = construct_adjacency(data, avaiSampleSet, config, mdl)
    % params & variables
    nVertices = size(data, 1);
    % undirected graph => distance matrix (not adj matrix)
    % Similarity matrix
    matrixMode = config('matrixMode');
    s = zeros(nVertices, nVertices);
    % should ensure that s(i, j) = 0 because of adjacency matrix
    switch (matrixMode)
        case 1 % normal
            for i = 1:nVertices-1
                for j = i+1:nVertices
                    s(i, j) = get_similarity(data(i, :), data(j, :), ...
                        config('preSigma'), config, mdl);
                    s(j, i) = s(i, j);
                end
            end
        case 2 % random
            for i = 1:nVertices-1
                for j = i+1:nVertices
                    s(i, j) = rand(1);
                    s(j, i) = s(i, j);
                end
            end            
        case 3 % training
            load A.mat A
            Y = A(avaiSampleSet, avaiSampleSet);
            X = data(avaiSampleSet, :);
%             X = data;
%             Y = A;
            trainMode = config('trainMode');
            mdl = train_connection(X, Y, trainMode);
            
            % Differential matrix
            Xnew = [];
%             ynew = [];
            for i = 1:nVertices-1
                for j = i+1:nVertices
                    Xnew(end + 1, :) = abs(data(i, :) - data(j, :));
%                     ynew(end + 1, :) = A(i, j);
                end
            end
            if 1 == trainMode
                pred = zeros(size(Xnew, 1), 1);
                for i = 1:size(Xnew, 1)
                    pred(i, :) = logReg([1 Xnew(i, :)] * mdl);
                end
            elseif 4 == trainMode
                pred = predict(mdl, Xnew);
            else
                [~, scores, ~] = predict(mdl, Xnew);
                pred = scores(:, 2);
            end
           
            count = 0;
            for i = 1:nVertices- 1
                for j = i+1:nVertices
                    count = count + 1;      
                    s(i, j) = pred(count);
                    s(j, i) = s(i, j);
                end
            end
    end
    AMatrix = s;
   
    % sparsification: mutual kNN or b-matching or thresholding
    % similarity => not distance
    k = config('kNeighbors');
    if  k > 0
        [~, s, ~] =  get_kNN(k, s);
        % re-weighting: Gaussian or LLS
        % sig = dk/3; % ref from Tony
    end
    [AMatrix, ~] = prune(nVertices, s, config('sim'), config('binary'));
end