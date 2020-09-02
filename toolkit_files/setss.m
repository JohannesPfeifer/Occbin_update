% Script that retrieves parameter values once model is solved

nendog = size(Mbase_.endo_names,1);

for i=1:nendog
  eval([deblank(Mbase_.endo_names(i,:)) '_ss = oo_.dr.ys(i); ']);
end

nparams = size(Mbase_.param_names);

for i = 1:nparams
  eval([Mbase_.param_names(i,:),'= M_.params(i);']);
end

