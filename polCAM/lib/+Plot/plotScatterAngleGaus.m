function fig = plotScatterAngleGaus(locData,keep,theme)

x = locData.x(keep)/1000; % convert to um
y = locData.y(keep)/1000; % convert to um
sigmax = locData.sigmax(keep);
sigmay = locData.sigmay(keep);

angleGaus = locData.rot(keep);
angleGaus(sigmax./sigmay > 1) = angleGaus(sigmax./sigmay > 1) + pi/2;
angleGaus = (angleGaus - pi/2)*180/pi;
angleGaus(angleGaus < - 90) = angleGaus(angleGaus < - 90) + 180;


fontsize = 10;
markersize = 1;
markerfacealpha = 0.5;

fig = figure('position',[100 100 800 800]);

mcol = hsv(180+1);
% mcol = circshift(mcol,0,1);
mcol = mcol(ceil(90+angleGaus),:);

switch theme
    
    case 'light'
        scatter(y,x,markersize,mcol,'o','filled','markerfacealpha',markerfacealpha)
        xlabel('x (\mum)'); ylabel('y (\mum)')
        axis equal; axis tight; grid on
        set(gca,'Ydir','reverse')
        set(gca,'FontSize',fontsize)
        
        c = colorbar; colormap(hsv);
        c.Label.String = '\phi (deg.)';
        c.Label.FontSize = fontsize;
        c.TickDirection = 'out';
        caxis([-90 90])
        c.Ticks = -90:30:90;
        
    case 'dark'
        scatter(y,x,markersize,mcol,'o','filled','markerfacealpha',markerfacealpha)
        xlabel('x (\mum)'); ylabel('y (\mum)')
        axis equal; axis tight; grid on
        set(gca,'Ydir','reverse')
        set(gca,'FontSize',fontsize,'Color','k','XColor','w','YColor','w')
        set(gcf,'Color','k')

        c = colorbar; colormap(hsv); c.Color = 'w';
        c.Label.String = '\phi (deg.)';
        c.Label.FontSize = fontsize;
        c.TickDirection = 'out';
        caxis([-90 90])
        c.Ticks = -90:30:90;
        
    case 'dark white slide'
        scatter(y,x,markersize,mcol,'o','filled','markerfacealpha',markerfacealpha)
        xlabel('x (\mum)'); ylabel('y (\mum)')
        axis equal; axis tight; grid on
        set(gca,'Ydir','reverse')
        set(gca,'FontSize',fontsize,'Color','k','GridColor','w')

        c = colorbar; colormap(hsv);
        c.Label.String = '\phi (deg.)';
        c.Label.FontSize = fontsize;
        c.TickDirection = 'out';
        caxis([-90 90])
        c.Ticks = -90:30:90;        
end
