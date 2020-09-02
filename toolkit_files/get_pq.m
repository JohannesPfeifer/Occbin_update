function [p,q]=get_pq(dr_);

nvars = size(dr_.ghx,1);
nshocks = size(dr_.ghu,2);
statevar_pos = (dr_.nstatic +1):(nvars-dr_.nfwrd);

p = zeros(nvars);
% interlace matrix
nnotzero = length(statevar_pos);
for i=1:nnotzero
    p(:,statevar_pos(i)) = dr_.ghx(:,i);
end

% reorder p matrix according to order in lgy_
inverse_order = zeros(nvars,1);
for i=1:nvars
    inverse_order(i) = find(i==dr_.order_var);
end

p_reordered = zeros(nvars);
q = zeros(nvars,nshocks);
for i=1:nvars
    for j=1:nvars
        p_reordered(i,j)=p(inverse_order(i),inverse_order(j)); 
    end
    q(i,:)=dr_.ghu(inverse_order(i),:); 
end
p=p_reordered;