%**************************************************************************
%                 Tools for Macroeconomists: The Essentials
%**************************************************************************

% Petr Sedlacek
% use of this program in any fee-based program requires explicit permission

%==========================================================================
%      Solving a DSGE model with 2 different linearization approaches
%==========================================================================


%--------------------------------------------------------------------------
% This m-file sets parameter values of the neoclassical growth model with
% endogenous labor supply and solves it in two ways:
%
%   1. Runs Dynare with 1st order perturbation 
%   2. Runs Pontus' DIY solution (using Pontus' code)
%--------------------------------------------------------------------------

close all
clear all
clc

%--------------------------------------------------------------------------
% 0. Setting parameter values
%--------------------------------------------------------------------------

alpha   = 1/3;          % Capital share of output
beta    = 1.03^(-0.25);  % Discount factor.
gamma   = 2.0;            % Coefficient of risk aversion
eta     = 2.0;            % Frisch elasticity of labor supply
delta   = 0.025;        % Depreciation rate of capital
rho     = 0.9;          % Persistence of TFP process
sigma   = 0.01;         % Volatility of TFP shocks

%--------------------------------------------------------------------------
% 1. Solve for the steady state
%--------------------------------------------------------------------------

% Let's define the system of equilibrium conditions, F. Towards this end, 
% define objects (functions) that correspond to the Euler equation (Ee), resource
% constraint (Rc) and optimal labor supply (Ls). In doing so, we use "x" as
% the inputs into these functions, where x is a vector of our 3 endogenous 
% variables: x(1) is consumption, x(2) is capital and x(3) is labor. Each
% of the functions should have the following structure: 
% e.g. Ee = @(x) XYZ, where XYZ is the Euler equation where we specify it such that
% it is equal to 0 in equilibrium. Do the same for the resource constraint and the 
% optimal labor supply condition.

Ee = @(x) -x(1)^gamma + beta*x(1)^(gamma)*alpha*x(2)^(alpha-1)*x(3)^(1-alpha) + beta*(1-delta);
Rc = @(x) x(1) + x(2) - x(2)^(alpha)*x(3)^(1-alpha) - (1-delta)*x(2);
Ls = @(x) x(3)^eta - x(1)^(-gamma)*(1-alpha)*x(2)^alpha*x(3)^(-alpha);

% Collect the equations as a system of equations.
ss = @(x) [Ee(x);Rc(x);Ls(x)];

% Let fsolve do the job of solving for the steady state
options = optimoptions('fsolve','Display','off','tolfun',1e-10,'tolx',1e-10);
xss = fsolve(ss,[1 1 1],options);

css = xss(1);
kss = xss(2);
lss = xss(3);

% Let's include output and investment too just for illustration
yss = xss(2)^(alpha)*xss(3)^(1-alpha);
Iss = yss - css;

%--------------------------------------------------------------------------
% 2. Dynare solution
%--------------------------------------------------------------------------

% save the model parameters (and those of the steady state) and solve the
% model with Dynare (generating 40 periods of IRFs)
save params alpha beta gamma eta delta rho kss css lss
dynare ModelDynare.mod noclearall

%--------------------------------------------------------------------------
% 3. DIY linearization (this part is based on Pontus' code)
%--------------------------------------------------------------------------

% Let's define the steady state vector (including productivity as the last
% element)
xss = [yss,Iss,xss,1];

% 3.1. Setting up symbolic system
%---------------------------------
% We use the following notation: "m" stands for t Minus 1 (predetermined) 
% variables and "p" stands for t Plus 1 variables

syms ym y yp cm c cp Im I Ip km k kp lm l lp zm z zp

% define here the "system" of equilibrium conditions, essentially the same as the 
% model block in Dynare, just with different notation and making sure that each 
% row equals 0 in equilibrium.
system = [];

% Useful vectors not to confuse things.

Xm = [ym Im cm km lm zm];
X = [y I c k l z];
Xp = [yp Ip cp kp lp zp];
Xss = [yss yss yss Iss Iss Iss css css css kss kss kss lss lss lss 1 1 1];
Vars = [ym y yp Im I Ip cm c cp km k kp lm l lp zm z zp];

% Linearize system.

A = jacobian(system,Xm);    A = double(subs(A,Vars,Xss));
B = jacobian(system,X);     B = double(subs(B,Vars,Xss));
C = jacobian(system,Xp);    C = double(subs(C,Vars,Xss));

