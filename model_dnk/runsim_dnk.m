%---------------------------------------------------------------------
% Simple model to compare government spending multipliers at the ZLB
%---------------------------------------------------------------------

clear
close all
set(0,'DefaultLineLineWidth',2)

%---------------------------------------------------------------------
% To compute multipliers at ZLB, solve two models
% simulation 1 is baseline  that takes us at the ZLB
% simulation 2 is baseline simulation that takes us at the ZLB plus G shock
%---------------------------------------------------------------------

nperiods=30;
maxiter=20;

% Pick color of charts
solution=1;

irfshock = char('eps_c','eps_g'); % Shocks we look at: preference and g-shock

% simulation 1 is a simulation with a zero baseline
baseline1=[ 0     0      0       0        0       0
  0.00  0.00   0.00    0.00     0.00    0.0 ]';

% In both models, there is a positive G shock in period 6
scenario1=[ 0     0      0       0        0       0
  0.00  0.00   0.00    0.00     0.00    0.01   ]';

modnam = 'dnk';
modnamstar = 'dnk_zlb';

constraint = 'r<-(1/BETA-1)';
constraint_relax ='rnot>-(1/BETA-1)';

% First time we solve simulation only with baseline shocks
[zdatabaseline_lin1 zdatabaseline_pie1 zdatass oobase_ Mbase_] = ...
  solve_one_constraint(modnam,modnamstar,...
  constraint, constraint_relax,...
  baseline1,irfshock,nperiods,maxiter);

% Second time we solve simulation with baseline shocks and scenario
[zdatascenario_lin1 zdatascenario_pie1 zdatass oobase_ Mbase_ ] = ...
  solve_one_constraint(modnam,modnamstar,...
  constraint, constraint_relax,...
  baseline1+scenario1,irfshock,nperiods,maxiter);

% Pick color of charts
simulation=2;

irfshock = char('eps_c','eps_g'); % Shocks we look at: preference and g-shock

baseline2=[   -0.04  -0.04   -0.04    -0.04      0   0
  0.00   0.00   0.00     0.00     0.0   0.0  ]';

% In both simulations, there is a positive G shock in period 6
scenario2=scenario1;

% First time we solve simulation only with baseline shocks
[zdatabaseline_lin2 zdatabaseline_pie2 zdatass oobase_ Mbase_] = ...
  solve_one_constraint(modnam,modnamstar,...
  constraint, constraint_relax,...
  baseline2,irfshock,nperiods,maxiter);

% Second time we solve simulation with baseline shocks and scenario
[zdatascenario_lin2 zdatascenario_pie2 zdatass oobase_ Mbase_ ] = ...
  solve_one_constraint(modnam,modnamstar,...
  constraint, constraint_relax,...
  baseline2+scenario2,irfshock,nperiods,maxiter);

% Note that we compute impulse responses in deviation from baseline
% In simulation=1, baseline1 has a no negative preference shock
% In simulation=2, baseline2 has a negative preference shock that takes economy to ZLB
for i=1:Mbase_.endo_nbr
  eval([Mbase_.endo_names{i,:},'1 = zdatascenario_pie1(:,i)-zdatabaseline_pie1(:,i);']);
  eval([Mbase_.endo_names{i,:},'2 = zdatascenario_pie2(:,i)-zdatabaseline_pie2(:,i);']);
end

titlelist = char('Output','G/Y','Interest rate','Consumption','Investment');

ylabels = char('percent deviation from baseline',...
  '% of GDP, deviation from baseline',...
  'ppoints deviation from baseline, annualized',...
  'percent deviation from baseline',...
  'percent deviation from baseline');

figtitle = '';
line1=100*[y1,a_g1,4*r1,c1,ik1];
line2=100*[y2,a_g2,4*r2,c2,ik2];

legendlist = cellstr(char('No ZLB','ZLB binds'));
figlabel = '';
makechart(titlelist,legendlist,figlabel,ylabels,line1,line2)