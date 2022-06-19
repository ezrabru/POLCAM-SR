function fig = plot1DHistogram(locData,columnName,figureParams)

fontsize = figureParams.FontSize;
theme    = figureParams.Theme;

facecolor = 0.7*[1 1 1];

keep = logical(locData.filter);

fig = figure('position',[100 400 300 180]);

switch columnName
    case 'Frame'
        data = locData.frameGrouped; data = data(keep);
        binEdges = min(data(:)):(max(data(:))-min(data(:)))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlabel('Frame');
    case 'x'
        data = locData.x; data = data(keep);
        binEdges = min(data(:)):(max(data(:))-min(data(:)))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlabel('x (nm)');
    case 'y'
        data = locData.y; data = data(keep);
        binEdges = min(data(:)):(max(data(:))-min(data(:)))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlabel('y (nm)');
    case 'Phi'
        data = locData.phi*180/pi; data = data(keep);
        binEdges = -90:2:90;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlabel('\phi (degrees)');
    case 'Theta'
        data = locData.theta*180/pi; data = data(keep);
        binEdges = 0:1:90;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlabel('\theta (degrees)');
    case 'avgDoLP'
        data = locData.avgDoLP; data = data(keep);
        binEdges = 0:0.01:1;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlabel('avgDoLP');
    case 'netDoLP'
        data = locData.netDoLP; data = data(keep);
        binEdges = 0:0.01:1;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlabel('netDoLP');
    case 'Photons'
        data = locData.photons; data = data(keep);
        if min(data(:)) < 0
            binEdges = min(data(:)):(max(data(:))-min(data(:)))/100:max(data(:));
        else
            binEdges = 0:max(data(:))/100:max(data(:));
        end
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlabel('Signal photons');
    case 'Bkgnd'
        data = locData.bkgnd; data = data(keep);
        if min(data(:)) < 0
            binEdges = min(data(:)):(max(data(:))-min(data(:)))/100:max(data(:));
        else
            binEdges = 0:max(data(:))/100:max(data(:));
        end
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlabel('Background photons');
    case 'Sigma x'
        data = locData.sigmax; data = data(keep);
        binEdges = 0:max(data(:))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlabel('\sigma_x (pix)');
    case 'Sigma y'
        data = locData.sigmay; data = data(keep);
        binEdges = 0:max(data(:))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlabel('\sigma_x (pix)');
    case 'Uncertainty xy'
        data = locData.uncertainty_xy; data = data(keep);
        binEdges = 0:max(data(:))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlabel('Uncertainty xy (nm)');
end

xlim([-inf inf]);
ylabel('Counts')
set(gca,'fontsize',fontsize)

switch theme
    case 'light'
        set(gcf,'Color','w')
    case 'dark'
        set(gcf,'Color','k')
        set(gca,'Color','k','XColor','w','YColor','w')
end

end