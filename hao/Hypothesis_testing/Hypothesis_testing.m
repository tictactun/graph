%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% This bootstrap assumes no transformation on X_t %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Xsource Xtarget sigma
fvalue = F(WS);
m = size(Xtarget,1);
n = size(Xsource,1);
shufflepos = randi(m,[1,n+m]);
bootX = Xtarget(shufflepos(1:m),:);
bootY = Xtarget(shufflepos((m+1):(m+n)),:);
shufflenum = 1000;
pvalue = mmdTestBoot(bootX,bootY,shufflenum,fvalue);
sprintf('objective function is: %.3E, p-value is: %.5f',fvalue,pvalue)

