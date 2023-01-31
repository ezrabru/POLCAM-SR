function [x,y,dx,dy] = correctDriftFiducial(frame,x,y,pixelsize)

pixelsize_hist = pixelsize/5;

xEdges = min(x)-pixelsize_hist:pixelsize_hist:max(x)+pixelsize_hist;
yEdges = min(y)-pixelsize_hist:pixelsize_hist:max(y)+pixelsize_hist;
[img,~,~] = histcounts2(x,y,xEdges,yEdges);

fig = figure('Name','Selecting fiducials','WindowState','maximize');
imshow(img',[0 0.1*max(img(:))]); hold on; set(0,'DefaultAxesTitleFontWeight','normal');
colmap = hsv(max(frame));
scatter(x/pixelsize_hist,y/pixelsize_hist,1,colmap(frame,:));
title({'Select a fiducial by dragging a rectangle.',...
    'The fiducial should barely fit in the selected region.',...
    'You can select another one once you replied y or n to the question in the command window.'})
pause(0.1)

fiducials = struct;
count = 1;
while count < 100
    
    roi = drawrectangle;
    fiducials(count).x_roi = roi.Position(1)*pixelsize_hist;
    fiducials(count).y_roi = roi.Position(2)*pixelsize_hist;
    fiducials(count).w_roi = roi.Position(3)*pixelsize_hist;
    fiducials(count).h_roi = roi.Position(4)*pixelsize_hist;
    
    count = count + 1;
    answer = input('Do you want to select more fiducials (y/n)?','s');
    if strcmp(answer,'n'); count = 100; end
end
close(fig)
disp([num2str(length(fiducials)) ' fiducial(s) selected.'])


%% Get localizations of fiducials from picked regions

fig1 = figure;
scatter(x,y,2,0.7*[1 1 1]); hold on;

for i=1:length(fiducials)
    x_fid = fiducials(i).x_roi;
    y_fid = fiducials(i).y_roi;
    w_fid = fiducials(i).w_roi;
    h_fid = fiducials(i).h_roi;
    
    % Get coordinates of localisations inside user defined ROIs
    Xmin = x_fid; Xmax = x_fid + w_fid;
    Ymin = y_fid; Ymax = y_fid + h_fid;
    keep = ((x > Xmin) & (y > Ymin) & (x < Xmax) & (y < Ymax));
    x_fiducial = x(keep);
    y_fiducial = y(keep);
    frame_fiducial = frame(keep);
    
    % Check that there is only one fiducial localisation per frame
    [~,ia,~] = unique(frame_fiducial); % C = frame_fiducial(ia) and frame_fiducial = C(ic)
    fiducials(i).x = x_fiducial(ia);
    fiducials(i).y = y_fiducial(ia);
    fiducials(i).frame = frame_fiducial(ia);
    
    scatter(x_fiducial,y_fiducial,2,'b'); hold on
    rectangle('Position',[x_fid,y_fid,w_fid,h_fid],'EdgeColor','r');
    text(x_fid,y_fid-0.5*h_fid,['#' num2str(i)],'Color','k');

end

%% Get list of dx and dy for each frame (0 for frames where no fiducial was detected)

disp('Calculating drift...')

for i=1:length(fiducials)
    
    dx_temp = [0; cumsum(diff(fiducials(i).x))];
    dy_temp = [0; cumsum(diff(fiducials(i).y))];
    
    dx = zeros(size(frame));
    dy = zeros(size(frame));
    for j=1:length(fiducials(i).frame)
        id = find(frame==fiducials(i).frame(j));
        dx(id) = dx_temp(j);
        dy(id) = dy_temp(j);
    end
    
    fiducials(i).dx = dx_temp; % for plotting the drift
    fiducials(i).dy = dy_temp; % for plotting the drift
    fiducials(i).dx_correction = dx; % for correcting drift
    fiducials(i).dy_correction = dy; % for correcting drift
    
end

% average drift corrections of fiducials ()
for i=1:length(fiducials)
    if i==1
        dx = fiducials(i).dx_correction;
        dy = fiducials(i).dy_correction;
    else
        dx = cat(2,dx,fiducials(i).dx_correction);
        dy = cat(2,dy,fiducials(i).dy_correction);
    end
end

dx(dx == 0) = NaN;
dx = nanmean(dx,2);
dx(isnan(dx)) = 0;

dy(dy == 0) = NaN;
dy = nanmean(dy,2);
dy(isnan(dy)) = 0;

% Undo calculated drift
x = x - dx;
y = y - dy;

% Plot summary of fiducials
fig2 = figure;
for i=1:length(fiducials)

    drift_x = fiducials(i).dx;
    drift_y = fiducials(i).dy;

    subplot(length(fiducials),3,3*(i-1)+1)
    plot(fiducials(i).frame,drift_x); hold on; plot(fiducials(i).frame,drift_y); legend('drift x','drift y')
    xlabel('Frame')
    ylabel('Relative drift')
    title(['Fiducial #' num2str(i)])

    subplot(length(fiducials),3,3*(i-1)+2)
    N = 100;
    color = hsv(ceil(length(drift_x)/N));
    for j=1:N:length(drift_x)-N
        plot(drift_x(j:j+N),drift_y(j:j+N),'Color',color(ceil(j/N),:))
        hold on
    end
    hold on;
    plot(drift_x(1),drift_y(1),'.k','MarkerSize',20)
    plot(drift_x(end),drift_y(end),'.k','MarkerSize',20)
    grid on
    xlabel('Relative drift in x')
    ylabel('Relative drift in y')
    title(['Fiducial #' num2str(i)])

    subplot(length(fiducials),3,3*(i-1)+3)
    histogram(diff(fiducials(i).x)); hold on
    histogram(diff(fiducials(i).y))
    legend('dx','dy')
    xlabel('dx, dy'); ylabel('Occurence');
    title(['Fiducial #' num2str(i)])
end

end