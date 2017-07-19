function [mmd] = Fintercept(b)
global transXA XB sigma
%---Here, we calculate MMD of X1 and X2
X1 = (transXA+ones(size(transXA,1),1)*b);
X2 = XB;

n1 = size(X1,1);
n2 = size(X2,1);
D12 = dist2(X1,X2);
Lij=ones(n1,n2)./(-n1*n2);

dist12=exp(-D12./sigma);
mmd=sum(sum(dist12.*Lij));