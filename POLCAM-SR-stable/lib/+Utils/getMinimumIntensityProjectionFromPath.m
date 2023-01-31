function projection = getMinimumIntensityProjectionFromPath(filepath)
% GETMINIMUMINTENSITYPROJECTIONFROMPATH
tr = Tiff(filepath,'r'); % set up object for reading frame by frame
projection = double(tr.read()); % read first frame
if tr.lastDirectory()
    return
else
    tr.nextDirectory();
    while true % read remaining frames
        projection = min(cat(3,projection,double(tr.read())),[],3);
        if tr.lastDirectory(); break;
        else; tr.nextDirectory();
        end
    end
end
close(tr)
end