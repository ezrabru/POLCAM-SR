function filelist = getOrderedImageFilelist(directory,baseNameWithoutIdx)

% get list of all files with csv and tif extension in respective folders
filelist_tif = dir(fullfile(directory,'*.tif'));

% remove files that start with '.' (sometimes there are hidden files on mac)
filelist_tif = filelist_tif(~startsWith({filelist_tif.name},'.'));

if isempty(filelist_tif)
    filelist = 0;
else
    filelist = struct;
    for i=1:length(filelist_tif)
        [~,baseName_img,~] = fileparts(filelist_tif(i).name);
        if contains(baseName_img, baseNameWithoutIdx)
            filelist(i).filepath = fullfile(directory,filelist_tif(i).name);
            filelist(i).baseName = baseName_img;
        end
    end
    
    % sort filenames based on suffix to get correct frame numbers (ASSUMES THORCAM INDEXING)
    for i=1:length(filelist)
        filelist(i).id = str2double(extractAfter(filelist(i).baseName,baseNameWithoutIdx));
    end
    [~,idx] = sort([filelist.id]);
    filelist = filelist(idx);
end

end