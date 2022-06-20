function fig = plotLocalisationRateVsTime(locData,figureParams,windowAverage)

fontsize = figureParams.FontSize;
theme    = figureParams.Theme;

lw = 1.5; % linewidth

keep = logical(locData.filter);
frame = locData.frameGrouped(keep);
frameMin = min(frame(:));
frameMax = max(frame(:));
binEdges = frameMin:frameMax;

[N,edges] = histcounts(frame,binEdges);
xData = edges(1:end-1) + 0.5;
yData = movmean(N,windowAverage);

xData = xData(ceil(windowAverage/2):end-ceil(windowAverage/2));
yData = yData(ceil(windowAverage/2):end-ceil(windowAverage/2));

fig = figure('position',[100 400 400 150]);
switch theme

    case 'light'
        plot(xData,yData,'k','LineWidth',lw);
        title(sprintf('k = %d frames rolling average',windowAverage),'FontWeight','Normal')
        grid on
    case 'dark'
        plot(xData,yData,'w','LineWidth',lw);
        title(sprintf('k = %d frames rolling average',windowAverage),'FontWeight','Normal','Color','w')
        set(gca,'Color','k','XColor','w','YColor','w')
        set(gcf,'Color','k'); grid on
end
xlabel('Frame');
ylabel({'Localisation rate','(locs/frame)'});
set(gca,'fontsize',fontsize)
xlim([frameMin frameMax])
ylim([0 max(yData)*1.5])