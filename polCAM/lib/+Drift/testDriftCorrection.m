%% Test drift correction on simulated dataset
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
% Last modified: 10 Jan 2021


clear all
close all
clc
addpath('lib')

segmentation = 500;
linear_drift_x = 5/segmentation; % nm/frame
linear_drift_y = -10/segmentation; % nm/frame

numFrames = 5000; % total number of frames simulated
sigma_sample = 50; % nm, standard deviation gaussian noise on localisation error sample
sigma_fiducial = 10; % nm, standard deviation gaussian noise on localisation error fiducial
pixelsize = 57.5; % nm, pixel size (in sample space)

rate_sample = 5; % localisations per frame from sample (should be > 1)
rate_fiducial = 0.95; % localisations per frame from fiducial (should be <= 1)

radius_circle = 400; % nm, radius of sample, which is a circle

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
colormap jet; axis equal; grid on
xlabel('x (nm)')
ylabel('y (nm)')
title('Before drift correction')


%% RCC

pixelsize_hist = pixelsize/10;
[x_corr,y_corr,dx,dy] = correctDriftRCC(frame,x,y,segmentation,pixelsize_hist);

figure('Name','RCC drift correction');
set(0,'DefaultAxesTitleFontWeight','normal');
subplot(2,2,1)
t = linspace(0,numFrames,floor(numFrames/segmentation));
plot(t,linear_drift_x*t,'b'); hold on
plot(t,dx,'--b');
plot(t,linear_drift_y*t,'r');
plot(t,dy,'--r');
legend('dx_{true}','dx_{est}','dy_{true}','dy_{est}','Location','northwest');
xlabel('Frame'); ylabel('Drift (nm)')
xlim([-inf inf]);

subplot(2,2,2)
plot(dx,dy,'Color',0.5*[1,1,1]); hold on
scatter(dx,dy,20,t)
xlabel('x (nm)'); ylabel('y (nm)'); grid on
title('Drift trajectory')
xlim([-inf inf]); ylim([-inf inf])

subplot(2,2,3); scatter(x,y,20,frame,'.')
colormap parula; grid on
xlabel('x (nm)')
ylabel('y (nm)')
title('Before drift correction')
subplot(2,2,4); scatter(x_corr,y_corr,20,frame,'.')
colormap parula; grid on
xlabel('x (nm)')
ylabel('y (nm)')
title('After drift correction')



%% Fiducial-based drift correction

[x_corr,y_corr,dx,dy] = correctDriftFiducial(frame,x,y,pixelsize,1);

figure('Name','Fiducial-based drift correction');
set(0,'DefaultAxesTitleFontWeight','normal');

subplot(2,2,1)
t = linspace(0,numFrames,floor(numFrames/segmentation));
plot(dx,'b'); hold on
plot(dy,'r');
legend('dx_{est}','dy_{est}','Location','northwest');
xlabel('Frame'); ylabel('Drift (nm)')
xlim([-inf inf]);

subplot(2,2,2)
plot(dx,dy,'Color',0.5*[1,1,1]); hold on
scatter(dx,dy,20,1:length(dx))
xlabel('x (nm)'); ylabel('y (nm)'); grid on
title('Drift trajectory')
xlim([-inf inf]); ylim([-inf inf])

subplot(2,2,3); scatter(x,y,20,frame,'.')
colormap parula; grid on
xlabel('x (nm)')
ylabel('y (nm)')
title('Before drift correction')
subplot(2,2,4); scatter(x_corr,y_corr,20,frame,'.')
colormap parula; grid on
xlabel('x (nm)')
ylabel('y (nm)')
title('After drift correction')


