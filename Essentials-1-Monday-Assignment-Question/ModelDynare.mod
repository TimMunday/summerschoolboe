// neoclassical growth model solution and simulation

var y, c, i, k, l, z;
varexo e;
parameters alpha, beta, delta, eta, gamma, rho, sigma, kss, css, lss;

load params;

set_param_value('alpha'     ,alpha);   // returns to scale parameter
set_param_value('beta'      ,beta);    // discount factor
set_param_value('delta'     ,delta);   // depreciation rate
set_param_value('eta'       ,eta);     // Frisch elasticity of labor supply
set_param_value('gamma'     ,gamma);   // relative risk aversion coefficient
set_param_value('rho'       ,rho);     // autocorrelation of productivity shock
set_param_value('sigma'     ,sigma);   // standard deviation of productivity shock

set_param_value('kss'       ,kss);     // steady state capital
set_param_value('css'       ,css);     // steady state consumption
set_param_value('lss'       ,lss);     // steady state labor

model;
exp(c)^(-gamma) = beta*exp(c(+1))^(-gamma)*alpha*exp(z(+1))*exp(k(+1))^(alpha-1)*exp(l(+1))^(1-alpha) + beta*(1-delta);
exp(l)^eta = exp(c)^(-gamma)*(1-alpha)*exp(z)*exp(k)^alpha*exp(l)^(-alpha);
exp(c) + exp(k(+1)) = exp(z)*exp(k)^alpha*exp(l)^(1-alpha) + (1-delta)*exp(k);

exp(y) = exp(z)*exp(k)^alpha*exp(l)^(1-alpha);
exp(i) = exp(y) - exp(c);

end;

initval;


end;

shocks;
var e; stderr sigma;
end;

resid;
steady;

stoch_simul(order=1,nomoments, irf=40);