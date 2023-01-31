function fig = generateRodPlot(locData,keep,rodLength,linewidth)

fontsize = 10;

y = locData.x(keep);
x = locData.y(keep);
phi = locData.phi(keep)*180/pi;

mcol = hsv(180+1); % mcol = circshift(mcol,0,1);
mcol = mcol(ceil(90+phi),:);

fig = figure;
for i=1:length(x)
    dx = (rodLength/2)*cosd(phi(i));
    dy = (rodLength/2)*sind(phi(i));
    line([x(i)-dx, x(i)+dx],[y(i)+dy, y(i)-dy],'Color',mcol(i,:),'LineWidth',linewidth);
end
axis equal;
c = colorbar; colormap(hsv);
c.Label.String = '\phi (deg.)';
c.Label.FontSize = fontsize;
c.TickDirection = 'out';
caxis([-90 90])
c.Ticks = -90:30:90;
set(gca,'YDir','reverse','Color','k','fontsize',fontsize)
xlabel('x (nm)')
ylabel('y (nm)')

end