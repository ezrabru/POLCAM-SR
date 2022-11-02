function fig = plotPolarHistROI(locData,keep,histBins,rodLength,linewidth)

fontsize = 10;

phi = locData.phi(keep)*180/pi;
remapped = phi;
for i=1:length(remapped)
    if abs(remapped(i) - 180) > 180
        remapped(i) = remapped(i) + 180;
    elseif abs(remapped(i) + 180) > 180
        remapped(i) = remapped(i) - 180;
    end
end
remapped(remapped<0) = 180 + remapped(remapped<0);
remapped(remapped>180) = remapped(remapped>180)-180;

fig = figure('position',[50 50 600 200]);
subplot(1,2,1);
polarhistogram(remapped*pi/180,histBins,'edgecolor','none')
title(sprintf('IQR = %.f',iqr(remapped)),'fontweight','normal')
ax = gca;
ax.ThetaLim = [0,180];
set(gca,'FontSize',fontsize)

subplot(1,2,2);
y = locData.x(keep);
x = locData.y(keep);
phi = locData.phi(keep)*180/pi;
mcol = hsv(180+1); % mcol = circshift(mcol,0,1);
mcol = mcol(ceil(90+phi),:);
for i=1:length(x)
    dx = (rodLength/2)*cosd(phi(i));
    dy = (rodLength/2)*sind(phi(i));
    line([x(i)-dx, x(i)+dx],[y(i)+dy, y(i)-dy],'Color',mcol(i,:),'LineWidth',linewidth);
end
axis equal
c = colorbar; colormap(hsv);
c.Label.String = '\phi (deg.)';
c.Label.FontSize = fontsize;
c.TickDirection = 'out';
caxis([-90 90])
c.Ticks = -90:30:90;
set(gca,'YDir','reverse','Color','k')
xlabel('x (nm)'); ylabel('y (nm)')

end