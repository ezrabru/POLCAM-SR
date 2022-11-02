function fig = plotScatterComboDoLPsPhotons(locData,keep,theme)

avgDoLP = locData.avgDoLP(keep);
netDoLP = locData.netDoLP(keep);
photons = locData.photons(keep);

fontsize = 10;
markersize = 1;
markerfacealpha = 0.01;

fig = figure('position',[100 300 1000 300]);

switch theme
    
    case 'light'
        
        markerfacecolor = 'k';
        
        subplot(1,3,1);
        scatter(photons,avgDoLP,markersize,'o','filled','markerFaceAlpha',markerfacealpha,'markerFaceColor',markerfacecolor); grid on
        xlabel('Photons'); ylabel('avgDoLP')
        xlim([1e2 1e5]); ylim([0 1]); yticks(0:0.2:1); axis square
        set(gca,'FontSize',fontsize,'XScale','log')

        subplot(1,3,2);
        scatter(photons,netDoLP,markersize,'o','filled','markerFaceAlpha',markerfacealpha,'markerFaceColor',markerfacecolor); grid on
        xlabel('Photons'); ylabel('netDoLP')
        xlim([1e2 1e5]); ylim([0 1]); yticks(0:0.2:1); axis square
        set(gca,'FontSize',fontsize,'XScale','log')

        subplot(1,3,3);
        scatter(avgDoLP,netDoLP,markersize,'o','filled','markerFaceAlpha',markerfacealpha,'markerFaceColor',markerfacecolor); grid on
        xlabel('avgDoLP'); ylabel('netDoLP')
        xlim([0 1]); ylim([0 1]); xticks(0:0.2:1); yticks(0:0.2:1); axis square
        set(gca,'FontSize',fontsize)
        
    case 'dark'
        
        markerfacecolor = 'r';
        
        subplot(1,3,1);
        scatter(photons,avgDoLP,markersize,'o','filled','markerFaceAlpha',markerfacealpha,'markerFaceColor',markerfacecolor); grid on
        xlabel('Photons'); ylabel('avgDoLP')
        xlim([1e2 1e5]); ylim([0 1]); yticks(0:0.2:1); axis square
        set(gca,'FontSize',fontsize,'XScale','log','Color','k','XColor','w','YColor','w')
        set(gcf,'Color','k')

        subplot(1,3,2);
        scatter(photons,netDoLP,markersize,'o','filled','markerFaceAlpha',markerfacealpha,'markerFaceColor',markerfacecolor); grid on
        xlabel('Photons'); ylabel('netDoLP')
        xlim([1e2 1e5]); ylim([0 1]); yticks(0:0.2:1); axis square
        set(gca,'FontSize',fontsize,'XScale','log','Color','k','XColor','w','YColor','w')
        set(gcf,'Color','k')

        subplot(1,3,3);
        scatter(avgDoLP,netDoLP,markersize,'o','filled','markerFaceAlpha',markerfacealpha,'markerFaceColor',markerfacecolor); grid on
        xlabel('avgDoLP'); ylabel('netDoLP')
        xlim([0 1]); ylim([0 1]); xticks(0:0.2:1); yticks(0:0.2:1); axis square
        set(gca,'FontSize',fontsize,'Color','k','XColor','w','YColor','w')
        set(gcf,'Color','k')

end
