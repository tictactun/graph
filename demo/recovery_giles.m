function z = recovery_giles(pw, y, gamma, M, L, g) 

% solving eq (10) in the paper
Pw_inv = diag(1./pw);
AA = M'*Pw_inv*M + gamma*(L);
BB = M'*Pw_inv*y;

% AA = M'*M + gamma*(L);
% BB = M'*y;

z = AA\BB;

