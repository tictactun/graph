MyPath = '/Users/tuandinh/Dropbox/_Summer/Research/_project/hao;';
MyDir = MyPath(1:strfind(MyPath,';')-1);
MyWorkDir = genpath(MyDir);
addpath(MyWorkDir, '-end');