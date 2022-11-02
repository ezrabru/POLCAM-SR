function fig = plotSummaryHistograms(locData,algorithm,figureParams)

fontsize = figureParams.FontSize;
theme    = figureParams.Theme;

keep = logical(locData.filter);

facecolor = 0.7*[1 1 1];

switch algorithm
    
    case 'centroid'
        
        fig = figure('position',[100 400 1200 550]);

        subplot(3,4,1);
        data     = locData.phi(keep)*180/pi;
        binEdges = -90:2:90;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([-90 90]); xticks(-90:45:90); xlabel('\phi (deg.)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,2);
        data     = locData.theta(keep)*180/pi;
        binEdges = 0:1:90;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 90]); xticks(0:15:90); xlabel('\theta (deg.)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,3);
        data     = locData.avgDoLP(keep);
        binEdges = 0:0.01:1;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 1]); xticks(0:0.2:1); xlabel('avgDoLP'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,4);
        data     = locData.netDoLP(keep);
        binEdges = 0:0.01:1;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 1]); xticks(0:0.2:1); xlabel('netDoLP'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,5);
        data     = locData.photons(keep);
        binEdges = min(data(:)):(max(data(:))-min(data(:)))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlabel('Photons'); ylabel('Counts'); setTheme(theme);
        
    case 'symmetric gaussian'
        
        fig = figure('position',[100 400 1200 550]);
        
        subplot(3,4,1);
        data     = locData.phi(keep)*180/pi;
        binEdges = -90:2:90;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([-90 90]); xticks(-90:45:90); xlabel('\phi (deg.)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,2);
        data     = locData.theta(keep)*180/pi;
        binEdges = 0:1:90;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 90]); xticks(0:15:90); xlabel('\theta (deg.)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,3);
        data     = locData.avgDoLP(keep);
        binEdges = 0:0.01:1;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 1]); xticks(0:0.2:1); xlabel('avgDoLP'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,4);
        data     = locData.netDoLP(keep);
        binEdges = 0:0.01:1;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 1]); xticks(0:0.2:1); xlabel('netDoLP'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,5);
        data     = locData.photons(keep);
        binEdges = min(data(:)):(max(data(:))-min(data(:)))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlabel('Photons'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,6);
        data     = locData.bkgnd(keep);
        binEdges = min(data(:)):(max(data(:))-min(data(:)))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlabel('Bkgnd(photons)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,7);
        data     = locData.uncertainty_xy(keep);
        binEdges = 0:max(data(:))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlabel('Uncertainty xy (nm)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,8);
        data     = locData.uncertainty_photons(keep);
        binEdges = 0:max(data(:))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlabel('Uncertainty photons'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,9);
        data     = locData.sigma(keep);
        binEdges = 0:max(data(:))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlim([0 inf]); xlabel('\sigma (pix)'); ylabel('Counts'); setTheme(theme);
        
    case 'asymmetric gaussian'
        
        fig = figure('position',[100 400 1200 550]);
        
        subplot(3,4,1);
        data     = locData.phi(keep)*180/pi;
        binEdges = -90:2:90;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([-90 90]); xticks(-90:45:90); xlabel('\phi (deg.)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,2);
        data     = locData.theta(keep)*180/pi;
        binEdges = 0:1:90;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 90]); xticks(0:15:90); xlabel('\theta (deg.)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,3);
        data     = locData.avgDoLP(keep);
        binEdges = 0:0.01:1;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 1]); xticks(0:0.2:1); xlabel('avgDoLP'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,4);
        data     = locData.netDoLP(keep);
        binEdges = 0:0.01:1;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 1]); xticks(0:0.2:1); xlabel('netDoLP'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,5);
        data     = locData.photons(keep);
        binEdges = min(data(:)):(max(data(:))-min(data(:)))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlabel('Photons'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,6);
        data     = locData.bkgnd(keep);
        binEdges = min(data(:)):(max(data(:))-min(data(:)))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlabel('Bkgnd(photons)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,7);
        data     = locData.uncertainty_xy(keep);
        binEdges = 0:max(data(:))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlabel('Uncertainty xy (nm)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,8);
        data     = locData.uncertainty_photons(keep);
        binEdges = 0:max(data(:))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlabel('Uncertainty photons'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,9);
        data     = locData.sigmax(keep)./locData.sigmay(keep);
        binEdges = min(data(:)):(max(data(:))-min(data(:)))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlabel('\sigma_x/\sigma_y'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,10);
        data     = locData.sigmax(keep);
        binEdges = 0:max(data(:))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlim([0 inf]); xlabel('\sigma_x (pix)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,11);
        data     = locData.sigmay(keep);
        binEdges = 0:max(data(:))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlim([0 inf]); xlabel('\sigma_y (pix)'); ylabel('Counts'); setTheme(theme);

    case 'rotated asymmetric gaussian'
        
        fig = figure('position',[100 400 1200 550]);
        
        subplot(3,4,1);
        data     = locData.phi(keep)*180/pi;
        binEdges = -90:2:90;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([-90 90]); xticks(-90:45:90); xlabel('\phi (deg.)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,2);
        data     = locData.theta(keep)*180/pi;
        binEdges = 0:1:90;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 90]); xticks(0:15:90); xlabel('\theta (deg.)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,3);
        data     = locData.avgDoLP(keep);
        binEdges = 0:0.01:1;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 1]); xticks(0:0.2:1); xlabel('avgDoLP'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,4);
        data     = locData.netDoLP(keep);
        binEdges = 0:0.01:1;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 1]); xticks(0:0.2:1); xlabel('netDoLP'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,5);
        data     = locData.photons(keep);
        binEdges = min(data(:)):(max(data(:))-min(data(:)))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlabel('Photons'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,6);
        data     = locData.bkgnd(keep);
        binEdges = min(data(:)):(max(data(:))-min(data(:)))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlabel('Bkgnd(photons)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,7);
        data     = locData.uncertainty_xy(keep);
        binEdges = 0:max(data(:))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlabel('Uncertainty xy (nm)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,8);
        data     = locData.uncertainty_photons(keep);
        binEdges = 0:max(data(:))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlabel('Uncertainty photons'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,9);
        data     = locData.sigmax(keep)./locData.sigmay(keep);
        binEdges = min(data(:)):(max(data(:))-min(data(:)))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlabel('\sigma_x/\sigma_y'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,10);
        data     = locData.sigmax(keep);
        binEdges = 0:max(data(:))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlim([0 inf]); xlabel('\sigma_x (pix)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,11);
        data     = locData.sigmay(keep);
        binEdges = 0:max(data(:))/100:max(data(:));
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlim([0 inf]); xlim([0 inf]); xlabel('\sigma_y (pix)'); ylabel('Counts'); setTheme(theme);
        
        subplot(3,4,12);
        data     = locData.rot(keep)*180/pi;
        binEdges = -45:1:45;
        histogram(data,binEdges,'FaceColor',facecolor,'EdgeColor','none','FaceAlpha',1);
        xlabel('Rotation'); ylabel('Counts')
        xlim([-45 45]); xticks(-45:15:45); setTheme(theme);
        
end

xlim([-inf inf]);
ylabel('Counts')
set(gca,'fontsize',fontsize)

end

function [] = setTheme(theme)
switch theme
    case 'light'
        set(gcf,'Color','w')
    case 'dark'
        set(gcf,'Color','k')
        set(gca,'Color','k','XColor','w','YColor','w')
end
end
