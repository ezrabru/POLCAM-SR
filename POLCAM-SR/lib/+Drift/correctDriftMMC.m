function [x,y,dx,dy] = correctDriftMMC(frame,x,y,filter,...
                            numFramesSlidingWindow,frameInterval)

% select only filtered localisations for drift correction
frame_filter = frame(logical(filter));
x_filter     = x(logical(filter));
y_filter     = y(logical(filter));

frame_filter = frame_filter - min(frame_filter) + 1;
numFrames    = max(frame_filter);

numSteps = numFrames - 2*ceil(numFramesSlidingWindow/2);
steps = ceil(numFramesSlidingWindow/2):numFrames - ceil(numFramesSlidingWindow/2)-1;

% Initialize drift correction
avgPositionX = zeros(size(1:frameInterval:numSteps));
avgPositionY = avgPositionX;
count = 1;
for i=1:frameInterval:numSteps
    
    % get frame number that belong in this window
    frames_i = steps(i):steps(i)+numFramesSlidingWindow-1;
    
    x_filter_window = [];
    y_filter_window = [];
    for j=1:numFramesSlidingWindow
        x_filter_window = [x_filter_window; x_filter(frame_filter == frames_i(j))];
        y_filter_window = [y_filter_window; y_filter(frame_filter == frames_i(j))];
    end

    avgPositionX(count) = mean(x_filter_window);
    avgPositionY(count) = mean(y_filter_window);
    count = count + 1;
end

% interpolate between sampling points
frame_sampled = (1:frameInterval:numSteps) + ceil(numFramesSlidingWindow/2);
frame_query = (1:numSteps - 1) + ceil(numFramesSlidingWindow/2);

avgPositionX_interp = interp1(frame_sampled,avgPositionX,frame_query,'spline');
avgPositionY_interp = interp1(frame_sampled,avgPositionY,frame_query,'spline');


% Set drift estimate at the borders (in time) where sliding average could
% not be calculated equal to the first and last average position estimate
avgPositionX = nan(1,max(frame_filter));
id_start = ceil(numFramesSlidingWindow/2);
id_end   = id_start + numel(avgPositionX_interp);
avgPositionX(1:id_start-1)      = avgPositionX_interp(1);
avgPositionX(id_start:id_end-1) = avgPositionX_interp(:);
avgPositionX(id_end+1:end)      = avgPositionX_interp(end);

avgPositionY = nan(1,max(frame_filter));
id_start = ceil(numFramesSlidingWindow/2);
id_end   = id_start + numel(avgPositionX_interp);
avgPositionY(1:id_start-1)      = avgPositionY_interp(1);
avgPositionY(id_start:id_end-1) = avgPositionY_interp(:);
avgPositionY(id_end+1:end)      = avgPositionY_interp(end);

% Get the drift
dx = avgPositionX - avgPositionX(1);
dy = avgPositionY - avgPositionY(1);

% Undo calculated drift
x_driftCorrected = zeros(size(x));
y_driftCorrected = zeros(size(y));
unique_frames = unique(frame);
for i=1:numel(unique_frames)
    keep = (frame == unique_frames(i));
    x_driftCorrected(keep) = x(keep) - dx(i);
    y_driftCorrected(keep) = y(keep) - dy(i);
end

x = x_driftCorrected;
y = y_driftCorrected;

end