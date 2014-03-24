[x,y]=meshgrid(-5:5,-5:5);
z=-(50+10*x+y-6*x.^2-3*y.^2);


figure,surf(x,y,z),figure
[c,h]=contour(x,y,z,10);


clabel(c);


ix=find(z==min(z(:)));
line(x(ix),y(ix),...
 'marker','o',...
 'markersize',10,...
 'markerfacecolor',[1,0,0],...
 'color',[1,0,0]);