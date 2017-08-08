function [inputParams, config] = init()
    % Map
    inputParams = containers.Map;
    config = containers.Map;
    
    % Input setting
    inputParams('filename') = '../dataset/data_cogGen.csv'; % datafile
    inputParams('rtrain')   = 1; % training set fraction
    
    inputParams('rAvaiSamples') = 0.3; % percentage of available samples
    inputParams('rMaxSamples')  = 0.5; % maximum (including available ones)
    
    inputParams('nYFeatures')   = 5;
    inputParams('yOffset')  = 2; % from 1 to 5, index of the CSF feature
    
    % Experiment setting  
    config('alg')       = 2;    % 1 is for random sampling, 2 is for S&R
    config('epsilon')   = 0.1;  % acceptable tolerance 

    config('errorMode') = 1;    % 1, 2, 3 for precision, recall, accuracy
    config('errIdx')    = 1;    % 1 for rRMSE
    config('nMetrics')  = 7;    
    
    threshold = [630, 629.39, 568.08, 48.86, 0.77, 0.07]; % classification
    config('threshold') = threshold(inputParams('yOffset'));
    
    config('baselineMode') = 2; % 1 - 4 methods
    
    % Graph construction
    config('nSelected')     = 10;   % #features selected
    config('preSigma')      = 1;    % sigma of gaussian kernel
    config('simKernel')     = 3;    % similarity kernel
    
    config('sim')           = 80;% percentile threshold
    config('binary')        = 0; % 1 for binary, 0 for weighted connection

    config('kNeighbors')    = 0;    % for kNN
    
    config('learningMode')  = 0;    % 4 works with Atrue-dataset
    config('ensembleMode')  = false;% ensemble graph
    config('matrixMode')    = 1;
    config('trainMode')     = 1;
    
    % Completion
    config('rBand')         = .8; % k-band limited percentage  
    config('regMode')       = 2;  % regularization mode
    config('kernel')        = @(x) exp(-0.5 * x); % scaling function
    config('kernelMode')    = 1;
    config('samplingMode')  = 2;
    % Regularizer
    config('alpha') = 0.1;  % vertex selection update param
    config('gamma') = 10;  % regularization param
end