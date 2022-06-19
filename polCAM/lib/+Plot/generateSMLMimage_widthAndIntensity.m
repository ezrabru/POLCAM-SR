function img = generateSMLMimage_widthAndIntensity(x,y,int,sigma,pixelsize,oversampling)

% defaults
sigma_min = prctile(sigma,5);
sigma_max = prctile(sigma,95);
sigma_num_bins = 10;

% check type
variable_sigma = 0;
variable_int = 0;
if length(sigma) > 1; variable_sigma = 1; end
if length(int) > 1; variable_int = 1; end

% get dimensions final reconstruction
xdim = round(oversampling*max(x)/pixelsize)+1;
ydim = round(oversampling*max(y)/pixelsize)+1;

% rescale x and y coordinates
x = round(oversampling*x/pixelsize);
y = round(oversampling*y/pixelsize);

if variable_sigma
    
    bin_sigma = (sigma_max-sigma_min)/sigma_num_bins;
    reconstruction = zeros(xdim,ydim,sigma_num_bins);
    
    for i=1:sigma_num_bins
        
        sigma_min_i = sigma_min + (i-1)*bin_sigma;
        sigma_max_i = sigma_min_i + bin_sigma;
        sigma_mean  = (oversampling/pixelsize)*(sigma_min_i + sigma_max_i)/2;
        
        idx = (sigma > sigma_min_i).*(sigma < sigma_max_i);
        x_i   = x(idx==1)+1;
        y_i   = y(idx==1)+1;
        int_i = y(idx==1);
        
        reconstruction_i = zeros(xdim,ydim);
        for j=1:length(x_i)
            if variable_int
                reconstruction_i(x_i(j),y_i(j)) = reconstruction_i(x_i(j),y_i(j)) + int_i(j);
            else
                reconstruction_i(x_i(j),y_i(j)) = reconstruction_i(x_i(j),y_i(j)) + 1;
            end
        end
        h = fspecial('gaussian',4*ceil(2*sigma_mean)+1,sigma_mean);
        reconstruction_i = imfilter(reconstruction_i, h);
        reconstruction(:,:,i) = reconstruction_i;
    end
    
else
    reconstruction = zeros(xdim,ydim);
    for i=1:length(x)
        if variable_int
            reconstruction(x(i),y(i)) = reconstruction(x(i),y(i)) + int(i);
        else
            reconstruction(x(i),y(i)) = reconstruction(x(i),y(i)) + 1;
        end
    end
    reconstruction = imgaussfilt(reconstruction,sigma,'FilterSize',4*ceil(2*sigma)+1.);
end

reconstruction = sum(reconstruction,3);

% add border
border = 0.1;
img = padarray(reconstruction,[round(border*xdim) round(border*xdim)]);

end