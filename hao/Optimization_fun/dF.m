function df = dF(W)
global XA XB bA sigma

X1 = XA;
X2 = XB-repmat(bA,size(XB,1),1);
n1 = size(X1,1);
n2 = size(X2,1);

D12 = dist2(X1*W,X2);
D1 = dist2(X1*W,X1*W);

distx=exp(-D1./sigma);
distxy=exp(-D12./sigma);

R1=repmat(X1',1,n1);
Z1=repmat(X1',n1,1);
J1=reshape(Z1,size(X1,2),[]);
alphatmp1=reshape(distx,1,[]);
alpha1=repmat(alphatmp1,size(X1,2),1);
deriv1tmp1=2*((R1-J1).*alpha1*(R1-J1)')*W;

R3=repmat(X1',1,n2);
Z3=repmat(X2',n1,1);
J3=reshape(Z3,size(X2,2),[]);
alphatmp3=reshape(distxy,1,[]);
alpha3=repmat(alphatmp3,size(X1,2),1);
deriv3tmp3=4*(R3.*alpha3*(W'*R3-J3)');

df=deriv3tmp3./(n1*n2*sigma)-deriv1tmp1./(n1^2*sigma);
