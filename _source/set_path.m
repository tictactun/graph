% clcMyPath = pwd;
% MyDir = MyPath(1:strfind(MyPath,';')-1);
MyWorkDir = genpath(pwd);
addpath(MyWorkDir, '-end');