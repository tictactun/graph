function [input, config] = setup()
    % Input setting
    input.filename = '../dataset/data_full.csv'; % input file name
    input.dataSize = 145; % the number of full featured samples
    input.rtrain = 1; % percentage of data used for training
    
    input.rAvaiSamples = 0.5; % percentage of samples that are available
    input.rMaxSamples = 0.9; % maximum percentage of samples that ...
                             %    we can request (including available ones)
    
    input.nRedundantFeatures = 0; % not important, for my testing
    input.nXfeatures = 27; % number of cognitive features 
    input.yFeatureIdx = 1; % from 1 to 5, index of the CSF feature, ...
                                    %I test one feature at one time only
        
    % Experiment setting  
    config.accuracy = 0.85; % expected accuracy - not important
    config.epsilon = 0.15; % acceptable tolerance
    
    config.alg = 1; % 1 is for random sampling, 2 is for S&R
    config.nSelectedFeatures = 15; % number of selected features 
                                        %sorted by correlation score
    config.learningMode = 0; % for learning distance 
    
    config.preSigma = 0.01; % sigma of gaussian kernel
    config.kNeighbors = 12; % for kNN
    
    % Parameters setting
    config.rBand = 1; % k-band limited percentage  
    config.kernel = @(x) exp(-0.5 * x); % scaling function
    config.kernelMode = 1;
    config.samplingMode = 2;
    
    config.alpha = 0.1; % vertex selection update param
    config.gamma = 10; % regularization param
end