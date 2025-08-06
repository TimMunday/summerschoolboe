%**************************************************************************
%                   Tools for Macroeconomists: The Essentials
%
%**************************************************************************

% Petr Sedlacek
% use of this program in any fee-based program requires explicit permission


%==========================================================================
%            Estimating the aggregate matching function and match
%                 efficiency during the Great Recession
%==========================================================================

%==========================================================================
% This program:
% 0) load data and create variables
% 1) Using data on unemployment, vacancies and hiring estimate the 
%    aggregate matching function and associated match efficiency
% 2) Using your estimated model explore to what extent the decline in 
%    match efficiency contributed to the unemployment rate increase
%==========================================================================

clear all
clc

%--------------------------------------------------------------------------
% The state-space model being used is written as:
% zeta_{t+1} = F*zeta_t + v_{t+1}
% y_t = A x_t + H'*zeta_t + w_{t}
% 
% E[v_{t+1};w_{t}][v_{t+1};w_{t}]'=[Q,C;C,R]
% E[v_{t+1};w_{t}] = [0;0]
%--------------------------------------------------------------------------

%% 0. load data and create variables
%--------------------------------------------------------------------------

load matchdata

T   = size(matchdata,1);    % sample lenght (in months)
H   = matchdata(:,1);       % number of hires 
V   = matchdata(:,2);       % number of vacancies
U   = matchdata(:,3);       % number of unemployed

% create dependent and independent variables
Y   = log(H./U);            % job finding rate of the unemployed
X   = [log(V./U)];          % labor market tightness

%% 1. estimate aggregate matching function
%--------------------------------------------------------------------------

% Initial values for Kalman recursion (x_0 and Sig_0)

zeta0   = 0;
P0      = 10^5;

% !!! Set initial values for estimate parameters !!!
% hint: an ols estimate of the matching function will do fine as a starting point


Rini    = ;
Qini    = ;
muini   = ;

% Chris Sims minimizatin algorithm
X0ini= [log(Qini),log(Rini),muini];
H0 = ones(max(size(X0ini)),max(size(X0ini)))*10^(-4);
crit = 10^(-13);
iter = 350;
% [fval,res,gh,He,itct,fcount,retcodeh] = csminwel(@(X0)loglikelihood_match(X0,Y, ...
%     X,zeta0,P0),X0ini,H0,[],crit,iter);

[res,fval] = fminsearch(@(X0)loglikelihood_match_full(X0,Y, ...
    X,zeta0,P0),X0ini);

% using results to run Kalman filter again

%!!! define the coefficients for the Kalman recursion based on your esitmates!!!

% elements of the variance-covariance matrix
Qest    = ;
Rest    = ;
Cest    = ;
% transition matrix for match efficiency
Fest    = ;
% elements of observatoin equation
Hest    = ;
Aest    = ;

[zetat, Sigma, ytilde] = KalmanFilter_match(Y,X,zeta0,P0,Qest,Rest,Cest,Fest,Hest,Aest);

tM = 2001-1/12:1/12:2015+4/12;
figure
plot(tM,zetat,'k','LineWidth',2)
title('Matching efficiency')

disp('estimated parameters')
disp('       Q         R        mu')
disp([Qest, Rest, Aest])



%% 2. Unemployment rate dynamics
%-------------------------------------------------------------------------

Ur      = matchdata(:,4);       % unemployment rate

%!!! define the predicted job finding rate (Fpred) and its counterfactual based on assuming match efficiency
%to be fixed after Nov2007!!!

Fpred           = ;         % predicted job finding rate (i.e. less regression error)
Fpredc          = ;         % counterfactual based on match efficiency remaining fixed at its Nov2007 level
   

figure
plot(tM,Fpred,'k',tM,Fpredc,'--r','LineWidth',2)
legend('data','counterfactual',0)
title('Job finding rate')


% counterfactual unemployment rate

%!!! use the steady state expression for the unemployment rate to impute the separation rate!!!

sep     = ;                     % separation rate implied by steady state expression for unemployment

%!!! use "sep" and the counterfactual job finding rate "Fpredc" to create a counterfactual unemployment
%rate!!!
% hint: again use the steady state expression for the unemployment rate

Urc     = ;                     % counterfactual unemployment rate


% !!!plot the actual and counterfactual unemployment rates!!!
figure
plot()
legend('data','counterfactual',0)
title('Unemployment rate')

