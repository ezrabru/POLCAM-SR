function projection = getAverageIntensityProjectionFromPath(filepath)
% GETAVERAGEINTENSITYPROJECTIONFROMPATH
tr = Tiff(filepath,'r'); % set up object for reading frame by frame
count = 1;
avg = double(tr.read()); % read first frame
if tr.lastDirectory()
    return
else
    tr.nextDirectory();
    while true % read remaining frames
        avg = avg + double(tr.read());
        count = count + 1;
        if tr.lastDirectory(); break;
        else; tr.nextDirectory();
        end
    end
end
close(tr)
projection = avg/count;
end