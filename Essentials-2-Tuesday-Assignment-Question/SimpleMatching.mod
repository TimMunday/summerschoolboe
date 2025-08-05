%**************************************************************************
%                   Tools for Macroeconomists: The Essentials
%
%**************************************************************************

% Petr Sedlacek
% use of this program in any fee-based program requires explicit permission

%==========================================================================
%           Simple matching model and business cycle statistics
%==========================================================================

var c, n, v, y, m, w, Q, g, pf, z; 

varexo e;

parameters beta, nu, phi, psi, mu, rho, rhox, sigma, omega, omega_e, pf_ss, n_ss, g_ss;

beta    = 0.96;
rho     = 0.98;
nu      = 1;
rhox    = 0.027;
phi     = 0.3;
mu      = 0.5;
sigma   = 0.007;
omega   = 0.8;      %If omega = 1, wages are flexible; if omega = 0, wages are fixed

% loading entrepreneur share parameter
load ent_share_value;
set_param_value('omega_e',om_e);

%Calibrated endogenous variable:
pf_ss = 0.338;

%Solving for a parameter psi:
n_ss  = 1/((pf_ss/phi)^(1/mu)*(rhox/pf_ss)+1);
g_ss  = beta*(1/(1-beta*(1-rhox)))*(omega_e);
psi   = pf_ss*g_ss;

model;

end;

initval;
pf = pf_ss;
n  = n_ss;
g  = g_ss;
y  = n;
v  = rhox*n/pf;
m  = pf*v;
w  = 1-omega_e;
Q  = n - w*n;
c  = w*n + Q - psi*v;
z = 0;
 
end;

steady;

check;

shocks;
var e; stderr sigma;
end;

stoch_simul(order=1,nocorr,nomoments,nograph) c n v y m w Q g pf z;