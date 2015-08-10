function sfield_stairplot(DATA,GRPS,varargin)
%%%% generates a stair plot given histogram data
%
%
%
%

if nargin<2, GRPS=[]; end
color='r';
linewidth=1;
outliers=0;
adjacent=0;
fill_box=1;

nparams=length(varargin);

if mod(nparams,2)>0
	error('ephysPipeline:argChk','Parameters must be specified as parameter/value pairs!');
end

for i=1:2:nparams
	switch lower(varargin{i})
		case 'color'
			color=varargin{i+1};
		case 'linewidth'
			linewidth=varargin{i+1};
		case 'outliers'
			outliers=varargin{i+1};
		case 'adjacent'
			adjacent=varargin{i+1};
		case 'fill_box'
			fill_box=varargin{i+1};
	end
end

if isempty(GRPS) & ~iscell(DATA)
	GRPS=ones(size(DATA));
end


if iscell(DATA)

	tmp=[];
	GRPS=[];
	for i=1:length(DATA)
		tmp2=DATA{i}(:);
		tmp=[tmp;tmp2];
		GRPS=[GRPS;ones(size(tmp2))*i];
	end

	clear DATA;
	DATA=tmp;

end


size(DATA)
size(GRPS)

% define a polygon to plot as a patch

% TODO: prettify colors, custom spacing, etc.

% use positions property, compact style, etc.

boxplot(DATA,GRPS)
set(findobj(gcf,'-regexp','Tag','\w*Whisker'),'LineStyle','-');

if fill_box
	h=findobj(gca,'tag','Box');

	for j=1:length(h)
		patch(get(h(j),'XData'),get(h(j),'YData'),[.6 .6 .6],'FaceAlpha',.5);
	end
end

if ~adjacent
	h=findobj(gcf,'-regexp','Tag','\w*Adjacent');
	delete(h);
end

if ~outliers
	h=findobj(gca,'tag','Outliers');
	delete(h);
end
