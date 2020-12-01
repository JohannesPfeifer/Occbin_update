
//% A simple new-keynesian model with government spending

warning off;

//%------------------------------------------------------------
//% Declare endogenous and exogenous variables
//%------------------------------------------------------------

@#include "DNK_declarations_common.inc"

//%------------------------------------------------------------
//% Model equations
//%------------------------------------------------------------

model;
@#include "DNK_model_common.inc"

r = rnot;

end ;


//%------------------------------------------------------------
//% Call steady state
//%------------------------------------------------------------

steady_state_model;
r = 1 / BETA ;
rk = r - (1-DK) ;

K_TO_Y = BETA*ALPHA/(1-BETA*(1-DK))/XP_SS ;
C_TO_Y = (XP_SS-1+(r-1)*K_TO_Y*XP_SS+(1-ALPHA))/XP_SS - GBAR  ;
n = ((1-ALPHA)/(C_TO_Y)/XP_SS/XW_SS/TAU)^(1/(1+ETA)) ;
y = (n) *  K_TO_Y^(ALPHA/(1-ALPHA)) ;
k = K_TO_Y*y ;
c = C_TO_Y*y  ;
uc = 1/c;
un = TAU*n^ETA;
w = (1-ALPHA)*y/XP_SS/n ;

ik = DK * k ;
dp = 0 ;
zk = 0;
xw = XW_SS;
xp = XP_SS;
mack = 0;
vk = 0;
a_z=0;
a_g=GBAR ;
a_c=0;

b=(1-ETAXG)/(ETAXB+1-r)*a_g ;
tax=ETAXB*b+ETAXG*a_g;
p = 0;

c=log(c);
ik=log(ik);
k=log(k);
n=log(n);
r=log(r);
rnot=r;
rk=log(rk);
uc=log(uc);
un=log(un);
w=log(w);
xp=log(xp);
xw=log(xw);
y=log(y);
end;

resid;
steady;

//resid(1);


//%------------------------------------------------------------
//% Declare shocks
//%------------------------------------------------------------

shocks;
var eps_c ; stderr 0.01  ;
var eps_g ; stderr 0.01  ;
var eps_z ; stderr 0.01  ;
end;

stoch_simul(order=1,irf=0,periods=1000)   ;
