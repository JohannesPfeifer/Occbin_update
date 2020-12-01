# zK_TO_Y = BETA*ALPHA/(1-BETA*(1-DK))/XP_SS ;
# zC_TO_Y = (XP_SS-1+(1/BETA-1)*zK_TO_Y*XP_SS+(1-ALPHA))/XP_SS - GBAR  ;
# zN_SS = ((1-ALPHA)/(zC_TO_Y)/XP_SS/XW_SS/TAU)^(1/(1+ETA)) ;
# zYY_SS = (zN_SS) *  zK_TO_Y^(ALPHA/(1-ALPHA)) ;

//% MKT CLEAR
//% 1
exp(c) + exp(k) = exp(w+n)  + (exp(rk+zk)+(1-DK))*exp(k(-1)) + (1-1/exp(xp))*exp(y) - tax*zYY_SS
- b*zYY_SS + exp(r(-1))*b(-1)*zYY_SS ;

//% 2
exp(uc) = BETA*exp(r-dp(+1)+uc(+1)) ;

//% 3
exp(uc)*exp(vk) = BETA * exp(uc(+1)) * ( exp(rk(+1)+zk(+1)) + (1-DK)*exp(vk(+1)) )  ;

//% 4
exp(w+uc-xw) = exp(un) ;

//% Firms

//% 5
y = a_z + (1-ALPHA)*n + ALPHA*(k(-1)+zk) ;

//% 6
log(1-ALPHA) + y - xp - n = w ;

//% 7
log(ALPHA) + y - xp - k(-1) = rk + zk ;

//% 8
dp - LAGP*dp(-1) = BETA*(dp(1) - LAGP*dp) -
((1-TETAP)*(1-BETA*TETAP)/TETAP)*(xp-log(XP_SS))  ;

					  
//% 9
w = (1/(1+BETA))*(w(-1)) + (1-(1/(1+BETA)))*(w(1)+dp(+1))  
- (1+BETA*LAGW)/(1+BETA)*dp + LAGW/(1+BETA)*dp(-1) 
- ((1-TETAW)*(1-BETA*TETAW)/TETAW)/(1+BETA)*(xw-log(XW_SS))  ;


//% 10
rnot = TAYLOR_R*rnot(-1) + (1-TAYLOR_R)*(TAYLOR_P)*dp + (1-TAYLOR_R)*TAYLOR_Y/4*(y-log(zYY_SS)) 
+ (1-TAYLOR_R)*log(1/BETA) ; 


//% DEFINITIONS OF MARGINAL UTILITY OF CONSUMPTION AND LABOR

//% 11
exp(uc) = a_c + ((1-EC)/(1-BETA*EC))*(1/(exp(c)-EC*exp(c(-1))) - BETA*EC/(exp(c(+1))-EC*exp(c)));

//% 12
exp(un) =  TAU*exp(n)^(ETA) ;


//% CAPACITY
//% 13
exp(rk) / ( (1/BETA)-(1-DK) ) = ZETAK/(1-ZETAK)*exp(zk) + (1-ZETAK/(1-ZETAK));

//% 14
exp(ik) = exp(k) - (1-DK)*exp(k(-1)) ;

//% OPTIMALITY CONDITIONS AND DEFINITIONS RELATED TO INVESTMENT ADJUSTMENT COST
//% 15
exp(uc)*exp(vk)*(1-mack) = exp(uc) - BETA * exp(uc(+1))*(mack(+1)) ; 

//% 16
mack = FIK*(exp(ik)-exp(ik(-1))) ;

//% 17 to 19 Scale all govt variables by GDP
a_g*zYY_SS = (1-RHO_AG)*GBAR*zYY_SS + RHO_AG*a_g(-1)*zYY_SS + eps_g*zYY_SS ;
a_g*zYY_SS + exp(r(-1))*b(-1)*zYY_SS = tax*zYY_SS + b*zYY_SS ;
tax*zYY_SS = RHOTAX*tax(-1)*zYY_SS + (1-RHOTAX)*(ETAXB*b(-1)*zYY_SS + ETAXG*a_g*zYY_SS) ;

dp = p - p(-1) ;

//% STOCHASTIC PROCESSES FOR THE ADDITIONAL SHOCKS
a_c = RHO_AC * a_c(-1) + eps_c ;
a_z = RHO_AZ * a_z(-1) + eps_z ;