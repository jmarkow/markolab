function AX=markolab_preview(DATA,DATA_FS,AUDIO,AUDIO_FS)
%
%
%


AX=[];

AX(1)=subplot(3,1,1:2);
[s,f,t]=zftftb_pretty_sonogram(AUDIO,AUDIO_FS,'filtering',300,'norm_amp',1,'clipping',[-3 2]);
imagesc(t,f/1e3,s);axis xy;
colormap(jet);

timevec=[1:size(DATA,1)]/DATA_FS;

AX(2)=subplot(3,1,3);
plot(timevec,DATA);
linkaxes(AX,'x');

