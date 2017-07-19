function [pvalue] = mmdTestBoot(X,Y,shufflenum,fvalue)
global sigma
m=size(X,1);
n=size(Y,1);
K = rbf_dot(X,X,sigma);
L = rbf_dot(Y,Y,sigma);
KL = rbf_dot(X,Y,sigma);
Kz = [K KL; KL' L];

MMDboot = zeros(shufflenum,1);
for bootnum=1:shufflenum    
    [~,indShuff] = sort(rand(m+n,1));
    KzShuff = Kz(indShuff,indShuff);
    K = KzShuff(1:m,1:m);
    L = KzShuff((m+1):(m+n),(m+1):(m+n));
    KL = KzShuff(1:m,(m+1):(m+n));    
    MMDboot(bootnum) = 1/(m^2)*sum(K(:))+1/(n^2)*sum(L(:))-2/(n*m)*sum(KL(:));    
end 
MMDboot = sort(MMDboot);
pvalue=sum(MMDboot>fvalue)/shufflenum;

