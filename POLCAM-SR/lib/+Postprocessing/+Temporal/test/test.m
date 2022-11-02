% Simulate temporal grouping data

clear all; close all; clc

% parameters simulated data
pointSeparation = 200;
sigma_xy = 10;
numFrames = 500;

tic % start timer

%% Simulate data

% simulate a 5x5 grid of points, each point having an increasing average bound time
data = [];
avgTimeBound = 1; % wil increment in each loop
for i=1:3
    for j=1:3
        
        % true position of the point
        xc = (i-1)*pointSeparation;
        yc = (j-1)*pointSeparation;
        zc = 0;

        % generate numFrames frames worth of localisations for this point
        newData = simulateTemporallyGroupedPoint(avgTimeBound,numFrames,sigma_xy);
        newData.x = newData.x + xc;
        newData.y = newData.y + yc;
        newData.z = newData.z + zc;
        data = [data; newData];

        % increase average bound time for next point
        avgTimeBound = avgTimeBound + 1;
        
    end
end


%% Temporal grouping

maxDist = 6*sigma_xy;
[dataGrouped,indeces] = temporalGrouping(data,maxDist);

figure;
scatter3(dataGrouped.x,dataGrouped.y,dataGrouped.z,30,dataGrouped.len,'filled');
c = colorbar; colormap(jet)
c.Title.String = 'Number of frames bound';
axis equal
caxis([0 9])


toc