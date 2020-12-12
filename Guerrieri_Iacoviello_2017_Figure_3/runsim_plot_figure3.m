close all
clearvars
clear global

addpath('../toolkit_files/')
modnam_00 = 'baby00'; % base model (constraint 1 and 2 below don't bind)
modnam_10 = 'baby10'; % first constraint is true
modnam_01 = 'baby01'; % second constraint is true
modnam_11 = 'baby11'; % both constraints bind

% compile constraint
constraint1 = 'lm<-lm_ss';
constraint_relax1 = 'maxlev > 0';
constraint2 = 'rnot < -log(r_ss)';
constraint_relax2 = 'r > -log(r_ss)';


curb_retrench = 0;           % if 1 slow down relaxation of constraints
maxiter = 10;                % number of iterations allowed to look for a solution

irfshock =char('eps_j');
nper1=7;
nper2=30;
sizeshock1=0.8420;
sizeshock2=0.8067;

for indi = 1:2
    if indi ==1
        sequence = [ zeros(1,1)
            repmat(sizeshock1/nper1,[nper1 1])
            repmat(-0.00,[nper2 1]) ];
    else
        sequence = -[ zeros(1,1)
            repmat(sizeshock2/nper1,[nper1 1])
            repmat(-0.00,[nper2 1]) ];
    end    
    nperiods = numel(sequence);

    [zdatal, zdatap, zdatass, oobase_, Mbase_] = solve_two_constraints(...
        modnam_00,modnam_10,modnam_01,modnam_11,...
        constraint1, constraint2,...
        constraint_relax1, constraint_relax2,...
        sequence,irfshock,nperiods+50,curb_retrench,maxiter);

    for i=1:Mbase_.endo_nbr
        eval([Mbase_.endo_names{i,:},'_l=zdatal(1:nperiods,i);']);
        eval([Mbase_.endo_names{i,:},'_p=zdatap(1:nperiods,i);']);
        eval([Mbase_.endo_names{i,:},'_ss=zdatass(i);']);
    end
    
    for i = 1:size(Mbase_.param_names,1)
        eval([Mbase_.param_names{i,:},'= Mbase_.params(i);']);
    end
    
    ctot_ss = c_ss + c1_ss;
    ctot_l = c_l + c1_l;
    ctot_p = c_p + c1_p;
    lev_p = (exp(b_p/b_ss)*b_ss)./(exp(q_p/q_ss)*q_ss)./(exp(h1_p/h1_ss)*h1_ss);
    levagg_p = (exp(b_p/b_ss)*b_ss)./(exp(q_p/q_ss)*q_ss);
    lev_l = (exp(b_l/b_ss)*b_ss)./(exp(q_l/q_ss)*q_ss)./(exp(h1_l/h1_ss)*h1_ss);
      
    
    line1(:,:,indi)=100*[
        4*(r_p),...
        y_p/y_ss,...
        q_p/q_ss,...
        ctot_p/ctot_ss,...
        c_p/c_ss,...
        c1_p/c1_ss,...
        ik_p/ik_ss,...
        (lm_p+lm_ss),...
        data_ntot_p ];
    line2(:,:,indi)=100*[
        4*(r_l),...
        y_l/y_ss,...
        q_l/q_ss,...
        ctot_l/ctot_ss,...
        c_l/c_ss,...
        c1_l/c1_ss,...
        ik_l/ik_ss,...
        (lm_l+lm_ss),...
        data_ntot_l];
     
end


figure
subplot(2,2,1)
plot(squeeze(line1(:,3,[1])),'b');  hold on
plot(squeeze(line1(:,3,[2])),'r--');
ylim([-32 32])
grid on
title({'House Prices','% from steady state'})
hold on; plot(0*r_l,'k','Linewidth',1)

subplot(2,2,2)
plot(squeeze(line1(:,4,[1])),'b');  hold on
plot(squeeze(line1(:,4,[2])),'r--');
ylim([-4.0 4.0])
title({'Consumption','% from steady state'})
hold on; plot(0*r_l,'k','Linewidth',1)
grid on


subplot(2,2,3)
plot(squeeze(line1(:,9,[1])),'b');  hold on
plot(squeeze(line1(:,9,[2])),'r--');
ylim([-3 3])
title({'Total Hours','% from steady state'})
hold on; plot(0*r_l,'k','Linewidth',1)
grid on


subplot(2,2,4)
plot(squeeze(line1(:,8,[1])/100),'b');  hold on
plot(squeeze(line1(:,8,[2])/100),'r--');
ylim([-0.1 0.1])
title({'Multiplier on Borrowing Constraint','level'})
hold on; plot(0*r_l,'k','Linewidth',1)
legend('House Price Increase','House Price Decrease')
grid on