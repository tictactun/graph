function [inputParams, config] = setup()
    % Map
    inputParams = containers.Map;
    config = containers.Map;
    
    % Input setting
    inputParams('filename') = '../dataset/data702.csv'; % datafile
    inputParams('rtrain')   = 1; % train proportion
    inputParams('xleft')    = 1;
    inputParams('xright')   = 65;
    inputParams('yOffset')  = 2; % from 1 to 5, index of the CSF feature
    inputParams('rAvaiSamples') = 0.4; % percentage of available samples
    inputParams('rMaxSamples')  = 0.6; % maximum (including available ones)
    
    % Experiment setting  
    config('alg')       = 10;    % 1 is for random sampling, 2 is for S&R
    config('epsilon')   = 0.15;  % acceptable tolerance 
    threshold = [630, 629.39, 568.08, 48.86, 0.77, 0.07];
    config('threshold') = threshold(inputParams('yOffset'));
    
    % graph construction
    config('nSelected')     = 10;   % #features selected
    config('preSigma')      = 0.1;  % sigma of gaussian kernel
    config('sim')           = 90;
    config('binary')        = true;
    config('simKernel')     = 3;
    config('kNeighbors')    = 0;   % for kNN
    config('learningMode')  = 3;    % for learning distance 
    
    % Parameters setting
    config('rBand')         = 1; % k-band limited percentage  
    config('kernel')        = @(x) exp(-0.5 * x); % scaling function
    config('kernelMode')    = 1;
    config('samplingMode')  = 2;
    
    config('alpha') = 0.1;  % vertex selection update param
    config('gamma') = 1;  % regularization param
end