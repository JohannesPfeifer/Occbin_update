%% set inputs for solution below
%  The program produces responses to the shocks selected below under
%  irfshock. Paths for all the endogenous variables in the model selected
%  are produced. VariableName_piecewise holds the piece-wise linear solution for
%  VariableName.  VariableName_linear holds the linear solution for
%  VariableName.

global M_ oo_

% modname below chooses model
% directory. But simple param choices are made from paramfile in current
% directory.
modnam = 'cgg';
modnamstar = 'cgg_zlb';


% express the occasionally binding constraint
% in linearized form
% one can use any combination of endogenous variables and parameters 
% declared in the the dynare .mod files
constraint = 'r<(1-1/BETA)'; 
constraint_relax ='rnot>(1-1/BETA)';


% Pick innovation for IRFs
irfshock =char('eps_g');      % label for innovation for IRFs
                             % needs to be an exogenous variable in the
                             % dynare .mod files



  shockssequence = [
    zeros(4,1)
    -0.06
    zeros(20,1)
    0.06
    ];         % scale factor for simulations
  nperiods = size(shockssequence,1)+20;            %length of IRFs

  


% generate model IRFs
[zdatalinear zdatapiecewise zdatass oobase_ Mbase_  ] = ...
  solve_one_constraint(modnam,modnamstar,...
  constraint, constraint_relax,...
  shockssequence,irfshock,nperiods);


                          
% unpack the IRFs                          
for i=1:Mbase_.endo_nbr
  eval([deblank(Mbase_.endo_names(i,:)),'_linear=zdatalinear(:,i);']);
  eval([deblank(Mbase_.endo_names(i,:)),'_piecewise=zdatapiecewise(:,i);']);
  eval([deblank(Mbase_.endo_names(i,:)),'_ss=zdatass(i);']);
end

% Construct interest rate in levels
rlevel_ss=1/BETA-1;
rlevel_piecewise=400*(r_piecewise+rlevel_ss);
rlevel_linear=400*(r_linear+rlevel_ss);



%% Modify to plot IRFs and decision rules

titlelist = char('r (Interest Rate)','p (Inflation)','y (Output)','g (Demand Shock)');


figtitle = '';
line1=[rlevel_piecewise,p_piecewise*400,y_piecewise*100,g_piecewise*100];
line2=[rlevel_linear,p_linear*400,y_linear*100,g_linear*100];


% Figure 1: Plot dynamic simulation
legendlist = cellstr(char('Piecewise Linear','Linear'));
ylabels = char('Percent Level, Annualized','Percent from ss, Annualized','Percent from ss','Percent from ss');
figlabel = '';
makechart(titlelist,legendlist,figlabel,ylabels,line1,line2)

