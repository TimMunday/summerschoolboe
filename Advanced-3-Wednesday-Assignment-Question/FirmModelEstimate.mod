//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
//                                        Firm Dynamics in Macro Models
//                                                Petr Sedlacek
//                                        *****************************
//                                                Problem Set 4
//                             Estimating Firm Dynamics Model with Aggregate Uncertainty
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    


@#define I   = 3 
@#define A   = 30

// firm-level variables
//-----------------------
@#for i in 1:I
@#for a in 1:A
    var om_@{i}_@{a};     // firm masses
@#endfor
@#endfor

@#for i in 1:I
@#for a in 1:A
    var V_@{i}_@{a};      // firm values
@#endfor
@#endfor

@#for i in 1:I
@#for a in 1:A
    var y_@{i}_@{a};      // firm-level output 
@#endfor
@#endfor

@#for i in 1:I
@#for a in 1:A
    var n_@{i}_@{a};      // firm-level employmnet
@#endfor
@#endfor

// aggregate variables
//---------------------

var Y, C, N, W, Omega, Z, E, Ycyc;
               
varexo ez;

// parameters

parameters alpha, beta, chi, delta, n0, zeta, ups, sigz, rhoz, Yss, Css, Nss, Wss, Omegass; 

@#for i in 1:I
    parameters gam_@{i};
@#endfor

@#for i in 1:I
    parameters entry_@{i};
@#endfor

load paramvals;

// set parameter values
set_param_value('alpha'     ,par.alpha);            // labor share
set_param_value('beta'      ,par.beta);             // discount factor
set_param_value('chi'       ,par.chi);              // entry cost
set_param_value('delta'     ,par.delta);            // exit rate
set_param_value('n0'        ,par.n0);               // initial employment level
set_param_value('zeta'      ,par.zeta);             // adjustment cost level
set_param_value('ups'       ,par.ups);              // disutility from work
set_param_value('sigz'      ,par.sigz);             // st. dev. of aggregate productivity shock
set_param_value('rhoz'      ,par.rhoz);             // persistence of aggregate productivity shock

@#for i in 1:I
    set_param_value('gam_@{i}' ,(par.gamma(@{i}))); // technology levels
@#endfor
@#for i in 1:I
    set_param_value('entry_@{i}' ,(par.entry(@{i})));// entrant masses
@#endfor

set_param_value('Yss'       ,par.Y);                // aggregate output
set_param_value('Css'       ,par.C);                // aggregate consumption
set_param_value('Nss'       ,par.N);                // employment (firm mass)
set_param_value('Wss'       ,par.W);                // average wages
set_param_value('Omegass'   ,par.Omega);            // number of firms

// Model declaration
model;




Ycyc = ;

end;

//initial values
initval;

@#for i in 1:I
@#for a in 1:A
    V_@{i}_@{a}     = V(@{i},@{a});
    om_@{i}_@{a}    = om(@{i},@{a});
    y_@{i}_@{a}     = y(@{i},@{a});   
    n_@{i}_@{a}     = n(@{i},@{a});
@#endfor
@#endfor

C   = Css; 
Y   = Yss; 
N   = Nss;
W   = Wss;
Omega = Omegass;
Z   = 1;
E   = 1;
Y_cyc = 0;
end;

shocks;
var ez; stderr sigz;
end;

resid;

steady;

check; 

estimated_params;
rhoz, ;
stderr ez, ;
end;

varobs Ycyc;
estimation(datafile=data_estimation,smoother,mode_compute=1,mode_check,optim=('display','iter','MaxFunEvals',400,'TolFun',1e-10,'TolX',1e-10)) Y, Z, N, E;













