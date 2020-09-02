function makechart9(titlelist,legendlist,figlabel,yearshock,ylabels,...
    zdata1,zdata2,zdata3,zdata4,zdata5,zdata6,zdata7)



figure

titlelist = char(strrep(cellstr(titlelist),'_','.'));

ndsets=7;       % default, changed below as applicable
if nargin==6
    zdata2=nan*zdata1;
    zdata3=nan*zdata1;
    zdata4=nan*zdata1;
    zdata5=nan*zdata1;
    zdata6=nan*zdata1;
    zdata7=nan*zdata1;
    ndsets =1;
elseif nargin==7
    zdata3=nan*zdata1;
    zdata4=nan*zdata1;
    zdata5=nan*zdata1;
    zdata6=nan*zdata1;
    zdata7=nan*zdata1;
    ndsets =2;
elseif nargin == 8
    zdata4 =nan*zdata1;
    zdata5 =nan*zdata1;
    zdata6=nan*zdata1;
    zdata7=nan*zdata1;
    ndsets=3;
elseif nargin == 9
    zdata5 =nan*zdata1;
    zdata6=nan*zdata1;
    zdata7=nan*zdata1;
    ndsets=4;
elseif nargin == 10
    zdata6 =nan*zdata1;
    zdata7=nan*zdata1;
    ndsets=5;
elseif nargin == 11
    zdata7=nan*zdata1;
    ndsets=6;
elseif ((nargin>=13) | (nargin <=3))
    error ('makechart takes 4 to 10 arguments')
end

nobs = size(zdata1,1);

if yearshock>-100
xvalues = yearshock+(0:nobs-1)'/4; % Matteo plot year on x axis
else
xvalues = (1:nobs)'; % Matteo plot year on x axis
end

nvars = size(titlelist,1);
if nvars==1 
    nrows=1;
    ncols = 1;
elseif nvars==2
    nrows =2;
    ncols = 1;
elseif nvars == 3 
    nrows = 3;
    ncols = 1;
elseif nvars==4 
    nrows = 2;
    ncols = 2;
elseif (nvars==5 | nvars ==6)
     nrows = 3;
    ncols = 2; 
elseif (nvars==7 | nvars==8)
    nrows = 4;
    ncols = 2;
elseif nvars>8 & nvars<=12;
    nrows = 3;
    ncols = 4;
elseif nvars>12 & nvars<=15;
    nrows = 5;
    ncols = 3;
else 
    error('too many variables (makechart)')
end


for i = 1:nvars
    subplot(nrows,ncols,i)
    h1=plot(xvalues,zdata1(:,i),'k',...
        xvalues,zdata2(:,i),'r',...
        xvalues,zdata3(:,i),'b',...
        xvalues,zdata4(:,i),'g',...
        xvalues,zdata5(:,i),'g',...
        xvalues,zdata6(:,i),'c',...
        xvalues,zdata7(:,i),'y');
    [x0 x1 y10 y11] = pickaxes(xvalues,zdata1(:,i));
    [x0 x1 y20 y21] = pickaxes(xvalues,zdata2(:,i));
    [x0 x1 y30 y31] = pickaxes(xvalues,zdata3(:,i));
    [x0 x1 y40 y41] = pickaxes(xvalues,zdata4(:,i));
    [x0 x1 y50 y51] = pickaxes(xvalues,zdata5(:,i));
    [x0 x1 y60 y61] = pickaxes(xvalues,zdata6(:,i));
    [x0 x1 y70 y71] = pickaxes(xvalues,zdata7(:,i));
     grid on
    y0 = min([y10,y20,y30,y40,y50,y60,y70]);
    y1 = max([y11,y21,y31,y41,y51,y61,y71]);
    if y0==y1
        y1=y0+1;
    end
    
    axis([x0 x1 y0 y1])
    set(h1,'linewidth',2);
    if i==1
      if numel(strvcat(legendlist(1,:)))
        h=legend(legendlist,'Location','Northwest');
        set(h,'Fontsize',8)
      end
    end
    if i==1
        if nvars>3
        text('String',figlabel,'Units','normalized','Position',[1.2 1.21],...
       'FontSize',13,'FontWeight','bold','HorizontalAlignment','center');
        else
        text('String',figlabel,'Units','normalized','Position',[0.4 1.24],...
       'FontSize',13,'FontWeight','bold','HorizontalAlignment','center');
        end
    end
 
    %set(gca,'XTick',xtick)
    %set(gca,'XTickLabel',xticklabel)
    
    title(titlelist(i,:),'Fontsize',11);
    ylabel(ylabels(i,:))

end

% sets printing preferences
%printpref
