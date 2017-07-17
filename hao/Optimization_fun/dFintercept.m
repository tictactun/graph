function df = dFintercept(b)
global transXA XB sigma

X1 = transXA+ones(size(transXA,1),1)*b;
X2 = XB;
n1 = size(X1,1);
n2 = size(X2,1);

D12 = dist2(X1,X2);
distxy=exp(-D12./sigma);

R3=repmat(X1',1,n2);
Z3=repmat(X2',n1,1);
J3=reshape(Z3,size(X2,2),[]);
alpha3=reshape(distxy,1,[]);
deriv3tmp3=2*(alpha3*(R3-J3)');

df=deriv3tmp3./(n1*n2*sigma);