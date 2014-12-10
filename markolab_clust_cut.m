function [FIGNUM,LABELS]=markolab_clust_cut(FEATURES,FEATURE_LABELS,CLUSTERFUN)
% general purpose GUI for cluster cutting, pass in FEATURES, returns LABELS


if nargin<3 | isempty(CLUSTERFUN)
	CLUSTERFUN=@(x,n) kmeans(x,n);
end

[nsamples,nfeatures]=size(FEATURES);

LABELS=ones(nsamples,1);

if nargin<2 | isempty(FEATURE_LABELS)
	for i=1:nfeatures
		FEATURE_LABELS{i}=[ 'Feature ' num2str(i) ];
	end
end

main_window=figure('Visible','off','Position',[360,500,700,600],'Name','Markolab Clust Cut','NumberTitle','off');
plot_axis=axes('Units','pixels','Position',[50,50,400,400]);

pop_up_x= uicontrol('Style','popupmenu',...
	'String',FEATURE_LABELS,...
	'Position',[400,90,75,25],'call',@change_plot,...
	'Value',1);
pop_up_x_text= uicontrol('Style','text',...
	'String','X',...
	'Position',[405,130,50,45]);


pop_up_y= uicontrol('Style','popupmenu',...
	'String',FEATURE_LABELS,...
	'Position',[495,90,75,25],'call',@change_plot,...
	'Value',min(nfeatures,2));
pop_up_y_text= uicontrol('Style','text',...
	'String','Y',...
	'Position',[500,130,50,45]);

pop_up_z= uicontrol('Style','popupmenu',...
	'String',FEATURE_LABELS,...
	'Position',[595,90,75,25],'call',@change_plot,...
	'Value',min(nfeatures,3));
pop_up_z_text= uicontrol('Style','text',...
	'String','Z',...
	'Position',[600,130,50,45]);

pop_up_clusters= uicontrol('Style','popupmenu',...
	'String',[1:10],...
	'Position',[475,210,75,25],'value',1,...
	'call',@change_plot);
pop_up_clusters_text= uicontrol('Style','text',...
	'String','Number of Clusters',...
	'Position',[500,250,100,45]);

pop_up_choice= uicontrol('Style','popupmenu',...
	'String',[1:20],...
	'Position',[475,330,75,25],'value',1);
pop_up_choice_text= uicontrol('Style','text',...
	'String','Cluster selection',...
	'Position',[500,370,100,45]);

push_draw_mode= uicontrol('Style','pushbutton',...
	'String','Draw mode (x and y only)',...
	'Position',[500,450,100,35],'value',0,...
	'Call',@change_plot);

rows=ceil(length(FEATURE_LABELS)/5);

i=1;
while i<=length(FEATURE_LABELS)
	row=ceil(i/5);
	column=mod(i,5);
	if column==0, column=5; end

	cluster_dims{i}=uicontrol('Style','checkbox',...
		'String',FEATURE_LABELS{i},...
		'Value',0,'Position',[50+column*60,600-row*35,70,25]);
	set(cluster_dims{i},'Units','Normalized')
	i=i+1;
end


% now align everything and send the main_window handle to the output
% so we can use the gui with uiwait (requires the handle as a return value)

align([pop_up_clusters,pop_up_clusters_text,...
	pop_up_choice,pop_up_choice_text,push_draw_mode],'Center','None');
align([pop_up_x,pop_up_x_text],'Center','None');
align([pop_up_y,pop_up_y_text],'Center','None');
align([pop_up_z,pop_up_z_text],'Center','None');

FIGNUM=gcf;

% run change_plot, which updates the plot according to the defaults

change_plot();

set(pop_up_choice,'string',[1:length(unique(LABELS))])
set(pop_up_choice,'value',1);

set([main_window,plot_axis,pop_up_x,pop_up_x_text,pop_up_y,pop_up_y_text,pop_up_z,...
	pop_up_z_text,pop_up_clusters,pop_up_clusters_text,pop_up_choice,pop_up_choice_text,push_draw_mode],'Units','Normalized');

movegui(main_window,'center')
set(main_window,'Visible','On')

%% Callbacks

% this callback changes the plot and returns the sum of the distances
% from the centroid for each point in a cluster

function change_plot(varargin)

draw_mode=get(push_draw_mode,'value');

dim=[];
for i=1:length(cluster_dims)
	val=get(cluster_dims{i},'value');
	if val==1
		dim=[dim i];
	end
end

viewdim(1)=get(pop_up_x,'value');
viewdim(2)=get(pop_up_y,'value');
viewdim(3)=get(pop_up_z,'value');

if isempty(dim)
	dim=viewdim;
	for i=1:length(dim)
		set(cluster_dims{dim(i)},'value',1);
	end
end

choices=get(pop_up_clusters,'string');
clusternum=str2num(choices(get(pop_up_clusters,'value')));

% cluster, user-specified function is passed

LABELS=CLUSTERFUN(FEATURES(:,dim),clusternum);

% clear the plot axis

cla;
ndims=length(dim);

% plot in either 2 or 3 dims
%
if draw_mode

	ndims=2;
	plot(FEATURES(:,viewdim(1)),FEATURES(:,viewdim(2)),'o','markerfacecolor','b');view(2);
	hold on
	disp('Select the corners of the enclosing polygon then press RETURN to continue...');
	hold off;
	
	LABELS=ones(nsamples,1);
	counter=2;

	response2=[];

	while isempty(response2)

		[xv,yv]=ginput;
		k=convhull(xv,yv);	
		hold on;
		plot(xv(k),yv(k),'b-','linewidth',1.25);
		choice=inpolygon(FEATURES(:,viewdim(1)),FEATURES(:,viewdim(2)),xv(k),yv(k));
		LABELS(choice==1)=counter;
		response2=input('(D)one drawing or (c)ontinue?  ','s');

		switch lower(response2)
			case 'd'
				break;
			case 'c'
				response2=[];
			otherwise
				response2=[];
		end

		counter=counter+1;


	end

	clusternum=counter;

end

colors=colormap(['lines(' num2str(clusternum) ')']);

switch ndims
	case 2
		for i=1:clusternum
	
			clusterid{i}=num2str(i);
			points=find(LABELS==i);
			h(:,i)=plot(FEATURES(points,viewdim(1)),FEATURES(points,viewdim(2)),...
				'o','markerfacecolor',colors(i,:),'markeredgecolor','none');hold on
		end
		view(2)
		xlabel(FEATURE_LABELS{dim(1)});ylabel(FEATURE_LABELS{dim(2)})
	case 3
		for i=1:clusternum
			clusterid{i}=num2str(i);
			points=find(LABELS==i);
			h(:,i)=plot3(FEATURES(points,viewdim(1)),FEATURES(points,viewdim(2)),FEATURES(points,viewdim(3)),...
				'o','markerfacecolor',colors(i,:),'markeredgecolor','none');hold on

		end
		grid on
		view(3)
		xlabel(FEATURE_LABELS{dim(1)});ylabel(FEATURE_LABELS{dim(2)});zlabel(FEATURE_LABELS{dim(3)})

end

% label everything

set(pop_up_choice,'string',[1:length(unique(LABELS))])
L=legend(h,clusterid,'Location','NorthEastOutside');legend boxoff
set(L,'FontSize',20,'FontName','Helvetica')

end

end
