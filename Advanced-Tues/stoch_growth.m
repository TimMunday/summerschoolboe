clear;

beta = 1.03^(-1/4);
gamma = 1;
alpha = 0.3;
delta = 0.02;
sigma = 0.23;
rho = 0;
N = 100;
kss = ((1/beta-1+delta)/alpha)^(1/(alpha-1));
kgrd = linspace(0.4*kss,1.7*kss,N)';

% Transition matrix

P = [(1+rho)/2 (1-rho)/2;(1-rho)/2 (1+rho)/2];

% Derivative matrix

D = zeros(N,N);
for i = 2:N-1
    
    D(i,i-1) = -1/2*1/(kgrd(i)-kgrd(i-1));
    D(i,i) = 1/2*(1/(kgrd(i)-kgrd(i-1))-1/(kgrd(i+1)-kgrd(i)));
    D(i,i+1) = 1/2*1/(kgrd(i+1)-kgrd(i));
    
end

D(1,1) = -1/(kgrd(2)-kgrd(1));
D(1,2) = 1/(kgrd(2)-kgrd(1));
D(end,end-1) = -1/(kgrd(end)-kgrd(end-1));
D(end,end) = 1/(kgrd(end)-kgrd(end-1));

% Initial guesses 

kg0 = kgrd;
kb0 = kgrd;

% Implied initial derivative of value function

dv_g = (1+exp(sigma)*alpha*kgrd.^(alpha-1)-delta).*((exp(sigma)*kgrd.^(alpha)+(1-delta)*kgrd)-kg0).^(-gamma);
dv_b = (1+exp(-sigma)*alpha*kgrd.^(alpha-1)-delta).*((exp(-sigma)*kgrd.^(alpha)+(1-delta)*kgrd)-kb0).^(-gamma);

% Expected values
Edv_g = beta*(P(1,1)*dv_g+P(1,2)*dv_b);
Edv_b = beta*(P(2,1)*dv_g+P(2,2)*dv_b);

% Functional approximations of the expected values and their derivatives
Edv_gf = griddedInterpolant(kgrd,Edv_g);
Edv_bf = griddedInterpolant(kgrd,Edv_b);
DEdv_gf = griddedInterpolant(kgrd,D*Edv_g);
DEdv_bf = griddedInterpolant(kgrd,D*Edv_b);

% First order conditions to be solved

fg = @(x) -(exp(sigma)*kgrd.^(alpha)+(1-delta)*kgrd-x).^(-gamma)+Edv_gf(x);
fb = @(x) -(exp(-sigma)*kgrd.^(alpha)+(1-delta)*kgrd-x).^(-gamma)+Edv_bf(x);

% Derivatives of first order conditions (for Newton's method)

dfg = @(x) -gamma*(exp(sigma)*kgrd.^(alpha)+(1-delta)*kgrd-x).^(-gamma-1)+DEdv_gf(x);
dfb = @(x) -gamma*(exp(-sigma)*kgrd.^(alpha)+(1-delta)*kgrd-x).^(-gamma-1)+DEdv_bf(x);

% Ok, Solve the problem

metric = 1;

tic

while metric>1e-6

% Newton's method (notice that I only iterate twice, what is important is
% the tight criterion of the outer loop above)

for i = 1:2
    
    kg1 = kg0-fg(kg0)./dfg(kg0);
    kb1 = kb0-fb(kb0)./dfb(kb0);
    
    metric2 = max(abs(kb0-kb1));
    
    kg0 = kg1;
    kb0 = kb1;
    
end

% Update the guesses and first order conditions

dv_g = (1+exp(sigma)*alpha*kgrd.^(alpha-1)-delta).*((exp(sigma)*kgrd.^(alpha)+(1-delta)*kgrd)-kg0).^(-gamma);
dv_b = (1+exp(-sigma)*alpha*kgrd.^(alpha-1)-delta).*((exp(-sigma)*kgrd.^(alpha)+(1-delta)*kgrd)-kb0).^(-gamma);

Edv_g = beta*(P(1,1)*dv_g+P(1,2)*dv_b);
Edv_b = beta*(P(2,1)*dv_g+P(2,2)*dv_b);

Edv_gf = griddedInterpolant(kgrd,Edv_g);
Edv_bf = griddedInterpolant(kgrd,Edv_b);
DEdv_gf = griddedInterpolant(kgrd,D*Edv_g);
DEdv_bf = griddedInterpolant(kgrd,D*Edv_b);

fg = @(x) -(exp(sigma)*kgrd.^(alpha)+(1-delta)*kgrd-x).^(-gamma)+Edv_gf(x);
fb = @(x) -(exp(-sigma)*kgrd.^(alpha)+(1-delta)*kgrd-x).^(-gamma)+Edv_bf(x);

dfg = @(x) -(exp(sigma)*kgrd.^(alpha)+(1-delta)*kgrd-x).^(-gamma-1)+DEdv_gf(x);
dfb = @(x) -(exp(-sigma)*kgrd.^(alpha)+(1-delta)*kgrd-x).^(-gamma-1)+DEdv_bf(x);

% Check convergence

metric = max(max(abs([fg(kg0) fb(kb0)])));

% Repeat.

end

