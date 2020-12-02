% [zdatalinear zdatapiecewise zdatass oo 00 M 00] = solve two constraints(modnam 00,modnam 10,modnam 01,modnam 11,... constraint1, constraint2,... constraint relax1, constraint relax2,... shockssequence,irfshock,nperiods,curb retrench,maxiter,init);
% 
% Inputs:
% modnam 00: name of the .mod file for reference regime (excludes the .mod extension). modnam10: name of the .mod file for the alternative regime governed by the first
% constraint.
% modnam01: name of the .mod file for the alternative regime governed by the second constraint.
% modnam 11: name of the .mod file for the case in which both constraints force a switch to their alternative regimes.
% constraint1: the first constraint (see notes 1 and 2 below). If constraint1 evaluates to true, then the solution switches to the alternative regime for condition 1. In thatcase, if constraint2 (described below) evaluates to false, then the model solution switches to enforcing the conditions for an equilibrium in modnam 10. Otherwise, if constraint2 also evaluates to true, then the model solution switches to enforcing the conditions for an equilibrium in modnam 11.
% constraint relax1: when the condition in constraint relax1 evaluates to true, the solution returns to the reference regime for constraint1.
% constraint2: the second constraint (see notes 1 and 2 below). constraint relax2: when the condition in constraint relax2 evaluates to true, the
% solution returns to the reference regime for constraint2. shockssequence: a sequence of unforeseen shocks under which one wants to solve the
% model
% irfshock: label for innovation for IRFs, from Dynare .mod file (one or more of the ?varexo?)
% nperiods: simulation horizon (can be longer than the sequence of shocks defined in shockssequence; must be long enough to ensure convergence back to the reference model at the end of the simulation horizon and may need to be varied depending on the sequence of shocks).
% curb retrench:	a scalar equal to 0 or 1. Default is 0. When set to 0, it updates the guess based of regimes based on the previous iteration. When set to 1, it updates in a manner similar to a Gauss-Jacobi scheme, slowing the iterations down by updating the guess of regimes only one period at a time.
% maxiter: maximum number of iterations allowed for the solution algorithm (20 if not specified).
% init:	the initial position for the vector of state variables, in deviation from steady state (if not specified, the default is a vector of zero implying that the initial conditions coincide with the steady state). The ordering follows the definition order in the .mod files.
%
% Outputs:
% zdatalinear: an array containing paths for all endogenous variables ignoring the occasionally binding constraint (the linear solution), in deviation from steady state. Each column is a variable, the order is the definition order in the .mod files.
% zdatapiecewise: an array containing paths for all endogenous variables satisfying the occasionally binding constraint (the occbin/piecewise solution), in deviation from steady state. Each column is a variable, the order is the definition order in the .mod files.
% zdatass: a vector that holds the steady state values of the endogenous variables ( following the definition order in the .mod file).
% oo00 , M00 :	structures produced by Dynare for the reference model ? see Dynare User Guide.


% Log of changes
% 6/17/2013 -- Luca added a trailing underscore to local variables in an
% attempt to avoid conflicts with parameter names defined in the .mod files
% to be processed.
% 6/17/2013 -- Luca replaced external .m file setss.m

function [ zdatalinear_ zdatapiecewise_ zdatass_ oo00_  M00_ ] = ...
  solve_two_constraints(modnam_00_,modnam_10_,modnam_01_,modnam_11_,...
    constrain1_, constrain2_,...
    constraint_relax1_, constraint_relax2_,...
    shockssequence_,irfshock_,nperiods_,curb_retrench_,maxiter_,init_)

global M_ oo_



% solve model
eval(['dynare ',modnam_00_,' noclearall nolog'])
oo00_ = oo_;
M00_ = M_;


for i=1:M00_.endo_nbr
   eval([deblank(M00_.endo_names(i,:)) '_ss = oo00_.dr.ys(i); ']);
end

for i_indx_ = 1:M00_.param_nbr
  eval([M00_.param_names(i_indx_,:),'= M00_.params(i_indx_);']);
end

eval(['dynare ',modnam_10_,' noclearall'])
oo10_ = oo_;
M10_ = M_;

eval(['dynare ',modnam_01_,' noclearall'])
oo01_ = oo_;
M01_ = M_;

