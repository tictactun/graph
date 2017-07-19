function Y = exponential(X, U, t)
    Up=U-0.5*X*(X'*U+U'*X);
    p=size(X,2);
    tU = t*Up;
    % From a formula by Ross Lippert, Example 5.4.2 in AMS08.
    Y = [X tU] * expm([X'*tU , -tU'*tU ; eye(p) , X'*tU]) * [ expm(-X'*tU) ; zeros(p) ];       
end

%%%% calculate X+tU