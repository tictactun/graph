function [inputParams, config] = init()
    % Map
    inputParams = containers.Map;
    config = containers.Map;
    
    % Input setting
    inputParams('filename') = '../dataset/data_roi1.csv'; % datafile
    inputParams('rtrain')   = 1; % train proportion
    
    inputParams('rAvaiSamples') = 0.4; % percentage of available samples
    inputParams('rMaxSamples')  = 0.6; % maximum (including available ones)
    
    inputParams('xleft')    = 1;
    inputParams('xright')   = 154;
    
    inputParams('yOffset')  = 2; % from 1 to 5, index of the CSF feature
    
    % Experiment setting  
    config('alg')       = 2;    % 1 is for random sampling, 2 is for S&R
    config('epsilon')   = 0.1;  % acceptable tolerance 
    threshold = [630, 629.39, 568.08, 48.86, 0.77, 0.07];
    config('threshold') = threshold(inputParams('yOffset'));
    config('errorMode') = 1; % precision
    config('baselineMode') = 2;
    
    % Graph construction
    config('nSelected')     = 10;   % #features selected
    config('preSigma')      = .1;  % sigma of gaussian kernel
    config('simKernel')     = 3;
    
    config('sim')           = 0;
    config('binary')        = 1;

    config('kNeighbors')    = 0;    % for kNN
    
    config('learningMode')  = 0;    % 4 works with Atrue-dataset
    config('ensembleMode')  = false;% ensemble graph
    config('matrixMode')    = 1;
    config('trainMode')     = 1;
    
    % Parameters setting
    config('rBand')         = .8; % k-band limited percentage  
    config('kernel')        = @(x) exp(-0.5 * x); % scaling function
    config('kernelMode')    = 1;
    config('samplingMode')  = 2;
    
    config('alpha') = 0.1;  % vertex selection update param
    config('gamma') = 10;  % regularization param
end