% Convert to log-linear system (doesn't matter as long as you interpret things correctly).

M = ones(6,1)*xss;
A = A.*M; B = B.*M; C = C.*M;

% 3.2. Solve by iterating on F
%-----------------------------

metric = 1;     % starting point of convergence metric
F = 0;          % initial guess of F

% write a "while loop" here, updating F and computing the convergence
% metric. Once the metric falls below e1-13, we'll be happy. 

while 
    F       = ;
    metric  = ;
end


% once F is solve, we can solve for Q
Q = ;
    

% 3.3. Impulse response functions
%----------------------------------

T = 40;

u = zeros(6,1); u(end) = 1;
x(:,1) = Q*u;

for t = 1:T-1
    x(:,t+1) = F*x(:,t);
end

x = x/100;

% 3.4. Plot the results
%-----------------------

black = [0 0 0];

add = 0.015;
add3 = 0.015;
add2 = add3/2;
add4 = add/4;

figure;
h = subplot(3,2,1)
ph = get(h, 'pos');
ph(4) = ph(4) + add;
ph(3) = ph(3) + add2;
ph(2) = ph(2) - add4;
set(h, 'pos', ph);
p1 = plot(x(1,:),'linewidth',1.6,'color',black);
set(gca,'FontSize',8,'fontname','times')
ylabel('Percent deviation','FontSize',10,'fontname','times')
title('Output','FontSize',10,'fontname','times','FontWeight','Normal')

h = subplot(3,2,2);
ph = get(h, 'pos');
ph(4) = ph(4) + add;
ph(3) = ph(3) + add2;
ph(1) = ph(1) - add3;
ph(2) = ph(2) - add4;
set(h, 'pos', ph);
p1 = plot(x(3,:),'linewidth',1.6,'color',black);
ylim([0,0.003])
set(gca,'FontSize',8,'fontname','times')
title('Consumption','FontSize',10,'fontname','times','FontWeight','Normal')

h = subplot(3,2,3);
ph = get(h, 'pos');
ph(4) = ph(4) + add;
ph(3) = ph(3) + add2;
ph(2) = ph(2) - add4;
set(h, 'pos', ph);
p1 = plot(x(2,:),'linewidth',1.6,'color',black);
set(gca,'FontSize',8,'fontname','times')
ylabel('Percent deviation','FontSize',10,'fontname','times')
title('Investment','FontSize',10,'fontname','times','FontWeight','Normal')

h = subplot(3,2,4);
ph = get(h, 'pos');
ph(4) = ph(4) + add;
ph(3) = ph(3) + add2;
ph(1) = ph(1) - add3;
ph(2) = ph(2) - add4;
set(h, 'pos', ph);
p1 = plot([0,x(4,1:end-1)],'linewidth',1.6,'color',black);
set(gca,'FontSize',8,'fontname','times')
title('Capital','FontSize',10,'fontname','times','FontWeight','Normal')

h = subplot(3,2,5);
ph = get(h, 'pos');
ph(4) = ph(4) + add;
ph(3) = ph(3) + add2;
ph(2) = ph(2) - add4;
set(h, 'pos', ph);
p1 = plot(x(5,:),'linewidth',1.6,'color',black);
set(gca,'FontSize',8,'fontname','times')
ylabel('Percent deviation','FontSize',10,'fontname','times')
title('Hours','FontSize',10,'fontname','times','FontWeight','Normal')
xlabel('Time (quarters)','FontSize',10,'fontname','times')

h = subplot(3,2,6);
ph = get(h, 'pos');
ph(4) = ph(4) + add;
ph(3) = ph(3) + add2;
ph(1) = ph(1) - add3;
ph(2) = ph(2) - add4;
set(h, 'pos', ph);
p1 = plot(x(6,:),'linewidth',1.6,'color',black);
set(gca,'FontSize',8,'fontname','times')
title('Productivity','FontSize',10,'fontname','times','FontWeight','Normal')
xlabel('Time (quarters)','FontSize',10,'fontname','times')

xSize = 20.5; 
ySize = 18;

set(gcf,'Units','centimeters','Position',[0 0 xSize ySize],'PaperUnits','centimeters' ...
     ,'PaperPosition',[0 0 xSize ySize],'PaperSize',[xSize-3.2 ySize-1.2],'PaperPositionMode','auto')






