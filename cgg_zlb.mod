//% Three equations DNK model 
var g, r, rnot, p, y;
varexo eps_g ;

parameters LAMBDA BETA FIP SIGMAG FIY FIR PHI RHOG;


model(linear);
//% IS curve (Equation 2.1 in CGG JEL 1999 paper)
y = y(+1) - PHI*(r + p(+1)) + g ;

//% Phillips curve (Equation 2.2 in CGG JEL 1999 paper)
p = BETA*p(+1) + LAMBDA*y  ;

//% Aggregate Demand disturbance (Equation 2.3)
g = RHOG*g(-1) + eps_g;

//% Interest Rate rule with ZLB
rnot = FIR*rnot(-1) + (1-FIR)*(FIP*p + FIY*y) ;
r = -(1/BETA-1);

end;

						  