function visualize(mode, data, reData, wSet)
 % Visualize Result
    close all;
    samples = 1:size(data, 1);
    switch mode
        case 0
            figure(1); hold on;
            title('Recovery on 1 feature');
            plot(samples, data, samples, reData);   
            scatter(wSet, reData(wSet), 'filled', 'r');
            legend('Ground truth', 'Recovered Signal', 'Sampled', ...
                    'Location', 'northeast');
            legend('boxoff');
            xlabel('Vertex');
            ylabel('Value');
            %         ax2 = subplot(2,1,2);
            %         figure(2); hold on;
            %         plot(1:graph.nVertices, eDist);   
            %         xlabel('Vertex');
            %         ylabel('Error percentage');

            %         hold off;

        case 1
            figure(1); hold on
            title('Accuracy learning curve');
            plot(maximumSamples, avgAccTrain, maximumSamples, avgAccTest);   
            legend('Sampled', 'Unsampled', 'Location', 'northeast');
            legend('boxoff');
            xlabel('maximum samples');
            ylabel('Average error in %');

            figure(2); hold on
            title('RMSE learning curve');
            plot(maximumSamples, avgRmseTrain, maximumSamples, avgRmseTest);   
            legend('Sampled', 'Unsampled', 'Location', 'northeast');
            legend('boxoff');
            xlabel('maximum samples');
            ylabel('RMSE'); 
            
        case 2
            figure(3); 
            title('Avg Error in % distribution');
            bar(1:graph.nVertices, eDistLst);
            xlabel('Vertex');
            ylabel('Average error in %');
            hold off;

    end
end
