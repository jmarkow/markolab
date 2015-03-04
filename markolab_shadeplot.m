function markolab_shadeplot(XDATA,YDATA,FACECOLOR,EDGECOLOR,METHOD)
%
%
%

if nargin<5
	METHOD=1
else
	METHOD=2;
end

xdata=XDATA(:)';

xdata=[xdata fliplr(xdata)];
ydata=[YDATA(1,:) fliplr(YDATA(2,:))];

if METHOD==1
	patch(xdata,ydata,1,'facecolor',FACECOLOR,'edgecolor',EDGECOLOR,'facealpha',1,'edgealpha',1);
else
	fill(xdata,ydata,1,'facecolor',FACECOLOR,'edgecolor',EDGECOLOR);
end
