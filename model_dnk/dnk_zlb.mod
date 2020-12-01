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
r = 0;
end ;
