function [zdata_, oobase_, Mbase_ ] = ...
    solve_no_constraint(modnam,...
    shockssequence,irfshock,nperiods)

global M_ oo_

errlist = [];

% solve model
eval(['dynare ',modnam,' noclearall'])
oobase_ = oo_;
Mbase_ = M_;

ys_ = oobase_.dr.ys;

for i=1:Mbase_.endo_nbr
  eval([deblank(Mbase_.endo_names(i,:)) '_ss = oo_.dr.ys(i); ']);
end

for i = 1:size(Mbase_.param_names)
  eval([Mbase_.param_names(i,:),'= M_.params(i);']);
end







[hm1,h,hl1,Jbarmat] = get_deriv(Mbase_,ys_);
cof = [hm1,h,hl1];

[decrulea,decruleb]=get_pq(oobase_.dr,Mbase_);
endog_ = M_.endo_names;
exog_ =  M_.exo_names;



nvars = numel(Mbase_.endo_nbr);

nshocks = size(shockssequence,1);
init = zeros(nvars,1);

wishlist = endog_;
nwishes = size(wishlist,1);


zdata = mkdata(nperiods,decrulea,decruleb,endog_,exog_,wishlist,irfshock,shockssequence);

