function AX=markolab_preview(DATA,AUDIO,FS)
%
%
%


AX=[];

AX(1)=subplot(3,1,1:2);
[s,f,t]=zftftb_pretty_sonogram(AUDIO,FS,'filtering',300);
imagesc(t,f/1e3,s);axis xy;


timevec=[1:size(DATA,1)]/FS;

AX(2)=subplot(3,1,3);
plot(timevec,DATA);
linkaxes(AX,'x');