toc

% Problem is solved.

kg = kg1;
kb = kb1;

figure;
p1 = plot(log(kgrd),log(kg)-log((1-delta))-log(kgrd),'linewidth',1.6);
hold on
p2 = plot(log(kgrd),log(kb)-log((1-delta))-log(kgrd),'linewidth',1.6);
hold off
legend1 = legend([p1,p2],'\sigma=0.23','\sigma=-0.23');
set(legend1,'fontname','times','Location','northeast','FontSize',12)
set(gca,'FontSize',12,'fontname','times')
xlabel('(Log of) Capital','FontSize',12,'fontname','times')
ylabel('(Log of) Investment','FontSize',12,'fontname','times')

kg = min(kg,max(kgrd));
kg = max(kg,min(kgrd));

kb = min(kb,max(kgrd));
kb = max(kb,min(kgrd));

Cg = exp(sigma)*kgrd.^(alpha)+(1-delta)*kgrd-kg;
Cb = exp(-sigma)*kgrd.^(alpha)+(1-delta)*kgrd-kb;

C = [Cg;Cb];

Yg = exp(sigma)*kgrd.^(alpha);
Yb = exp(-sigma)*kgrd.^(alpha);

Y = [Yg;Yb];

Ing = kg-(1-delta)*kgrd;
Inb = kb-(1-delta)*kgrd;

In = [Ing;Inb];

F = griddedInterpolant(kgrd,kgrd,'next');
kgd = F(kg);
kbd = F(kb);

Tg = zeros(N,N);
Tb = zeros(N,N);

for i = 1:N
    
    ixg = find(kgrd==kgd(i));
    Tg(i,ixg) = 1-(kgrd(ixg)-kg(i))/(kgrd(ixg)-kgrd(ixg-1));
    Tg(i,ixg-1) = 1-Tg(i,ixg);
    
    ixb = find(kgrd==kbd(i));
    if ixb == 1
        Tb(i,ixb) = 1;
    else
    Tb(i,ixb) = 1-(kgrd(ixb)-kb(i))/(kgrd(ixb)-kgrd(ixb-1));
    Tb(i,ixb-1) = 1-Tb(i,ixb);
    end
    
end

T = [P(1,1)*Tg,P(1,2)*Tg;
    P(2,1)*Tb,P(2,2)*Tb];

T = sparse(T);

tic
opts.disp = 0;
[V,D] = eigs(T',1,1,opts);
V = V/sum(V);
dist = V(1:N)+V(N+1:end);
toc

% % Alternative (can be up to ten times faster)
% 
% tic
% b = zeros(N*2,1);
% b(1) = 1;
% Th = (T'-speye(2*N));
% Th(1,:) = [1,zeros(1,2*N-1)];
% V = Th\b;
% V = V/sum(V);
% dist = V(1:N)+V(N+1:end);
% toc


Kgr = [kgrd;kgrd];

Vimp = V;
Vimp(:,2) = zeros(N*2,1);
Vimp(N+1:end,2) = dist;

Cimp(:,1) = Vimp(:,1)'*C;
Cimp(:,2) = Vimp(:,2)'*C;

Yimp(:,1) = Vimp(:,1)'*Y;
Yimp(:,2) = Vimp(:,2)'*Y;

Inimp(:,1) = Vimp(:,1)'*In;
Inimp(:,2) = Vimp(:,2)'*In;

zgr = [exp(sigma)*ones(N,1);exp(-sigma)*ones(N,1)];

Zimp(:,1) = Vimp(:,1)'*zgr;
Zimp(:,2) = Vimp(:,2)'*zgr;

Kimp(:,1) = Vimp(:,1)'*Kgr;
Kimp(:,2) = Vimp(:,2)'*Kgr;


TT = 15;

for t = 3:TT
    Vimp(:,t) = T'*Vimp(:,t-1);
    Cimp(:,t) = Vimp(:,t)'*C;
    Yimp(:,t) = Vimp(:,t)'*Y;
    Inimp(:,t) = Vimp(:,t)'*In;
    Zimp(:,t) = Vimp(:,t)'*zgr;
    Kimp(:,t) = Vimp(:,t)'*Kgr;
end
    
figure;
subplot(2,2,1);
plot(log(Zimp)-log(Zimp(1)),'linewidth',1.6);
ylabel('Productivity, z','FontSize',12,'fontname','times')
set(gca,'FontSize',12,'fontname','times')
subplot(2,2,2);
plot(log(Yimp)-log(Yimp(1)),'linewidth',1.6);
ylabel('Output, y','FontSize',12,'fontname','times')
set(gca,'FontSize',12,'fontname','times')
subplot(2,2,3);
plot(Inimp,'linewidth',1.6);
ylabel('Investment, i','FontSize',12,'fontname','times')
xlabel('Time (quarters)','FontSize',12,'fontname','times')
set(gca,'FontSize',12,'fontname','times')
subplot(2,2,4);
plot(log(Cimp)-log(Cimp(1)),'linewidth',1.6);
ylabel('Consumption, c','FontSize',12,'fontname','times')
xlabel('Time (quarters)','FontSize',12,'fontname','times')
set(gca,'FontSize',12,'fontname','times')

