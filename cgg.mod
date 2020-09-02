//% Three equations DNK model 
var g, r, rnot, p, y;
varexo eps_g ;

parameters LAMBDA BETA FIP SIGMAG FIY FIR PHI RHOG;

LAMBDA=0.04;
BETA=0.9925;
FIP=4;
FIY=4;
FIR=0.8;
PHI=1;
SIGMAG=0.06;
RHOG=0.5;

model(linear);
//% IS curve (Equation 2.1 in CGG JEL 1999 paper)
y = y(+1) - PHI*(r + p(+1)) + g ;

//% Phillips curve (Equation 2.2 in CGG JEL 1999 paper)
p = BETA*p(+1) + LAMBDA*y  ;

//% Aggregate Demand disturbance (Equation 2.3)
g = RHOG*g(-1) + eps_g;

//% Interest Rate rule (Equation 7.1)
rnot = FIR*rnot(-1) + (1-FIR)*(FIP*p + FIY*y) ;
r = rnot;

end;

initval;
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