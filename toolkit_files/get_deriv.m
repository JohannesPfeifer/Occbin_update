function [hm1,h,hl1,j,resid] = get_deriv(M_,ys_)

iy_ = M_.lead_lag_incidence;
it_ = 1;

x = zeros(1,M_.exo_nbr);

% For most models, there are leads, lags and current values of variables
if size(iy_,1)==3
  % find non-zero columns of hm1
  lag_cols = find(iy_(1,:)~=0);
  % find non-zero columns of h
  con_cols = find(iy_(2,:));
  % find non-zero columns of hl1
  lea_cols = find(iy_(3,:));
  
% If models either lacks leads or lags, iy_ will have two rows   
% In this case, we guess that the row with more nonzeros is the row with current variables
elseif size(iy_,1)==2
  % if first row has more nonzero entries than the second, assume model lacks lagged variables 
  if length(find(iy_(1,:)))>length(find(iy_(2,:)))
  warning('Model does not have lagged endogenous variables')
  con_cols = find(iy_(1,:));
  lea_cols = find(iy_(2,:));
  lag_cols = [];
  else
  warning('Model does not have expected future endogenous variables')
  lag_cols = find(iy_(1,:));
  con_cols = find(iy_(2,:));
  lea_cols = [];
  end
  
end
    
  
 
% find number of entries for y vector
ny = length(find(iy_~=0));

% build steady state y
y = ys_(lag_cols);
y = [y;ys_(con_cols)];
y = [y;ys_(lea_cols)];

 
if ismac
eval(['[resid,g1]=',M_.fname,'_dynamic(y,x, M_.params, ys_, it_);']);
% Older versions of DYNARE for Mac did not include ys_ in the call structure    
%eval(['[resid,g1]=',M_.fname,'_dynamic(y,x, M_.params, it_);']);
else
eval(['[resid,g1]=',M_.fname,'_dynamic(y,x, M_.params, ys_, it_);']);
end

 
hm1=zeros(M_.endo_nbr);
h = hm1;
hl1 = hm1;
j = zeros(M_.endo_nbr,M_.exo_nbr);

 
% build hm1
nlag_cols = length(lag_cols);
for i=1:nlag_cols
    hm1(:,lag_cols(i)) = g1(:,i);
end

% build h
ncon_cols = length(con_cols);
for i=1:ncon_cols
    h(:,con_cols(i)) = g1(:,i+nlag_cols);
end

% build hl1
nlea_cols = length(lea_cols);
for i=1:nlea_cols
    hl1(:,lea_cols(i)) = g1(:,i+nlag_cols+ncon_cols);
end

 
for i = 1:M_.exo_nbr;
    j(:,i) =g1(:,i+ny);
end

