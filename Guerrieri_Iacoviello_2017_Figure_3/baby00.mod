@#include "common_declarations.inc"

//%------------------------------------------------------------
//% Model equations
//%------------------------------------------------------------

model;
@#include "common_equations.inc"

//% OBC 00
b = bnot;
bnot = (1-RHOD)*M*q*h1+RHOD*b(-1)/dp ;
maxlev = b-bnot;
log(r) = log(rnot) ;
end ;

steady_state_model;
r = PIBAR / BETA ;
rk = 1/BETA - (1-DK) ;
xp = XP_SS ;
xw = XW_SS ;
xw1 = XW_SS ;
lm = (1 - BETA1/BETA) / (1 - BETA1*RHOD/PIBAR) ;

QHTOC_local = JEI/(1-BETA);
QH1TOC1_local = JEI/(1-BETA1-lm*(1-RHOD)*M);
KTOY_local = ALPHA/(xp*rk);
BTOQH1_local = M*(1-RHOD)/(1-RHOD/PIBAR) ;
C1TOY_local = (1-ALPHA)*SIGMA/(1+(1/BETA-1)*BTOQH1_local*QH1TOC1_local)*(1/xp) ;
CTOY_local = (1-C1TOY_local-DK*KTOY_local) ;

n = ((1-SIGMA)*(1-ALPHA)/(xp*xw*CTOY_local))^(1/(1+ETA));
n1 = (SIGMA*(1-ALPHA)/(xp*xw1*C1TOY_local))^(1/(1+ETA));

y = KTOY_local^(ALPHA/(1-ALPHA))*(n^(1-SIGMA))*n1^SIGMA ;

c = CTOY_local*y;
c1 = C1TOY_local*y;
k = KTOY_local*y;
ik = DK*k;

w = xw*c*n^ETA;
w1 = xw1*c1*n1^ETA;
q = QHTOC_local*c + QH1TOC1_local*c1 ;
h = QHTOC_local*c/q ;
h1 = QH1TOC1_local*c1/q ;
b = BTOQH1_local*q*h1 ;
uc = 1/c;
uc1 = 1/c1;
uh = JEI/h;
uh1 = JEI/h1;
un = n^ETA ;
un1 = n1^ETA ;
dp = PIBAR ;
dp1 = dp;
dp2 = dp;
dp3 = dp;
dw = PIBAR ;
dw1 = PIBAR ;
aa = 1;
af=1;
aj = 1 ;
am = 1;
arr =1;
az = 1;
ak=1;
ap=1;
aw=1;
an=1;

qk = 1;
rnot = r;

lev = b/(q*h1);
bnot = b;
maxlev = 0;

data_ctot = 0 ;
data_ik = 0;   
data_q = 0;
data_r = 0; 
data_rnot = 0;
data_dp = 0 ;
data_dwtot =0;
data_ntot=0;
  
z_j=0;
end;



//%------------------------------------------------------------
//% Declare shocks
//%------------------------------------------------------------

//shocks;
// var eps_j ; stderr 0.0643  ;
// var eps_k ; stderr 0.0078  ;
// var eps_p ; stderr 0.0002  ;
// var eps_r ; stderr 0.0001  ;
// var eps_w ; stderr 0.0083  ;
// var eps_z ; stderr 0.0075  ;
//end;

stoch_simul(order=1,irf=0,noprint,nomoments) c1 data_ctot data_ik ;