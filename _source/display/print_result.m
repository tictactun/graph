function print_result(err) 
    fprintf('         \tUnobserved \tObserved\n');     
    fprintf('Recover  :\t%.2f%%  \t %.2f%% \n', err(1), err(2));
    fprintf('Precision:\t%.2f%%  \t %.2f%% \n', err(3), err(4));
    fprintf('Norm2    :\t%.4f  \t %.4f \n', err(5), err(6));
    fprintf('\n');
end