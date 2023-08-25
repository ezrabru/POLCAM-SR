function [x,y,dx_spline,dy_spline,dx,dy] = correctDriftRCC(frame,x,y,filter,segmentation,pixelsize_hist)

% select only filtered localisations for drift correction
frame_filter = frame(filter);
x_filter     = x(filter);
y_filter     = y(filter);

frame_filter = frame_filter - min(frame_filter) + 1;
numFrames    = max(frame_filter);
numSegments  = floor(numFrames/segmentation);

%%

% Get edges for 2d histogram rendering
xEdges = min(x_filter)-pixelsize_hist:pixelsize_hist:max(x_filter)+pixelsize_hist;
yEdges = min(y_filter)-pixelsize_hist:pixelsize_hist:max(y_filter)+pixelsize_hist;

% Divide the dataset into substacks of 'segmentation' number of frames and
% generate a 2d histogram of each substack
segments = zeros(length(xEdges)-1,length(yEdges)-1,numSegments);
for i=1:numSegments
    if i < numSegments
        lb = (i-1)*segmentation; % first frame substack
        ub = i*segmentation; % last frame substack
        keep = logical((frame_filter > lb).*(frame_filter < ub));
    else
        lb = (i-1)*segmentation; % first frame substack
        keep = logical((frame_filter > lb));
    end
    [ASH,~,~] = histcounts2(x_filter(keep),y_filter(keep),xEdges,yEdges);
    segments(:,:,i) = ASH;

    % imshow(flipud(ASH'),[]); colormap(hot)
    % title(['Segment ' num2str(i) '/' num2str(numSegments)])
    % pause(0.5)
end

% Initialize drift correction
dx = zeros(numSegments,1);
dy = zeros(numSegments,1);

% Loop over segments and calculate the shift between the images of
% sequential substacks using cross-correlation
for i=2:numSegments
    
    % Get the 2d histograms that will be registered
    segment1 = flipud(segments(:,:,i-1)');
    segment2 = flipud(segments(:,:,i)');
    
    % Calculate normalised cross-correlation
    c = normxcorr2(segment2,segment1);
    % surf(c); shading flat;
       
    % get peak for pixel-resolution shift in x and y
    [~, imax] = max(c(:));
    [ypeak, xpeak] = ind2sub(size(c),imax(1)); % pixel-level resolution
    
    % refine to sub-pixel resolution by getting weighted centroid around
    % the location of the cross-correlation peak
    w = 5;
    c_roi = c(ypeak-w:ypeak+w,xpeak-w:xpeak+w);
    c_roi = c_roi/sum(c_roi(:));
    [xCoord,yCoord] = meshgrid(1:size(c_roi,1),1:size(c_roi,2));
    x_centroid = sum(xCoord.*c_roi,'all');
    y_centroid = sum(yCoord.*c_roi,'all');
    
    x_peak_subpix = x_centroid - (w+1);
    y_peak_subpix = y_centroid - (w+1);
    
    % sub-pixel resolution
    corr_offset = [((xpeak + x_peak_subpix) - size(segment2,2)) 
                   ((ypeak + y_peak_subpix) - size(segment2,1))];
               
    % total offset
    dx(i) =  corr_offset(1)*pixelsize_hist;
    dy(i) = -corr_offset(2)*pixelsize_hist;

end

dx = -cumsum(dx);
dy = -cumsum(dy);

% interpolate drift
t_segment = (0:numSegments-1)'*segmentation;
t_interp = 0:(numSegments*segmentation-1);
dx_spline = spline(t_segment,dx,t_interp);
dy_spline = spline(t_segment,dy,t_interp);

% Undo calculated drift
x_driftCorrected = zeros(size(x));
y_driftCorrected = zeros(size(y));
for i=1:numSegments*segmentation
    idx = logical(frame == i);
    x_driftCorrected(idx) = x(idx) - dx_spline(i);
    y_driftCorrected(idx) = y(idx) - dy_spline(i);
end

x = x_driftCorrected;
y = y_driftCorrected;

end