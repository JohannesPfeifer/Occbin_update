[zdatalinear zdatapiecewise zdatass oobase_ Mbase_] = solve_two_constraints(...
                 modnam_00,modnam_10,modnam_01,modnam_11,...
                 constraint1, constraint2,...
                 constraint_relax1, constraint_relax2,...
                 scalefactormod,irfshock,nperiods,curb_retrench,maxiter);

                           
for i=1:Mbase_.endo_nbr
  eval([deblank(Mbase_.endo_names(i,:)),'_uncdifference=zdatalinear(:,i);']);
  eval([deblank(Mbase_.endo_names(i,:)),'_difference=zdatapiecewise(:,i);']);
  eval([deblank(Mbase_.endo_names(i,:)),'_ss=zdatass(i);']);
end

constraint1_difference = process_constraint(constraint1,'_difference',Mbase_.endo_names,0);
constraint2_difference = process_constraint(constraint2,'_difference',Mbase_.endo_names,0);

nparams = size(Mbase_.param_names,1);
 
for i = 1:nparams
   eval([Mbase_.param_names(i,:),'= Mbase_.params(i);']);
end
