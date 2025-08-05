%**************************************************************************
%                   Tools for Macroeconomists: The Essentials
%
%**************************************************************************

% Petr Sedlacek
% use of this program in any fee-based program requires explicit permission

%==========================================================================
%           Simple matching model and business cycle statistics
%==========================================================================


%--------------------------------------------------------------------------
% This m-file sets values for entrepreneur share and then runs a loop and
% does the following:
%
%   1. Runs Dynare to obtain policy functions
%   2. Simulates the economy given the policy functions
%   3. HP-filters the data and computes some labour market statistics
%--------------------------------------------------------------------------

close all
clear all
clc

%--------------------------------------------------------------------------
% 0. Setting values for the entrepreneur share 
%--------------------------------------------------------------------------

ent_share = [0.25,0.1,0.05,0.025,0.01];
I = 5;

% allocating memory
s_ny    = zeros(1,I);

%--------------------------------------------------------------------------
% 0.1. Starting the loop over entrepreneur share values
%--------------------------------------------------------------------------

for i = 1:I

    % specifying entrepreneur share value for loop i
    om_e = ent_share(i);
    
    %----------------------------------------------------------------------
    % 1. Running dynare for a given value of entrepreneur share
    %----------------------------------------------------------------------
    
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
    % Here save the i-th value of omega_e and run the dynare file         %
    % SimpleMatching.mod (dont forget the noclearall command).            %
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
    
    save
    dynare 

    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
    % The code below creates a matrix X with all the policy coefficients  %
    % as they are displayed on screen by Dynare. For this to work, specify%
    % the order of perturbation (pert_order) and the list of variables    %
    % (VarsToUse) exactly in the same way they are set in Dynare.         % 
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%

    pert_order= 1;  
    VarsToUse = {'c';'n';'v';'y';'m';'w';'Q';'g';'pf';'z'};
 
    X = get_policy_rule_coefs_fcn(pert_order,VarsToUse,1,M_,oo_);
    
    %----------------------------------------------------------------------
    % 2. Simulating the economy given policy functions
    %----------------------------------------------------------------------
    
    s = 0.007;           %Standard deviation of the shock
    T = 10000;           %Length of the series
    D = 500;             %Discarded periods in the beginning
    
    %Shock series:
    randn('seed',666);   % fixing random seed
    e = s*randn(T,1);

    % defining variables
    % Reserving space:
    n = zeros(T,1);
    z = zeros(T,1);
    y = zeros(T,1);
    
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
    % Give some sensible intial values for y, n, z. Hint: you have them   %
    % saved somewhere already.                                            %
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
    
    %Initial values:
    y(1,1) = ;
    n(1,1) = ;
    z(1,1) = ;

    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
    % Program the recursion that simulates the economy given the policy   %
    % rules (in matrix X) and realizations of the aggregate shock.        %
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
    
    %Recursion that computes simulated data using the shock series and the
    %policy functions:

    for t = 2:T
          
        y(t,1) = ;
        n(t,1) = ;
        z(t,1) = ;

    end

    %Computing logs, ratios and HP-filtering the artificial data:
    lny  = log(y);
    lnn  = log(n);
    
    %----------------------------------------------------------------------
    % 3. HP filtering simulated data
    %----------------------------------------------------------------------

    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
    % Use the hpfilter2.m function to compute the cyclical components of   %
    % lny and lnn. The hpfilter2.m function takes as inputs a given time   %
    % series x and smoothing coefficient lambda (set this to 1600). The   %
    % output is then the HP trend of the series x.                        %
    % Hence: hptrend_x = hpfilter2(x,1600);                                %
    % Dont forget to discard the first D observations.                    %
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
    
    hp_lny  = ;
    hp_lnn  = ;

    %Computing and displaying business cycle statistics
    
    %volatility of log employment relative to volatility of log output
    %Note that in the US data it is 0.466 
    
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
    % Compute the ratio of the standard deviation of log employment       %
    % relative to the standard deviation of log output using their        %
    % cyclical components.                                                %
    % Plot the cyclical components of log output and log employment       %
    % together in one plot.                                               %
    %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%

    s_ny(1,i)    = ;
    
    figure

    xx1=sprintf('The share of revenues going to the entrepreneur is %8.3f',om_e);
    xx2=sprintf('The volatility of employment relative to output is %8.3f',s_ny(1,i));
    disp(' ')
    disp(xx1)
    disp(xx2)
    disp(' ')
    disp('Look at the graph and hit return to continue')
    pause

end

figure
plot(ent_share,s_ny,'--r',ent_share,ones(I)*0.466,'k','LineWidth',2)
legend('model','US data')
title('std(log(n))/std(log(y))','FontWeight','bold','FontSize',12)

clear n, clear y, clear z

%--------------------------------------------------------------------------
% 4. Computing impulse response functions
%--------------------------------------------------------------------------

s  = 0.007;           %Standard deviation of the shock
Ti = 24;              %Length of the series

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
% Specify the shock for the IRF as being a positive one standard deviation% 
% shock. The length of the IRF is specified by Ti.                        %
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%

%Shock series:
ei    = ;
ei(2) = ; % shock hits economy in second period

% defining variables
% Reserving space:
v = zeros(Ti,1);
n = zeros(Ti,1);
z = zeros(Ti,1);
y = zeros(Ti,1);

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
% Specify the initial values such that the IRFs are relative to the steady%
% state.                                                                  %
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%

%Initial values:
v(1,1) = ;
y(1,1) = ;
n(1,1) = ;
z(1,1) = ;

%Recursion that computes simulated data using the shock series and the
%policy functions:

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
% Program the recursion that calculates the IRFs given the policy         %
% functions and the realizations of the aggregate shock.                  %
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%

for t = 2:Ti

    v(t,1) = ;
    y(t,1) = ;
    n(t,1) = ;
    z(t,1) = ;

end

u = ones(Ti,1) - n;

%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%
% Plot the IRFs for the aggregate productivity shock, unemployment,       %
% vacancies and output as % deviations from steady state.                 %
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%

figure