eval(['dynare ',modnam_11_,' noclearall'])
oo11_ = oo_;
M11_ = M_;


% do some error checking

% check inputs
if ~strcmp(M00_.endo_names,M10_.endo_names)
    error([modnam_00_,' and ',modnam_10_,' need to have exactly the same endogenous variables and they need to be declared in the same order'])
end

if ~strcmp(M00_.exo_names,M10_.exo_names)
    error([modnam_00_,' and ',modnam_10_,' need to have exactly the same exogenous variables and they need to be declared in the same order'])
end

if ~strcmp(M00_.param_names,M10_.param_names)
    warning(['The parameter list does not match across the files ',modnam_00_,' and ',modnam_10_])
end

if ~strcmp(M00_.endo_names,M01_.endo_names)
    error([modnam_00,' and ',modnam_01_,' need to have exactly the same endogenous variables and they need to be declared in the same order'])
end

if ~strcmp(M00_.exo_names,M01_.exo_names)
    error([modnam_00_,' and ',modnam_01_,' need to have exactly the same exogenous variables and they need to be declared in the same order'])
end

if ~strcmp(M00_.param_names,M01_.param_names)
    warning(['The parameter list does not match across the files ',modnam_00_,' and ',modnam_01_])
end

if ~strcmp(M00_.endo_names,M11_.endo_names)
    error([modnam_00_,' and ',modnam_11_,' need to have exactly the same endogenous variables and they need to be declared in the same order'])
end

if ~strcmp(M00_.exo_names,M11_.exo_names)
    error([modnam_00_,' and ',modnam_11_,' need to have exactly the same exogenous variables and they need to be declared in the same order'])
end

if ~strcmp(M00_.param_names,M11_.param_names)
    warning(['The parameter list does not match across the files ',modnam_00_,' and ',modnam_11_])
end

if ~isequal(M00_.lead_lag_incidence,M01_.lead_lag_incidence) || ~isequal(M00_.lead_lag_incidence,M10_.lead_lag_incidence) || ~isequal(M00_.lead_lag_incidence,M11_.lead_lag_incidence)
    error('The lead_lag_incidence-matrix differs across files. In Dynare 4.6, you may need to add a dummy equation tag.')    
end

nvars_ = M00_.endo_nbr;
zdatass_ = oo00_.dr.ys;


[hm1_,h_,hl1_,Jbarmat_] = get_deriv(M00_,zdatass_);
cof_ = [hm1_,h_,hl1_];


M10_.params = M00_.params;
[hm1_,h_,hl1_,Jbarmat10_,resid_] = get_deriv(M10_,zdatass_);
cof10_ = [hm1_,h_,hl1_];
Dbarmat10_ = resid_;

M01_.params = M00_.params;
[hm1_,h_,hl1_,Jbarmat01_,resid_] = get_deriv(M01_,zdatass_);
cof01_ = [hm1_,h_,hl1_];
Dbarmat01_ = resid_;

M11_.params = M00_.params;
[hm1_,h_,hl1_,Jbarmat11_,resid_] = get_deriv(M11_,zdatass_);
cof11_ = [hm1_,h_,hl1_];
Dbarmat11_ = resid_;



[decrulea,decruleb]=get_pq(oo00_.dr,M00_);
endog_ = M00_.endo_names;
exog_ =  M00_.exo_names;


% processes the constrain so as to uppend a suffix to each
% endogenous variables
constraint1_difference_ = process_constraint(constrain1_,'_difference',M00_.endo_names,0);

% when the last argument in process_constraint is set to 1, the
% direction of the inequality in the constraint is inverted
constraint_relax1_difference_ = process_constraint(constraint_relax1_,'_difference',M00_.endo_names,0);


% processes the constrain so as to uppend a suffix to each
% endogenous variables
constraint2_difference_ = process_constraint(constrain2_,'_difference',M00_.endo_names,0);

% when the last argument in process_constraint is set to 1, the
% direction of the inequality in the constraint is inverted
constraint_relax2_difference_ = process_constraint(constraint_relax2_,'_difference',M00_.endo_names,0);



nshocks = size(shockssequence_,1);




if ~exist('init_')
    init_ = zeros(nvars_,1);
end

if ~exist('maxiter_')
    maxiter_ = 20;
end

