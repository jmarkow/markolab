function [BOX_HANDLE,MED_HANDLE,WHISK_HANDLE]=markolab_boxplot(DATA,GRPS,varargin)
%%%% generates a stair plot given histogram data
%
%
%
%

if nargin<3, CATS=[]; end
if nargin<2, GRPS=[]; end

color='r';
linewidth=1;
outliers=0;
adjacent=0;
fill_box=1;
med_color=[0 0 1;1 0 0];
box_color=[1 0 0;0 0 1];
med_width=1;
bunching=[];
bunching_offset=2;
feature_idx=[];
box_width=.8;
linewidth=.5

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
		case 'feature_idx'
			feature_idx=varargin{i+1};
		case 'bunching'
			bunching=varargin{i+1};
		case 'bunching_offset'
			bunching_offset=varargin{i+1};
		case 'box_width'
			box_width=varargin{i+1};
	end
end

if isempty(GRPS) & ~iscell(DATA)
	GRPS=ones(size(DATA));
end

% number of styles corresponds to number of grps

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
elseif isempty(GRPS)
	GRPS=ones(size(DATA,2));
end



uniq_grps=unique(GRPS);
ngrps=length(uniq_grps);
if isempty(feature_idx)
	feature_idx=ones(1,ngrps);
end

uniq_features=unique(feature_idx);
nfeatures=length(uniq_features);

if nfeatures>1 & (ischar(med_color) | ischar(box_color))
	error('Need to specify multiple colors using n x 3 matrix');
end

% define a polygon to plot as a patch

% TODO: prettify colors, custom spacing, etc.

% use positions property, compact style, etc.

pos_idx=ones(1,ngrps);
if ~isempty(bunching)
	pos_idx(1:bunching:length(pos_idx))=bunching_offset;
end
pos_idx=cumsum([pos_idx]);
boxplot(DATA,GRPS,'positions',pos_idx,'width',box_width)
hold on;

WHISK_HANDLE=findobj(gcf,'-regexp','Tag','\w*Whisker');
BOX_HANDLE=findobj(gca,'tag','Box');
MED_HANDLE=findobj(gca,'tag','Median');

set(WHISK_HANDLE,'LineStyle','-');
if fill_box

	for i=1:nfeatures
		idx=find(feature_idx==uniq_features(i));
		for j=1:length(idx)	
			patch(get(BOX_HANDLE(idx(j)),'XData'),get(BOX_HANDLE(idx(j)),'YData'),box_color(i,:),'edgecolor','k','linewidth',linewidth);
			plot(get(MED_HANDLE(idx(j)),'XData'),get(MED_HANDLE(idx(j)),'YData'),'k-','color',med_color(i,:),'linewidth',med_width);
			%set(WHISK_HANDLE([idx(j) idx(j)+ngrps]),'color',box_color(i,:));
		end
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
