function view_graphs
clc,close all
curr_dir = pwd;
graph_dir = strcat(curr_dir, '/samp_graphs/');
files = dir(graph_dir);

n = 49; %size of one adjacency matrix

tot_ele = n*13 %since 157 total graphs
all_A = zeros(tot_ele, tot_ele);
corr_files = 0;
good_files = 0;

for i = 3:length(files)
    try
        load_file_name = sprintf(strcat(graph_dir,sprintf(files(i).name)));
        load(load_file_name);
        good_files = good_files + 1;
        count = i- 2;
        [icount, jcount] = ind2sub([13 13],count);
        start_i = (icount-1)*n + 1;
        start_j = (jcount-1)*n + 1;
        fprintf(' %d , %d\n', start_i, start_j);        
        all_A(start_i :start_i + n-1, start_j : start_j+ n-1) = normA;
%         figure; imagesc(normA);
        if count == 130
            figure; imagesc(normA);
            figure; imagesc(all_A(start_i :start_i + n-1, start_j : start_j+ n-1));
        end
    catch
        corr_files = corr_files + 1;        
    end
end
fprintf('#count: %d\n', count);
fprintf('#corrupted files: %d\n', corr_files);
fprintf('#good files: %d\n', good_files);
figure; imagesc(all_A);
figure; imshow(all_A);
end