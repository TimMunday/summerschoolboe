function decision = get_policy_rule_coefs_fcn(pert_order,VarsToUse,iprint,M_,oo_)
 

%
% Written by Wouter
% new program (summer 2023) so comments appreciated
%

%this program creates a matrix called decision which contains in each column the
%coefficients of the policy function for the variables specified in
%VarsToUSE exactly as Dynare writes them to the screen
%(unfortunately the coefs in oo_ are presented a bit differently)

% !!!! When running this program INSIDE A FUNCTION:  
% then M_ and oo_ need to be added be as a global statement 
%(both in the function and the main program),since Dynare will not make these
% two variables available to the memory of the function

% pert_order and VarsToUse have to be set before you run this code
% pert_order can be 1 or 2
% the format of VarsToUse should look like 
% VarsToUse = {...
%     'k';...
%     'c';...
%      };
% Decision will contain the variables in the order specified here (so this
% may be different from the way it is shown by Dynare on the screen)

Nvar   = size(VarsToUse,1);
VarLocation1  = zeros(Nvar,1); % ordering used for steady state (constant)
VarLocation2  = zeros(Nvar,1); % ordering used for explanatory variables   

% Find the location of the variable in the two possible orderings
for Vars_index = 1:Nvar
    temp = find(strcmp(M_.endo_names,VarsToUse{Vars_index,1}));
    VarLocation1(Vars_index,1) = temp;
    VarLocation2(Vars_index,1) = find(oo_.dr.order_var==temp);
end

X   = zeros(1,Nvar);
for ip = 1:numel(VarsToUse)
    X(1,ip)          = oo_.dr.ys(VarLocation1(ip));
    if pert_order == 2
       X(1,ip) = X(1,ip)+ 0.5*oo_.dr.ghs2(VarLocation2(ip));
    end
end

if pert_order == 2
    temp   = zeros(1,Nvar);
    for ip = 1:numel(VarsToUse)
        temp(:,ip)       =  0.5*oo_.dr.ghs2(VarLocation2(ip));
    end
    X = [X;temp];
end

oo_.dr.ghxT = oo_.dr.ghx';
temp = zeros(size(oo_.dr.ghxT,1),Nvar);
for ip   = 1:numel(VarsToUse)
    temp(:,ip) = oo_.dr.ghxT(:,VarLocation2(ip));
end
X = [X;temp];

    oo_.dr.ghuT = oo_.dr.ghu';
    temp   = zeros(size(oo_.dr.ghuT,1),Nvar);
    for ip = 1:numel(VarsToUse)
      temp(:,ip) = oo_.dr.ghuT(:,VarLocation2(ip));
    end
    X = [X;temp];

if pert_order == 2
    oo_.dr.ghxxT = oo_.dr.ghxx';
    temp0  = sqrt(size(oo_.dr.ghxxT,1));
    temp   = zeros(temp0*(temp0+1)/2,Nvar);
    for ip = 1:numel(VarsToUse)
        icount = 1;
        for j = 1:temp0
            for k=1:j
                if k == j
                    temp(icount,ip) = oo_.dr.ghxxT((j-1)*temp0+k,VarLocation2(ip))/2;
                else
                    temp(icount,ip) = oo_.dr.ghxxT((j-1)*temp0+k,VarLocation2(ip));
                end
                icount = icount+1;
            end
        end
    end
    X = [X;temp];


    oo_.dr.ghuuT = oo_.dr.ghuu';
    temp0  = sqrt(size(oo_.dr.ghuuT,1));
    temp   = zeros(temp0*(temp0+1)/2,Nvar);
    for ip = 1:numel(VarsToUse)
        icount = 1;
        for j = 1:temp0
            for k=j:temp0
                if k == j
                    temp(icount,ip) = oo_.dr.ghuuT((k-1)*temp0+j,VarLocation2(ip))/2;
                    %disp([j k icount (k-1)*temp0+j])
                    %disp(temp(icount,ip))
                else
                    temp(icount,ip) = oo_.dr.ghuuT((k-1)*temp0+j,VarLocation2(ip));
                    %disp([j k icount (k-1)*temp0+j])
                    %disp(temp(icount,ip))
                end
                icount = icount+1;
            end
        end
    end
    X = [X;temp];

    oo_.dr.ghxuT = oo_.dr.ghxu';
    temp0  = size(oo_.dr.ghxuT,1);
    temp   = zeros(temp0,Nvar);
    for ip = 1:numel(VarsToUse)
        temp(:,ip) = oo_.dr.ghxuT(:,VarLocation2(ip));
    end
    X = [X;temp];

end

if iprint == 1
    disp('   ')
    disp('   ')
    if pert_order == 2
        disp('second line is not part of the policy function but correction of constant')
    end
    disp(VarsToUse')
    disp(X)
end
    
decision = X;


end

