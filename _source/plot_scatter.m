function plot_scatter(data, reData, wSet)
 % Visualize Result
    close all;
    samples = 1:size(data, 1);

    figure(); hold on;
    title('Recovery on 1 feature');
    plot(samples, data, samples, reData);   
    scatter(wSet, reData(wSet), 'filled', 'r');
    legend('Ground truth', 'Recovered Signal', 'Sampled', ...
            'Location', 'northeast');
    legend('boxoff');
    xlabel('Vertex');
    ylabel('Value');
end
