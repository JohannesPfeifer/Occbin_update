function [zdata]=mkdata(nperiods,decrulea,decruleb,endog_,exog_,wishlist,irfshock,scalefactormod,init)

%[nsim, ksim, ysim, isim, csim] = mkdata(nperiods,cofb,endog_)

% given decision rule 
neqs = size(endog_,1);

if  nargin<9
   init = zeros(neqs,1);
end

if  nargin<8
    scalefactormod=1;
end

if nargin<7
    error('Not enough inputs')
end

history = zeros(neqs,nperiods+1);

    nshocks = size(irfshock,1);
    for i = 1:nshocks
        shockpos = strmatch(irfshock(i,:),exog_,'exact');
        if ~isempty(shockpos)
            irfshockpos(i) = shockpos;
        else
            error(['Shock ',irfshock(i,:),' is not in the model']);
        end
    end


% generate data
% history will contain data, the state vector at each period in time will
% be stored columnwise.
history = zeros(neqs,nperiods);
history(:,1)= init;

lengthshock = size(scalefactormod,1);

errvec = zeros(size(exog_,1),1);

for i = 2:nperiods+1
    if i<=(lengthshock+1)
        for j = 1:nshocks
            errvec(irfshockpos(j)) = scalefactormod(i-1,j);
        end
        history(:,i) = decrulea * history(:,i-1)+decruleb*errvec;
    else
    % update endogenous variables
    history(:,i) = decrulea * history(:,i-1);
    end
end

% extract desired variables
nwish=size(wishlist,1);
wishpos = zeros(nwish,1);

history=history';
for i=1:nwish
    wishpos(i) = strmatch(wishlist(i,:),endog_,'exact');
end
zdata = history(2:end,wishpos);