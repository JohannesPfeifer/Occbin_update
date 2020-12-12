//%------------------------------------------------------------
//% Declare endogenous and exogenous variables
//%------------------------------------------------------------

var
aj
ak
ap
arr
aw
az
b    
bnot
c    
c1
data_ctot
data_dp
data_dwtot
data_ik   
data_ntot
data_q
data_r
data_rnot   
dp   
dp1
dp2
dp3
dw
dw1
h1
ik
k
lm
maxlev
n    
n1  
q
qk
r    
rk
rnot
uc   
uc1  
uh
uh1
w    
w1
xp
xw
xw1
y
z_j ;

varexo 
eps_j
eps_k
eps_p
eps_r
eps_w
eps_z ;


//%-----------------------------------------------------------------------
//% Declare model parameters
//%------------------------------------------------------------------------

parameters BETA BETA1 EC EH ETA JEI M ALPHA PHIK DK LAGP LAGW PIBAR INDTR
SIGMA TAYLOR_P TAYLOR_Q TAYLOR_R TAYLOR_Y TETAP TETAW XP_SS XW_SS 
RHO_J RHO_K RHO_P RHO_R RHO_W RHO_Z
STD_J STD_K STD_P STD_R STD_W STD_Z RHO_J2 RHOD ITAYLOR_W ;

BETA1      =0.9922;  
EC         =0.6842; 
EH         =0.8799; 
PHIK       =4.1209;
SIGMA      =0.5013; 
TAYLOR_P   =1.7196; 
TAYLOR_R   =0.5509; 
TAYLOR_Y   =0.0944; 
TETAP      =0.9182; 
TETAW      =0.9163;
RHOD       =0.6945; 
RHO_J      =0.9835;  
RHO_K      =0.7859; 
RHO_R      =0.6232;  
RHO_Z      =0.7556; 
STD_J      =0.0737;   
STD_K      =0.0360;  
STD_P      =0.0030;
STD_R      =0.0013;  
STD_W      =0.0100;  
STD_Z      =0.0163; 
 
ALPHA   =   0.300000;
BETA    =   0.995000;
DK      =   0.025000;
ETA     =   1.000000;
JEI     =   0.040000;
LAGP    =   0.000000;
LAGW    =   0.000000;
M       =   0.900000;
PIBAR   =   1.005000;
RHO_P   =   0.000000;
RHO_W   =   0.000000;
XP_SS   =   1.200000;
XW_SS   =   1.200000;

INDTR = 0;
TAYLOR_Q = 0;
ITAYLOR_W = 0;
RHO_J2 = 0;