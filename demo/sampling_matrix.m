function M = sampling_matrix(w, N)

M = zeros(length(w),N);
for i=1:length(w)
    for j=1:N
        if j == w(i)
            M(i,j) = 1;
        end
    end
end
