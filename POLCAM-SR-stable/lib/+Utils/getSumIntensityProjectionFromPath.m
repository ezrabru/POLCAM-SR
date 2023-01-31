function projection = getSumIntensityProjectionFromPath(filepath)
% GETSUMINTENSITYPROJECTIONFROMPATH
tr = Tiff(filepath,'r'); % set up object for reading frame by frame
projection = double(tr.read()); % read first frame
if tr.lastDirectory()
    return
else
    tr.nextDirectory();
    while true % read remaining frames
        projection = projection + double(tr.read());
        if tr.lastDirectory(); break;
        else; tr.nextDirectory();
        end
    end
end
close(tr)
end