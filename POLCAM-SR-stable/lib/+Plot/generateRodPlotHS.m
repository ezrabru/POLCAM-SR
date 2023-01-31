function fig = generateRodPlotHS(locData,keep,rodLength,linewidth,dolpLim)

fontsize = 10;

y       = locData.x(keep);
x       = locData.y(keep);
phi     = locData.phi(keep)*180/pi;
avgDoLP = locData.avgDoLP(keep);

h = (phi + 90)/180;
s = avgDoLP; s = (s - dolpLim(1))/(dolpLim(2) - dolpLim(1)); s(s>1) = 1; s(s<0) = 0;
v = ones(size(s));

mcol = hsv2rgb([h,s,v]);

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