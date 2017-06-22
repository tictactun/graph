function print_result(acc, rmse, err) 
    fprintf('         \tUnsampled \t Sampled\n');     
    fprintf('Mean err:\t %.2f%% \t %.2f%%\n', err.test, err.train);
    fprintf('Recover :\t %.2f%% \t %.2f%% \n', acc.test, acc.train);
    fprintf('RMSE    :\t %.4f \t %.4f\n', rmse.test, rmse.train);
    fprintf('\n');
end