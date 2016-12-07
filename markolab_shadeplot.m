function H=markolab_shadeplot(XDATA,YDATA,FACECOLOR,EDGECOLOR,METHOD)
% Given x and y data (two stacked vectors for upper and lower limits),
% will generate a shadeplot
%

if nargin<5
	METHOD='patch';
else
	METHOD='fill';
end

if nargin<4 | isempty(EDGECOLOR)
	EDGECOLOR='k';
end

if nargin<3 | isempty(FACECOLOR)
	FACECOLOR=[.4 .4 .4];
end

xdata=XDATA(:)';

xdata=[xdata fliplr(xdata)];
ydata=[YDATA(1,:) fliplr(YDATA(2,:))];

if strcmp(lower(METHOD(1)),'p')
	H=patch(xdata,ydata,1,'facecolor',FACECOLOR,'edgecolor',EDGECOLOR);
else
	H=fill(xdata,ydata,1,'facecolor',FACECOLOR,'edgecolor',EDGECOLOR);
end
