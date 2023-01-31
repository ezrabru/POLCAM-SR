function fig = plotScatterBkgnd(locData,keep,theme)

x = locData.x(keep)/1000; % convert to um
y = locData.y(keep)/1000; % convert to um
bkgnd = locData.bkgnd(keep);

fontsize = 10;
markersize = 1;
markerfacealpha = 0.5;


fig = figure('position',[100 100 800 800]);

switch theme
    
    case 'light'
        scatter(y,x,markersize,bkgnd,'o','filled','markerfacealpha',markerfacealpha)
        xlabel('x (\mum)'); ylabel('y (\mum)')
        axis equal; axis tight; grid on
        set(gca,'Ydir','reverse')
        set(gca,'FontSize',fontsize)
        
        c = colorbar;
        c.Label.String = 'Bkgnd (photons)';
        c.Label.FontSize = fontsize;
        c.TickDirection = 'out';
        
    case 'dark'
        scatter(y,x,markersize,bkgnd,'o','filled','markerfacealpha',markerfacealpha)
        xlabel('x (\mum)'); ylabel('y (\mum)')
        axis equal; axis tight; grid on
        set(gca,'Ydir','reverse')
        set(gca,'FontSize',fontsize,'Color','k','XColor','w','YColor','w')
        set(gcf,'Color','k')

        c = colorbar; c.Color = 'w';
        c.Label.String = 'Bkgnd (photons)';
        c.Label.FontSize = fontsize;
        c.TickDirection = 'out';

    case 'dark white slide'
        scatter(y,x,markersize,bkgnd,'o','filled','markerfacealpha',markerfacealpha)
        xlabel('x (\mum)'); ylabel('y (\mum)')
        axis equal; axis tight; grid on
        set(gca,'Ydir','reverse')
        set(gca,'FontSize',fontsize,'Color','k','GridColor','w')

        c = colorbar;
        c.Label.String = 'Bkgnd (photons)';
        c.Label.FontSize = fontsize;
        c.TickDirection = 'out';

end
