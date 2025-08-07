//**************************************************************************
//                   Tools for Macroeconomists: The Essentials
//
//**************************************************************************

// Petr Sedlacek
// use of this program in any fee-based program requires explicit permission

//==========================================================================
//                          Solving a DSGE model
//==========================================================================

var w,p_k,l,c,pr,y,z_x,z_a;
parameters alpha,beta,phi0,phi1,mu0,mu1,k_bar,rho_a,rho_x,sig_a,sig_x,p_k_ss;
varexo e_a e_x;

// Parameter Values  
alpha   = 0.3;
beta    = 0.99;
mu0     = 0.02;
mu1     = 2;
k_bar   = 1;
rho_a   = 0.9;
rho_x   = 0.9;
sig_a   = 0.01;
sig_x   = 0.5;
p_k_ss  = alpha/(1-beta);
phi0    = (1-alpha)/(1+alpha*mu0);
phi1    = 1;

// model equations

model;
// First-order conditions
exp(w)/exp(c)       = phi0*exp(l)^phi1;
exp(w)*(1+exp(pr))  = (1-alpha)*z_a*(k_bar/exp(l))^(alpha);
exp(p_k)            = alpha*z_a*(k_bar/exp(l))^(alpha-1) + beta*(exp(c)/exp(c(+1)))*exp(p_k(+1));
exp(y)              = exp(c) + exp(pr)*exp(w)*exp(l);

// Auxiliary definitions
exp(pr)  = mu0*z_x*(p_k_ss/exp(p_k))^mu1;   // risk premium
exp(y)   = z_a*k_bar^alpha*exp(l)^(1-alpha);     // output

// exogenous shocks
log(z_a) = rho_a*log(z_a(-1)) + e_a;
log(z_x) = rho_x*log(z_x(-1)) + e_x;

end;

initval;
w   = log((1-alpha)/(1+mu0));
p_k = log(p_k_ss);
l   = log(1);
c   = log((1+mu0*alpha)/(1+mu0));
z_x = 1;
z_a = 1;
pr  = log(mu0);
y   = log(1);
end;

shocks;
var e_a;  stderr sig_a;
var e_x;  stderr sig_x;
end;

resid;
steady;

stoch_simul(irf=50,order=1);