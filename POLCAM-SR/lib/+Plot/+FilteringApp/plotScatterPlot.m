function fig = plotScatterPlot(locData,columnName,figureParams)

fontsize = figureParams.FontSize;
theme    = figureParams.Theme;

ms = 10; % markersize

keep = logical(locData.filter);

x = locData.x; x = x(keep);
y = locData.y; y = y(keep);

fig = figure('position',[100 400 550 550]);

switch columnName
    case 'Frame'
        data = locData.frameGrouped; data = data(keep);
        scatter(y,x,ms,data,'.');
        c = colorbar; c.Label.String = 'Frame';
    case 'x'
        data = locData.x; data = data(keep);
        scatter(y,x,ms,data,'.');
        c = colorbar; c.Label.String = 'x (nm)';
    case 'y'
        data = locData.y; data = data(keep);
        scatter(locData.y,locData.x,ms,data,'.');
        c = colorbar; c.Label.String = 'y (nm)';
    case 'Phi'
        data = locData.phi*180/pi; data = data(keep);
        mcol = hsv(180+1);
        mcol = mcol(ceil(90+data),:);
        scatter(y,x,ms,mcol,'.');
        c = colorbar; colormap("hsv"); caxis([-90 90]); c.Ticks = -90:30:90;
        c.Label.String = '\phi (deg.)';
    case 'Theta'
        data = locData.theta*180/pi; data = data(keep);
        scatter(y,x,ms,data,'.');
        c = colorbar; c.Label.String = '\theta (deg.)';
    case 'avgDoLP'
        data = locData.avgDoLP; data = data(keep);
        scatter(y,x,ms,data,'.');
        c = colorbar; c.Label.String = 'avgDoLP';
    case 'netDoLP'
        data = locData.netDoLP; data = data(keep);
        scatter(y,x,ms,data,'.');
        c = colorbar; c.Label.String = 'netDoLP';
    case 'Photons'
        data = locData.photons; data = data(keep);
        scatter(y,x,ms,data,'.');
        caxis([prctile(data,1) prctile(data,99)])
        c = colorbar; c.Label.String = 'Signal photons';
    case 'Bkgnd'
        data = locData.bkgnd; data = data(keep);
        scatter(y,x,ms,data,'.');
        caxis([prctile(data,1) prctile(data,99)])
        c = colorbar; c.Label.String = 'Background photons';
    case 'Sigma x'
        data = locData.sigmax; data = data(keep);
        scatter(y,x,ms,data,'.');
        c = colorbar; c.Label.String = '\sigma_x (pix)';
    case 'Sigma y'
        data = locData.sigmay; data = data(keep);
        scatter(y,x,ms,data,'.');
        c = colorbar; c.Label.String = '\sigma_y (pix)';
    case 'Uncertainty xy'
        data = locData.uncertainty_xy; data = data(keep);
        scatter(y,x,ms,data,'.');
        caxis([prctile(data,1) prctile(data,99)])
        c = colorbar; c.Label.String = 'Thompson uncertainty xy (nm)';
    case 'Angle gaussian'
        data = locData.angleGaus*180/pi; data = data(keep);
        mcol = hsv(180+1);
        mcol = mcol(ceil(90+data),:);
        scatter(y,x,ms,mcol,'.');
        c = colorbar; colormap("hsv"); caxis([-90 90]); c.Ticks = -90:30:90;
        c.Label.String = 'Angle rotated asym gaussian (deg.)';
    case 'Frames bound'
        data = locData.len; data = data(keep);
        scatter(y,x,ms,data,'.');
        caxis([1 prctile(data,99)])
        c = colorbar; c.Label.String = 'Number of frames bound';
    case 'Cluster id'
        data = locData.cluster_id; data = data(keep);
        scatter(y,x,ms,data,'.');
        caxis([min(data(:)) max(data(:))])
        c = colorbar; c.Label.String = 'Cluster id';
end

% communal figure settings
c.Label.FontSize = fontsize;
c.TickDirection = 'out';
xlabel('x (nm)'); ylabel('y (nm)')
axis equal, axis tight; grid on;
set(gca,'fontsize',fontsize,'YDir','reverse')

% set to black background with white grid
set(gca,'Color','k')
set(gca,'GridColor','w')

switch theme
    case 'light'
        set(gcf,'Color','w')    
    case 'dark'
        c.Color = 'w';
        set(gca,'Color','k','XColor','w','YColor','w')
        set(gcf,'Color','k')    
end

end