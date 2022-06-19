function fig = plot2DHistogram(locData,columnName1,columnName2,figureParams)

fontsize = figureParams.FontSize;
theme    = figureParams.Theme;

keep = logical(locData.filter);

fig = figure('position',[100 400 350 300]);

switch columnName1
    case 'Frame'
        data1 = locData.frameGrouped;
        data1 = data1(keep);
        nameParam1 = 'Frame';
        xEdges = min(data1(:)):(max(data1(:))-min(data1(:)))/100:max(data1(:));
    case 'x'
        data1 = locData.x;
        data1 = data1(keep);
        nameParam1 = 'x (nm)';
        xEdges = min(data1(:)):(max(data1(:))-min(data1(:)))/100:max(data1(:));
    case 'y'
        data1 = locData.y;
        data1 = data1(keep);
        nameParam1 = 'y (nm)';
        xEdges = min(data1(:)):(max(data1(:))-min(data1(:)))/100:max(data1(:));
    case 'Phi'
        data1 = locData.phi*180/pi;
        data1 = data1(keep);
        nameParam1 = '\phi (degrees)';
        xEdges = -90:2:90;
    case 'Theta'
        data1 = locData.theta*180/pi;
        data1 = data1(keep);
        nameParam1 = '\theta (degrees)';
        xEdges = 0:1:90;
    case 'avgDoLP'
        data1 = locData.avgDoLP;
        data1 = data1(keep);
        nameParam1 = 'avgDoLP';
        xEdges = 0:0.01:1;
    case 'netDoLP'
        data1 = locData.netDoLP;
        data1 = data1(keep);
        nameParam1 = 'netDoLP';
        xEdges = 0:0.01:1;
    case 'Photons'
        data1 = locData.photons;
        data1 = data1(keep);
        nameParam1 = 'Signal photons';
        if min(data1(:)) < 0
            xEdges = min(data1(:)):(max(data1(:))-min(data1(:)))/100:max(data1(:));
        else
            xEdges = 0:max(data1(:))/100:max(data1(:));
        end
    case 'Bkgnd'
        data1 = locData.bkgnd;
        data1 = data1(keep);
        nameParam1 = 'Background photons';
        if min(data1(:)) < 0
            xEdges = min(data1(:)):(max(data1(:))-min(data1(:)))/100:max(data1(:));
        else
            xEdges = 0:max(data1(:))/100:max(data1(:));
        end
    case 'Sigma x'
        data1 = locData.sigmax;
        data1 = data1(keep);
        nameParam1 = '\sigma_x (pix)';
        xEdges = 0:max(data1(:))/100:max(data1(:));
    case 'Sigma y'
        data1 = locData.sigmay;
        data1 = data1(keep);
        nameParam1 = '\sigma_y (pix)';
        xEdges = 0:max(data1(:))/100:max(data1(:));
    case 'Uncertainty xy'
        data1 = locData.uncertainty_xy;
        data1 = data1(keep);
        nameParam1 = 'Thompson uncertainty xy (nm)';
        xEdges = 0:max(data1(:))/100:max(data1(:));
end

switch columnName2
    case 'Frame'
        data2 = locData.frameGrouped;
        data2 = data2(keep);
        nameParam2 = 'Frame';
        yEdges = min(data2(:)):(max(data2(:))-min(data2(:)))/100:max(data2(:));
    case 'x'
        data2 = locData.x;
        data2 = data2(keep);
        nameParam2 = 'x (nm)';
        yEdges = min(data2(:)):(max(data2(:))-min(data2(:)))/100:max(data2(:));
    case 'y'
        data2 = locData.y;
        data2 = data2(keep);
        nameParam2 = 'y (nm)';
        yEdges = min(data2(:)):(max(data2(:))-min(data2(:)))/100:max(data2(:));
    case 'Phi'
        data2 = locData.phi*180/pi;
        data2 = data2(keep);
        nameParam2 = '\phi (degrees)';
        yEdges = -90:2:90;
    case 'Theta'
        data2 = locData.theta*180/pi;
        data2 = data2(keep);
        nameParam2 = '\theta (degrees)';
        yEdges = 0:1:90;
    case 'avgDoLP'
        data2 = locData.avgDoLP;
        data2 = data2(keep);
        nameParam2 = 'avgDoLP';
        yEdges = 0:0.01:1;
    case 'netDoLP'
        data2 = locData.netDoLP;
        data2 = data2(keep);
        nameParam2 = 'netDoLP';
        yEdges = 0:0.01:1;
    case 'Photons'
        data2 = locData.photons;
        data2 = data2(keep);
        nameParam2 = 'Signal photons';
        if min(data2(:)) < 0
            yEdges = min(data2(:)):(max(data2(:))-min(data2(:)))/100:max(data2(:));
        else
            yEdges = 0:max(data2(:))/100:max(data2(:));
        end
    case 'Bkgnd'
        data2 = locData.bkgnd;
        data2 = data2(keep);
        nameParam2 = 'Background photons';
        if min(data2(:)) < 0
            yEdges = min(data2(:)):(max(data2(:))-min(data2(:)))/100:max(data2(:));
        else
            yEdges = 0:max(data2(:))/100:max(data2(:));
        end
    case 'Sigma x'
        data2 = locData.sigmax;
        data2 = data2(keep);
        nameParam2 = '\sigma_x (pix)';
        yEdges = 0:max(data2(:))/100:max(data2(:));
    case 'Sigma y'
        data2 = locData.sigmay;
        data2 = data2(keep);
        nameParam2 = '\sigma_y (pix)';
        yEdges = 0:max(data2(:))/100:max(data2(:));
    case 'Uncertainty xy'
        data2 = locData.uncertainty_xy;
        data2 = data2(keep);
        nameParam2 = 'Thompson uncertainty xy (nm)';
        yEdges = 0:max(data2(:))/100:max(data2(:));
end

histogram2(data1,data2,xEdges,yEdges,'DisplayStyle','tile')%,'ShowEmptyBins','on')
xlabel(nameParam1)
ylabel(nameParam2)

c = colorbar;
c.Label.String = 'Counts';
c.Label.FontSize = fontsize;
c.TickDirection = 'out';

set(gca,'fontsize',fontsize)

switch theme
    case 'light'
        set(gcf,'Color','w')
        c.Color = 'k';
    case 'dark'
        set(gcf,'Color','k')
        set(gca,'Color','k','XColor','w','YColor','w')
        c.Color = 'w';
end

end