if ~exist('curb_retrench_')
    curb_retrench_ = 0;
end

init_orig_ = init_;






zdatapiecewise_ = zeros(nperiods_,nvars_);


violvecbool_ = zeros(nperiods_+1,2);  % This sets the first guess for when
% the constraints are going to hold.
% The variable is a boolean with two
% columns. The first column refers to
% constrain1_; the second to
% constrain2_.
% Each row is a period in time.
% If the boolean is true it indicates
% the relevant constraint is expected
% to evaluate to true.
% The default initial guess is
% consistent with the base model always
% holding -- equivalent to the linear
% solution.

wishlist_ = endog_;
nwishes_ = size(wishlist_,1);
for ishock_ = 1:nshocks
    
    
    changes_=1;
    iter_ = 0;
    
    while (changes_ & iter_<maxiter_)
        iter_ = iter_ +1;
        
        % analyse violvec and isolate contiguous periods in the other
        % regime.
        [regime1 regimestart1]=map_regime(violvecbool_(:,1));
        [regime2 regimestart2]=map_regime(violvecbool_(:,2));
        
        
        [zdatalinear_]=mkdatap_anticipated_2constraints(nperiods_,decrulea,decruleb,...
            cof_,Jbarmat_,...
            cof10_,Jbarmat10_,Dbarmat10_,...
            cof01_,Jbarmat01_,Dbarmat01_,...
            cof11_,Jbarmat11_,Dbarmat11_,...
            regime1,regimestart1,...
            regime2,regimestart2,...
            violvecbool_,endog_,exog_,...
            irfshock_,shockssequence_(ishock_,:),init_);
        
        for i_indx_=1:nwishes_
            eval([deblank(wishlist_(i_indx_,:)),'_difference=zdatalinear_(:,i_indx_);']);
        end
        
        
        
        
        newviolvecbool1_ = eval(constraint1_difference_);
        relaxconstraint1_ = eval(constraint_relax1_difference_);
        
        newviolvecbool2_ = eval(constraint2_difference_);
        relaxconstraint2_ = eval(constraint_relax2_difference_);
        
        
        
        newviolvecbool_ = [newviolvecbool1_;newviolvecbool2_];
        relaxconstraint_ = [relaxconstraint1_;relaxconstraint2_];
        
        
        
        % check if changes_
        if (max(newviolvecbool_(:)-violvecbool_(:)>0)) | sum(relaxconstraint_(find(violvecbool_==1))>0)
            changes_ = 1;
        else
            changes_ = 0;
        end
        
        if curb_retrench_   % apply Gauss-Sidel idea of slowing down the change in the guess
            % for the constraint -- only relax one
            % period at a time starting from the last
            % one when each of the constraints is true.
            retrench = 0*violvecbool_(:);
            if ~isempty(find(relaxconstraint1_ & violvecbool_(:,1)))
                retrenchpos = max(find(relaxconstraint1_ & violvecbool_(:,1)));
                retrench(retrenchpos) = 1;
            end
            if ~isempty(find(relaxconstraint2_ & violvecbool_(:,2)))
                retrenchpos = max(find(relaxconstraint2_ & violvecbool_(:,2)));
                retrench(retrenchpos+nperiods_+1) = 1;
            end
            violvecbool_ = (violvecbool_(:) | newviolvecbool_(:))-retrench(:);
        else
            violvecbool_ = (violvecbool_(:) | newviolvecbool_(:))-(relaxconstraint_(:) & violvecbool_(:));
        end
        
        violvecbool_ = reshape(violvecbool_,nperiods_+1,2);
        
        
        
    end
    if changes_ ==1
        display('Did not converge -- increase maxiter')
    end
    
    init_ = zdatalinear_(1,:);
    zdatapiecewise_(ishock_,:)=init_;
    init_= init_';
    
    % update the guess for constraint violations for next period
    % update is consistent with expecting no additional shocks next period
    violvecbool_=[violvecbool_(2:end,:);zeros(1,2)];
    
end


zdatapiecewise_(ishock_+1:end,:)=zdatalinear_(2:nperiods_-ishock_+1,:);

zdatalinear_ = mkdata(nperiods_,decrulea,decruleb,endog_,exog_,wishlist_,irfshock_,shockssequence_,init_orig_);

