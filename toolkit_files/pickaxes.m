function [x0,x1,y0,y1] = pickaxes(xvalues,yvalues)

x0=xvalues(1);
nobs = length(xvalues);
x1=xvalues(nobs);

maxy = max(yvalues);
miny = min(yvalues);


y0 = miny - .05*abs(miny);
if (miny>0 & y0<0) 
    y0 = 0;
end

y1 = maxy + .05*abs(maxy);
