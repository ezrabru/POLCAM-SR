function reconstruction = generateSMLMimage(x,y,pixelsize,oversampling,sigma,border)

xdim = round(oversampling*max(x)/pixelsize);
ydim = round(oversampling*max(y)/pixelsize);

x_vis = round(oversampling*x/pixelsize);
y_vis = round(oversampling*y/pixelsize);
reconstruction = zeros(xdim,ydim);
for i=1:length(x_vis)
    reconstruction(x_vis(i),y_vis(i)) = reconstruction(x_vis(i),y_vis(i)) + 1;
end
reconstruction = imgaussfilt((reconstruction),sigma);
reconstruction = double(reconstruction);

% add border
reconstruction = padarray(reconstruction,[round(border*xdim) round(border*xdim)]);

end