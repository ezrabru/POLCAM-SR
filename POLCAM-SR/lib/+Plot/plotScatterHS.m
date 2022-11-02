function fig = plotScatterHS(locData,dolpLim,keep,theme)

x       = locData.x(keep)/1000; % convert to um
y       = locData.y(keep)/1000; % convert to um
phi     = locData.phi(keep)*180/pi;
avgDoLP = locData.avgDoLP(keep);

h = (phi + 90)/180;
s = avgDoLP; s = (s - dolpLim(1))/(dolpLim(2) - dolpLim(1)); s(s>1) = 1; s(s<0) = 0;
v = ones(size(s));

mcol = hsv2rgb([h,s,v]);

fontsize = 10;
markersize = 10;
markerfacealpha = 1;

fig = figure('position',[100 100 800 800]);

switch theme
    
    case 'light'
        scatter(y,x,markersize,mcol,'o','filled','markerfacealpha',markerfacealpha)
%         scatter(y,x,markersize,mcol,'.')
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
%         scatter(y,x,markersize,mcol,'.')
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
