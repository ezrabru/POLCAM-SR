function fig = plotScatterSigmaRatio(locData,keep,theme)

x = locData.x(keep)/1000; % convert to um
y = locData.y(keep)/1000; % convert to um
sigmaRatio = locData.sigmax(keep)./locData.sigmay(keep);

fontsize = 10;
markersize = 1;
markerfacealpha = 0.5;

set_caxis  = [0.5 1.5];
set_cticks = 0.5:0.25:1.5;


fig = figure('position',[100 100 800 800]);

switch theme
    
    case 'light'
        scatter(y,x,markersize,sigmaRatio,'o','filled','markerfacealpha',markerfacealpha)
        xlabel('x (\mum)'); ylabel('y (\mum)')
        axis equal; axis tight; grid on
        set(gca,'Ydir','reverse')
        set(gca,'FontSize',fontsize)
        
        c = colorbar;
        c.Label.String = '\sigma_x/\sigma_y';
        c.Label.FontSize = fontsize;
        c.TickDirection = 'out';
        caxis(set_caxis); c.Ticks = set_cticks;
        
    case 'dark'
        scatter(y,x,markersize,sigmaRatio,'o','filled','markerfacealpha',markerfacealpha)
        xlabel('x (\mum)'); ylabel('y (\mum)')
        axis equal; axis tight; grid on
        set(gca,'Ydir','reverse')
        set(gca,'FontSize',fontsize,'Color','k','XColor','w','YColor','w')
        set(gcf,'Color','k')

        c = colorbar; c.Color = 'w';
        c.Label.String = '\sigma_x/\sigma_y';
        c.Label.FontSize = fontsize;
        c.TickDirection = 'out';
        caxis(set_caxis); c.Ticks = set_cticks;

    case 'dark white slide'
        scatter(y,x,markersize,sigmaRatio,'o','filled','markerfacealpha',markerfacealpha)
        xlabel('x (\mum)'); ylabel('y (\mum)')
        axis equal; axis tight; grid on
        set(gca,'Ydir','reverse')
        set(gca,'FontSize',fontsize,'Color','k','GridColor','w')

        c = colorbar;
        c.Label.String = '\sigma_x/\sigma_y';
        c.Label.FontSize = fontsize;
        c.TickDirection = 'out';
        caxis(set_caxis); c.Ticks = set_cticks;

end
