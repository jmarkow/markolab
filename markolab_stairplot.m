function sfield_stairplot(N,BINS,varargin)
%%%% generates a stair plot given histogram data
%
%
%
%


color='r';
linewidth=1;

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
	end
end

% define a polygon to plot as a patch

yvec=[];
xvec=[];

for i=1:length(BINS)-1
	xvec=[xvec BINS(i:i+1)];
	yvec=[yvec repmat(N(i),[1 2])];
end

plot(xvec,yvec,'k-','color',color,'linewidth',linewidth);
