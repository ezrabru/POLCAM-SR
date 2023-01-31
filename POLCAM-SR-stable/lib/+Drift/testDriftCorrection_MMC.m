%% Test MCC drift correction on simulated dataset
%
% Script to simulate an SMLM localization file with drift to test
% drift-correction approaches on.
%
% The 'sample' is a circle and has two fiducials in it. To be somewhat
% realistic, the fiducial is not detected in all frames.
%
% Author: Ezra Bruggeman, Lee Lab, University of Cambridge
%         eb758@cam.ac.uk
%
% Last modified: 4 March 2022


clear all
close all
clc

segmentation   = 500;
linear_drift_x = 5/segmentation; % nm/frame
linear_drift_y = -10/segmentation; % nm/frame

numFrames      = 5000; % total number of frames simulated
sigma_sample   = 50; % nm, standard deviation gaussian noise on localisation error sample
sigma_fiducial = 10; % nm, standard deviation gaussian noise on localisation error fiducial
pixelsize      = 57.5; % nm, pixel size (in sample space)

rate_sample    = 5; % localisations per frame from sample (should be > 1)
rate_fiducial  = 0.95; % localisations per frame from fiducial (should be <= 1)

radius_circle  = 400; % nm, radius of sample, which is a circle

% can be multiple
x_fiducial = [1000,1100];
y_fiducial = [1000,600];

outputdir = fullfile(pwd,'simulated drift files'); % path to folder were results will be saved


%% Simulate dataset

[frame,x,y] = simulateDriftDataset(linear_drift_x,linear_drift_y,...
    numFrames,radius_circle,x_fiducial,y_fiducial,sigma_sample,sigma_fiducial,...
    rate_sample,rate_fiducial);

figure;
scatter(x,y,20,frame,'.')
axis equal; grid on
xlabel('x (nm)')
ylabel('y (nm)')
title('Before drift correction','FontWeight','normal')

filter = ones(size(x));

%% MCC

numFramesSlidingWindow = 1000;
frameInterval = 50; % evaluate every 100 frames


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




%%

lw = 1.5;

figure('Position',[50 50 800 300])

subplot(1,2,1)
plot(dx,'b','LineWidth',lw); hold on
plot(dy,'r','LineWidth',lw)
legend('x','y','Location','southwest')

subplot(1,2,2)
plot(dx,dy,'Color',0.5*[1 1 1],'LineWidth',lw); hold on
scatter(dx,dy,5,1:max(frame_filter),'filled')
axis equal; axis square; grid on
colorbar




%% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% simulateDriftDataset.m
% 
% Function to simulate an SMLM localisation file with drift and fiducials.
% The sample is a circle of a certain radius and an arbitrary number of
% fiducials can be added by specifying their (x,y) coordinates. The
% localisation precision of the sample and fiducials can be specified
% separately (fiducials should have better localisation precision because
% they are brighter). The localisation rate of the sample and fiducial can
% be set separately. The fiducials should be detected in all or most
% frames.
% 
% @param linear_drift_x: float, linear drift in x-direction (nm/frame)
% @param linear_drift_y: float, linear drift in y-direction (nm/frame)
% @param numFrames.....: int, total number of frames simulated
% @param radius_circle.: float, radius of sample which is a circle (nm)
% @param x_fiducial....: array, x-coordinates of fiducials (nm)
% @param y_fiducial....: array, y-coordinates of fiducials (nm)
% @param sigma_sample..: float, stdev gaussian noise on coordinates sample (nm)
% @param sigma_fiducial: float, stdev gaussian noise on coordinates fiducial (nm)
% @param rate_sample...: int > 1, localisations per frame from sample
% @param rate_fiducial.: 0<float<=1, localisations per frame from fiducial

function [frame,x,y] = simulateDriftDataset(linear_drift_x,linear_drift_y,...
    numFrames,radius_circle,x_fiducial,y_fiducial,sigma_sample,sigma_fiducial,...
    rate_sample,rate_fiducial)

numFiducials = length(x_fiducial);
results = struct;
count = 1;
for i=1:numFrames
    
    for j=1:rate_sample
        theta = randi(360);
        results(count).frame = i;
        results(count).x = radius_circle*cos(theta) + normrnd(0,sigma_sample) + linear_drift_x*i;
        results(count).y = radius_circle*sin(theta) + normrnd(0,sigma_sample) + linear_drift_y*i;
        count = count + 1;
    end
    
    for j=1:numFiducials
        if rand < rate_fiducial
            results(count).frame = i;
            results(count).x = x_fiducial(j) + normrnd(0,sigma_fiducial) + linear_drift_x*i;
            results(count).y = y_fiducial(j) + normrnd(0,sigma_fiducial) + linear_drift_y*i;
            count = count + 1;
        end
    end
    
end

frame = [results.frame]';
x = [results.x]'; x = x + abs(min(x));
y = [results.y]'; y = y + abs(min(y));

end