function print_result(err) 
%     fprintf('         \tUnobserved \tObserved\n');     
%     fprintf('Error    :\t%.2f%%  \t %.2f%% \n', err(1), err(2));
%     fprintf('Precision:\t%.2f%%  \t %.2f%% \n', err(3), err(4));
%     fprintf('RMSE    :\t%.4f  \t %.4f \n', err(5), err(6));
    fprintf('RMSE    :\t%.4f', err);
    fprintf('\n');
end