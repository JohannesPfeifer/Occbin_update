var
a_c
a_g
a_z
b
c
dp
ik 
k
mack
n
p
r
rk
rnot
tax
uc
un
vk
w
xp
xw
y
zk ;

varexo 
eps_c
eps_g 
eps_z ;


//%-----------------------------------------------------------------------
//% Declare model parameters
//%------------------------------------------------------------------------

parameters BETA ALPHA DK ETA EC FIK 
TETAP TAYLOR_R TAYLOR_Y TAYLOR_P  XP_SS LAGP 
 XW_SS TETAW LAGW ZETAK GBAR
RHO_AG RHO_AZ RHO_AC TAU ETAXB ETAXG RHOTAX YY_SS CHI  ;


XP_SS = 1.01 ;
XW_SS = 1.01 ;
BETA = 0.9925 ;
ALPHA = 0.35; 
DK = 0.03; 
CHI = 0.05;

GBAR = 0.2 ; 
EC	=	0.5	;
ETA	=	1	;
FIK	=	10	;
LAGP	=	0.8	;
LAGW	=	0.8	;
RHO_AZ	=	0.99999999999	;
RHO_AG	=	0.9	;
RHO_AC	=	0.9	;
TAYLOR_P	=	1.5	;
TAYLOR_R	=	0.75	;
TAYLOR_Y	=	1.0	;
TETAP	=	0.90	;
TETAW	=	0.90	;
ZETAK	=	0.9999	;
STDERR_AC = 0.01	;
STDERR_AG	=	0.01	;
STDERR_AZ	=	0.01	;
RHOTAX = 0;
ETAXB = 0.02;
ETAXG = 0.9;
TAU = 1;

%load PARAM_EXTRA
K_TO_Y = BETA*ALPHA/(1-BETA*(1-DK))/XP_SS ;
C_TO_Y = (XP_SS-1+(1/BETA-1)*K_TO_Y*XP_SS+(1-ALPHA))/XP_SS - GBAR  ;
N_SS = ((1-ALPHA)/(C_TO_Y)/XP_SS/XW_SS/TAU)^(1/(1+ETA)) ;
YY_SS = (N_SS) *  K_TO_Y^(ALPHA/(1-ALPHA)) ;
