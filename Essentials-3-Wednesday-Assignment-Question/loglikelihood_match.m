%**************************************************************************
%                   Tools for Macroeconomists: The Essentials
%
%**************************************************************************

% Petr Sedlacek
% use of this program in any fee-based program requires explicit permission

function L = loglikelihood_match(X0,Y,X,zeta0,P0)

%!!! given the input to the minimization routine, define the coefficients needed in the Kalman recursions!!!
% Defining parameters to minimize over
%--------------------------------------

% elements of the variance-covariance matrix
Q   = ;
R   = ;
C   = ;
% transition matrix for match efficiency
F   = ;
% elements of observatoin equation
H   = ;
A   = ;

% calling the Kalman filter routine
[zetat_1, Sigma, ytilde] = KalmanFilter_match(Y,X,zeta0,P0,Q,R,C,F,H,A);

T = max(size(Y));
like = zeros(T,1);

for t = 1:T
    like(t)  = -0.5*log(det(Sigma(t))) - 0.5*ytilde(t)'*(Sigma(t))^(-1)*ytilde(t); % per period log likelihood 
end

L = -(sum(like) - T/2*log(2*pi));       % negative total log likelihood
