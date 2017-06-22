function [input, config] = setup()
    % Input setting
    input.filename = '../dataset/data2.csv';
    input.dataSize = 145;
    input.rtrain = 1;
    
    input.rAvaiSamples = 0.8;
    input.rMaxSamples = 0.6;
    
    input.nRedundantFeatures = 0;
    input.nXfeatures = 27; % age is not csf
    input.yFeatureIdx = 1;
        
    % Experiment setting  
    config.accuracy = 0.85;
    config.epsilon = 0.15;
    
    config.alg = 2; % Selection
    config.nSelectedFeatures = 15;
    config.learningMode = 0;
    
    config.preSigma = 0.7;
    config.kNeighbors = 12;
    
    % Parameters setting
    config.rBand = 1; % k-band limited  
    config.kernel = @(x) exp(-0.5 * x); % scaling function
    config.kernelMode = 1;
    config.samplingMode = 2;
    
    config.alpha = 0.1; % vertex selection update param
    config.gamma = 0.1; % regularization param
end