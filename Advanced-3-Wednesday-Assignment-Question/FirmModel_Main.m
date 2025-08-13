%**************************************************************************
%                   Tools for Macroeconomists: The Essentials
%
%**************************************************************************

% Petr Sedlacek
% use of this program in any fee-based program requires explicit permission

%**************************************************************************
%               Solving Firm Dynamics Model with Aggregate Uncertainty
%**************************************************************************   

close all
clear all
clc

%-----------------------------------------------------------------------------------------------------------------------
%% 0. Parameters
%-----------------------------------------------------------------------------------------------------------------------

% Model parameters
par.alpha   = ;                  % returns to scale
par.beta    = ;                  % discount factor
par.delta   = ;                  % firm exit rate
par.n0      = ;                  % initial employment stock
par.zeta    = ;                  % level of adjustment costs
par.sigz    = ;                  % aggregate productivity shock st.dev.
par.rhoz    = ;                  % aggregate productivity persistence

par.gamma   = ;                  % firm-specific productivity across firm types
par.entry   = ;                  % fixed entrant masses
par.W       = ;                  % wage normalized to 1 in steady state

% Computatational choices
par.I       = ;                  % number of "types" (max number of periods without updating)
par.A       = ;                  % max firm age

%-----------------------------------------------------------------------------------------------------------------------
%% 1. Compute steady state
%-----------------------------------------------------------------------------------------------------------------------

% 1.1. Firm values
%------------------

options2    = optimset('MaxIter',400,'MaxFunEvals',10E5,'TolX',10E-14,'TolFun',10E-14,'Display','Off','PlotFcns',@optimplotfval);

xVn         = zeros(par.I,2*par.A);
[resVn,fVn] = fsolve(@(x)get_Vn(par,x),xVn,options2);
save resVn resVn

V           = exp(resVn(:,1:par.A));
n           = exp(resVn(:,par.A+1:end));

% 1.2. firm masses 
%------------------

om      = zeros(par.I,par.A);
om(:,1) = ;

for a = 2:par.A
    om(:,a) = ;
end

% aggregate firm mass
par.Omega   = ;

% 1.3. firm masses 
%------------------
par.chi     = ;

% 1.4. Aggregates
%------------------

par.Y   = ;                         % aggregate output 
par.C   = ;                         % aggregate consumption
par.N   = ;                         % aggregate employment

par.ups = ;                         % disutility of labor

%-----------------------------------------------------------------------------------------------------------------------
%% 2. Solve model using Dynare
%-----------------------------------------------------------------------------------------------------------------------

save paramvals par V n om y
dynare FirmModel.mod noclearall

%-----------------------------------------------------------------------------------------------------------------------
%% 3. Compute impulse response functions of distribution
%-----------------------------------------------------------------------------------------------------------------------

% length of impulse response
par.ti      = 30;                   

for i = 1:par.I
for a = 1:par.A 
    % firm mass
    imp         = eval( ['oo_.irfs.om_' int2str(i) '_' int2str(a) '_ez']);
    omirf(i,a,:)= ;
    
    % employment choice
    imp         = eval( ['oo_.irfs.n_' int2str(i) '_' int2str(a) '_ez']);
    nirf(i,a,:) = ;
end
end

%-----------------------------------------------------------------------------------------------------------------------
%% 4. Estimate aggregate productivity shock
%-----------------------------------------------------------------------------------------------------------------------

save paramvals par V n om y
dynare FirmModelEstimate.mod noclearall


