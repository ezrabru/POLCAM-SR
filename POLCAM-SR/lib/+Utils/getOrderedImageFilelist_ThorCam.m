function filelist = getOrderedImageFilelist_ThorCam(directory)

% get list of all files with tif extension
filelist_tif = dir(fullfile(directory,'*.tif'));

% remove files that start with '.' (sometimes there are hidden files on mac)
filelist_tif = filelist_tif(~startsWith({filelist_tif.name},'.'));

if isempty(filelist_tif)
    filelist = 0;
else
    filelist = struct;
    for i=1:length(filelist_tif)
        [~,baseName_img,~] = fileparts(filelist_tif(i).name);
        filelist(i).filepath = fullfile(directory,filelist_tif(i).name);
        filelist(i).baseName = baseName_img;

        % find position of underscores '_' in filename
        indeces_underscore = strfind(filelist(i).baseName,'_');
        % get the index of the last underscore
        index_last_underscore = indeces_underscore(end);
        filelist(i).id = str2double(filelist(i).baseName(index_last_underscore+1:end));
    end
    % sort filenames based on suffix to get correct frame numbers
    [~,idx] = sort([filelist.id]);
    filelist = filelist(idx);
end

end