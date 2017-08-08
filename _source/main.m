%{
    Project: Graph completion
    File: main
    Author: Tuan Dinh
    Developed from the orignial verison of WonHwa Kim
    Description: graph completion 
%}

%{
    @param
        runMode int 1: single shot
                    2: validation
        alg     int 1: graph completion
                    2: baseline
        default value is (0, 1)
    @return 
%}
function main(runMode, alg)
    warning off;
    if nargin < 2
        runMode = 1;
        alg = 1;
    end
    
    [inputPars, configs] = init();    
    % Load csv file into 2 parts: construction and completion
    [dataX, dataY] = process_data(inputPars);       
    
    if 1 == runMode
        metrics = test(dataX, dataY, inputPars, configs, alg);
        err = metrics(1);
    else
        nIters = 1000; % number of iters
        avgMetrics = cross_validation(nIters, dataX, dataY, ...
            inputPars, configs, alg);
        err = avgMetrics.m;
    end
    
    % Display
    fprintf('\t------Evaluation------\n');           
    print_result(err);  
end