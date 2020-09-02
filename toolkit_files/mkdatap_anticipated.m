function [zdata]=mkdatap_anticipated(nperiods,decrulea,decruleb,...
    cof,Jbarmat,cofstar,Jstarbarmat,Dstarbarmat,...
    regime,regimestart,violvecbool,...
    endog_,exog_,irfshock,scalefactormod,init)



nvars = size(endog_,1);


if nargin<16
    init=zeros(nvars,1);
end

if nargin<15;
    scalefactormod=1;
end


nshocks = size(irfshock,1);
for i = 1:nshocks
    shockpos = strmatch(irfshock(i,:),exog_,'exact');
    if ~isempty(shockpos)
        irfshockpos(i) = shockpos;
    else
        error(['Shock ',irfshock(i,:),' is not in the model']);
    end
end


nregimes = length(regime);

Cbarmat = cof(:,1:nvars);
Bbarmat = cof(:,nvars+1:2*nvars);
Abarmat = cof(:,2*nvars+1:3*nvars);


% cofstar contains the system for the model when the constraint binds
Cstarbarmat = cofstar(:,1:nvars);
Bstarbarmat = cofstar(:,nvars+1:2*nvars);
Astarbarmat = cofstar(:,2*nvars+1:3*nvars);

% get the time-dependent decision rules

Tmax = regimestart(nregimes)-1;  % Tmax is the position of the last period
% when the constraint binds

if Tmax > 0
    P = zeros(nvars,nvars,Tmax);
    D = zeros(nvars,Tmax);
    
    
    invmat = inv((Astarbarmat*decrulea+Bstarbarmat));
    P(:,:,Tmax) = -invmat*Cstarbarmat;
    D(:,Tmax) = -invmat*Dstarbarmat;
    
    
    % equivalent to pre-multiplying by the inverse above if the target
    % matrix is invertible. Otherwise it yields the minimum state solution
    %P(:,:,Tmax) = -(Astarbarmat*decrulea+Bstarbarmat)\Cstarbarmat;
    %D(:,Tmax) = -(Astarbarmat*decrulea+Bstarbarmat)\Dstarbarmat;
    
 
    for i = Tmax-1:-1:1
        
        if violvecbool(i)
            invmat = inv(Bstarbarmat+Astarbarmat*P(:,:,i+1));
            P(:,:,i)=-invmat*Cstarbarmat;
            D(:,i) = -invmat*(Astarbarmat*D(:,i+1)+Dstarbarmat);
        else
            invmat = inv(Bbarmat+Abarmat*P(:,:,i+1));
            P(:,:,i)=-invmat*Cbarmat;
            D(:,i) = -invmat*(Abarmat*D(:,i+1));
        end
    end

if Tmax > 1    
if violvecbool(1)
    E = -invmat*Jstarbarmat;
else
    E = -invmat*Jbarmat;
end
else
    invmat = inv(Astarbarmat*decrulea+Bstarbarmat);
    E = -invmat*Jstarbarmat;

end

    
end

% generate data
% history will contain data, the state vector at each period in time will
% be stored columnwise.
history = zeros(nvars,nperiods+1);
history(:,1) = init;
errvec = zeros(size(exog_,1),1);

% deal with predetermined conditions
for i = 1:nshocks
    errvec(irfshockpos(i)) = scalefactormod(i);
end

% deal with shocks
irfpos =1;
if irfpos <=Tmax
    history(:,irfpos+1) = P(:,:,irfpos)* history(:,irfpos)+...
        D(:,irfpos) + E*errvec;
else
    history(:,irfpos+1) = decrulea*history(:,irfpos)+decruleb*errvec;
end

% all other periods
for irfpos=2:nperiods+1
    if irfpos <=Tmax
        history(:,irfpos+1) = P(:,:,irfpos)* history(:,irfpos)+...
            D(:,irfpos);
    else
        history(:,irfpos+1) = decrulea*history(:,irfpos);
    end
end


history=history';
zdata = history(2:end,:);