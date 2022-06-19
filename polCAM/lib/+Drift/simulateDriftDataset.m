%% simulateDriftDataset.m
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