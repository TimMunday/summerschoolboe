%**************************************************************************
%                   Tools for Macroeconomists: The Essentials
%
%**************************************************************************

% Petr Sedlacek
% use of this program in any fee-based program requires explicit permission

% Kalman filter recursion

function [zetat, Sigma, ytilde] = KalmanFilter_match(Y,X,zeta0,P0,Q,R,C,F,H,A)

% State-space notation
%
% zeta_{t+1} = F*zeta_t + v_{t+1}   
% y_t = H'*zeta_t + w_t,          
%
% E[v_{t+1};w_t]*[v_{t+1};w_t]' = [Q,C';C,R]
% E[v_{t+1};w_{t}] = [0;0]
%
%==========================================================================
% Structure: Input:  Y      - matrix of observables (1xT)
%                    X      - matrix of observable regressors (pxT)
%                    zeta0  - initial value for state mean (1xT)
%                    P0     - initial value for state MSE (1x1xT)
%                    R      - observation innovation variance 
%                    Q      - state innovation variance 
%                    C      - covariance between state and observation
%                    innovations 
%                    F      - state transition matrix 
%                    H      - coefficients on states in observation eq. 
%                    A      - coefficients on observable regressors
%
%            Output: zetatt - filtered (updated, x(t|t)) state
%                    Sigma  - conditional variance of forecast errors
%                    ytilde - conditional forecast errors
%==========================================================================

% basics

T = max(size(Y));           % sample length

% allocating memory

Ptt     = zeros(1,1,T);     % P_{t|t}
Ptt_1   = zeros(1,1,T);     % P_{t|t-1}
zetat   = zeros(1,T);       % zeta_{t|t}
zetat_1 = zeros(1,T);       % zeta_{t|t-1}
Sigma   = zeros(T,1);       % cond. forecast error variance
ytilde  = zeros(T,1);       % cond. forecast error

% initial values
Ptt_1(:,:,1)    = P0;       % P(1|0)
zetat_1(:,1)    = zeta0;    % zeta(0|0)

for t=1:T
    %!!! fill in the Kalman recursions!!! 
    
end
