function data = simulateTemporallyGroupedPoint(avgTimeBound,numFrames,sigma_xy)

data = [];
frame = 1;
for i = 1:numFrames

    if rand > 0.95 % turn it on with some probability
        for j = 1:avgTimeBound
            x = randn*sigma_xy;
            y = randn*sigma_xy;
            z = randn*sigma_xy;
            int = 1;
            newLine = [frame x y z int];
            data = [data; newLine];
            frame = frame + 1;
        end
    else
        frame = frame + 1;
    end

end

data = array2table(data,'VariableNames',{'frame','x','y','z','photons'});

end