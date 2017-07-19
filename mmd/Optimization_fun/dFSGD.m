function[grad]=dFSGD(W)
global XA XB bA sigma

X1 = XA;
X2 = XB-repmat(bA,size(XB,1),1);
n1 = size(X1,1);
n2 = size(X2,1);
if n1~=n2
    error('SGD require sample sizes equal');
end
rng('shuffle')
pos_i = randi([1 n1],1,1);
pos_j = randi([1 n1],1,1);
x1i = X1(pos_i,:)';
x1j = X1(pos_j,:)';
x2i = X2(pos_i,:)';
x2j = X2(pos_j,:)';

tran_x1i=W'*x1i;
tran_x1j=W'*x1j;
    function value = G_kernel(ww)
        value=exp(-norm(ww)^2/sigma);
    end
base=[G_kernel(tran_x1i-tran_x1j); G_kernel(tran_x1i-x2j); G_kernel(tran_x1j-x2i)];
grad=2/sigma*(-(x1i-x1j)*(tran_x1i-tran_x1j)'*base(1)+x1i*(tran_x1i-x2j)'*base(2)+x1j*(tran_x1j-x2i)'*base(3));
end