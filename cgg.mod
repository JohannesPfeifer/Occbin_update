//% Three equations DNK model 
@#include "cgg_common_declarations.inc"

LAMBDA=0.04;
BETA=0.9925;
FIP=4;
FIY=4;
FIR=0.8;
PHI=1;
SIGMAG=0.06;
RHOG=0.5;

model(linear);
@#include "cgg_common_equations.inc"
r = rnot;
end;

steady_state_model;
y = 0;
g = 0;
r = 0;
p = 0;
rnot = 0;
end;

steady;

shocks;
var eps_g; stderr SIGMAG;
end;

stoch_simul(order=1,nocorr,nomoments,irf=0);						  