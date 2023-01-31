%% Drift correction of SMLM data
%
% This script takes in a localisation file (containing at least a column
% with frame, x and y). A window will appear propmting the user to select
% fiducial-based drift correction or redundant cross-correlation (RCC).
% In the case of fiducial-based drift correction, a scatter plot of the
% data on top of a 2d histogram rendering will be displayed and the user
% will be asked to draw rectangles around fiducials. They can pick one or
% multiple fiducials; a question will pop up in the command window asking
% whether they want to pick another one or stop.
% 
% Author: Ezra Bruggeman, Lee Lab, University of Cambridge
%         eb758@cam.ac.uk
%
% Last modified: 12 Jan 2021


clear all; close all; clc
addpath('lib')

% Ask user what type of drift correction to use
answer = questdlg('Select a drift-correction method.','Pick method', ...
    'Fiducial','RCC','Cancel','Fiducial');
% Handle response
switch answer
    case 'Fiducial'
        disp([answer '-based drift correction selected.'])
        fiducial = 1; rcc = 0;
    case 'RCC'
        disp([answer ' drift correction selected.'])
        fiducial = 0; rcc = 1;
    case 'Cancel'
        disp('Ended by user.'); return;
end

% should open a window to navigate to file
filepath   = 'E:\data\PolCam manuscript\20201215_fibrils nile red super-res\fibrils_NileRed_TS_50ms_roi2\results\results.txt';
[file,path] = uigetfile('*','Select localisation file');
if isequal(file,0); disp('Ended by user.'); return; end % if user clicks cancel
filepath = fullfile(path,file);

% Ask for columns
prompt = {'Column containing frame','Column containing x coordinates','Column containing y coordinates'};
dlgtitle = 'Specify columns in localisation file';
dims = [1 60];
definput = {'2','3','4'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
if isempty(answer); disp('Ended by user.'); return; end % if user clicks cancel
column_frame = str2double(answer{1});
column_x     = str2double(answer{2});
column_y     = str2double(answer{3});

% Ask pixel size
prompt = {'Virtual pixel size (as set during localisation)'};
dlgtitle = 'Pixel size';
dims = [1 50];
definput = {'57.5'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
if isempty(answer); disp('Ended by user.'); return; end % if user clicks cancel
pixelsize = str2double(answer{1}); % nm


%% Read file
    
[directory,nameBase,~] = fileparts(filepath);
path_output = fullfile(directory,[nameBase '_drift_suppl']);
if ~exist(path_output,'dir'); mkdir(path_output); end

disp('Reading files...')
localisations = readmatrix(filepath);
frame   = localisations(:,column_frame);
x       = localisations(:,column_x);
y       = localisations(:,column_y);
file_id = localisations(:,1);

% Get the header
fid = fopen(filepath);
header = strsplit(fgetl(fid), ',');
fclose(fid);


%% Process

if rcc
    
    % Ask for segmentation parameter
    prompt = {'Number of frames per segment'};
    dlgtitle = 'RCC parameter';
    dims = [1 40];
    definput = {'2000'};
    segmentation = inputdlg(prompt,dlgtitle,dims,definput);
    
    pixelsize_hist = pixelsize;
    [x_corr,y_corr,dx,dy] = correctDriftRCC(frame,x,y,str2double(segmentation{1}),pixelsize_hist);

    fig = figure('Name','RCC drift correction');
    set(0,'DefaultAxesTitleFontWeight','normal');
    subplot(2,2,1)
    plot(dx,'-xb'); hold on
    plot(dy,'-xr');
    legend('dx','dy','Location','northwest');
    xlabel('Frame'); ylabel('Drift (nm)')
    xlim([-inf inf]);

    subplot(2,2,2)
    plot(dx,dy,'Color',0.5*[1,1,1]); hold on
    scatter(dx,dy,30,[1:length(dx)]')
    xlabel('x (nm)'); ylabel('y (nm)'); grid on
    title('Drift trajectory');
    xlim([-inf inf]); ylim([-inf inf]);

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
    
    savefig(fig,fullfile(path_output,'esimated_drift_rcc.fig'))
    
    % Replace x and y coordinates in original localisation file
    localisations(:,column_x) = x_corr;
    localisations(:,column_y) = y_corr;

    % Save drift-corrected version of data to new file
    T = array2table(localisations,'VariableNames',header);
    writetable(T,fullfile(path,[nameBase '_drift_corrected_rcc.txt']));
    
elseif fiducial
    
    [x_corr,y_corr,dx,dy,fig1,fig2] = correctDriftFiducial(frame,x,y,pixelsize,1);
    
    savefig(fig1,fullfile(path_output,'fiducials.fig'))
    savefig(fig2,fullfile(path_output,'summary_per_fiducial.fig'))
    
    fig = figure('Name','Fiducial-based drift correction');
    set(0,'DefaultAxesTitleFontWeight','normal');

    subplot(2,2,1)
    plot(dx,'b'); hold on
    plot(dy,'r');
    legend('dx','dy','Location','northwest');
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
    
    savefig(fig,fullfile(path_output,'esimated_drift_fiducial.fig'))
    
    % Replace x and y coordinates in original localisation file
    localisations(:,column_x) = x_corr;
    localisations(:,column_y) = y_corr;

    % Save drift-corrected version of data to new file
    T = array2table(localisations,'VariableNames',header);
    writetable(T,fullfile(path,[nameBase '_drift_corrected_fiducial.txt']));
    
else
    return
end

disp('Done!')
disp(['Results are saved in "' path_output '"'])