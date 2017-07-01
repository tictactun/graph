function print_result(err) 
    fprintf('        \tUnsampled Sampled\n');     
    fprintf('Error  :\t%.2f%% \t %.2f%% \n', err('meTest'), err('meTrain'));
    fprintf('Recover:\t%.2f%% \t %.2f%% \n', err('accTest'), err('accTrain'));
    fprintf('Norm2  :\t%.4f \t %.4f \n', err('rmseTest'), err('rmseTrain'));
    fprintf('\n');
end