% function that calculates the steady state values for the productivity cutoffs and firm values (given W)

function L = get_Vn(par,x)

V       = exp(x(:,1:par.A));
n       = exp(x(:,par.A+1:end));

% implied output values
y       = ;

% firm values and optimal employment conditions
%------------------------------------------------

F   = ones(par.I,par.A);
G   = ones(par.I,par.A);

for i = 1:par.I
    % startups
    F(i,1)  = ;
    G(i,1)  = ;

    % older firms
    for a = 2:par.A-1
        F(i,a)  = ;
        G(i,a)  = ;
    end
    
    % end-point firms
    
    F(i,end)  = ;
    G(i,end)  = ;
end

L = [F,G];

