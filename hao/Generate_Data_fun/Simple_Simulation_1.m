global Xsource Xtarget
Xsource = normrnd(0,1,[300,1]); %% It gives p-value around 0.980
%Xsource = exprnd(1,[300,1]); %% It gives p-value around 0.002
Xtarget = normrnd(0,1,[300,1]);
Xtarget = 2.*Xtarget+10;