function [prediction,accuracy] = my_kernel_knn(Xr, Yr, Xt, Yt)

[minIDX,D] = knnsearch(Xr,Xt);
%[~, minIDX] = min(dist);
prediction = Yr(minIDX);
accuracy = sum( prediction==Yt ) / length(Yt);