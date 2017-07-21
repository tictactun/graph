function [A, threshold] = prune(nVertices, s, p, bin)
    threshold = prctile(s(:), p);
    for i = 1:nVertices
        for j = i:nVertices
            if s(i, j) <= threshold
                s(i, j) = 0;
            elseif bin == true
                s(i, j) = 1;
            end
            s(j, i) = s(i, j);
        end
    end
    A = s;
end