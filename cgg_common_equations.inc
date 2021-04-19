[name='IS curve (Equation 2.1 in CGG JEL 1999 paper)']
y = y(+1) - PHI*(r - p(+1)) + g ;

[name='Phillips curve (Equation 2.2 in CGG JEL 1999 paper)']
p = BETA*p(+1) + LAMBDA*y  ;

[name='Aggregate Demand disturbance (Equation 2.3)']
g = RHOG*g(-1) + eps_g;

[name='Interest Rate rule (Equation 7.1)']
rnot = FIR*rnot(-1) + (1-FIR)*(FIP*p + FIY*y) ;
