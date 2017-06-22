function [x_hat] = recover_from_samples_old(pw, y, gamma, M, V, Dk, g) 

%Pw = diag(pw);
%Lg = U * diag(g(D)) * U'; 
MV = M*V;
if nargin < 7
    Lg = diag(Dk);
else
    Lg = diag(g(Dk)); 
end

% solving eq (10) in the paper
Pw_inv = diag(1./pw);
A = (MV'*Pw_inv*MV + gamma*Lg);
B = MV'*Pw_inv*y;

x_hat = A\B;
%x_hat = inv(A'*A) * A'*B;
