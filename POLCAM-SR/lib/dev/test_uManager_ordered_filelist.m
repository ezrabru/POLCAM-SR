
close all
clear all
clc

directory = '/Users/ezrabruggeman/Desktop/test MM';


%%

% get list of all files with tif extension
filelist_tif = dir(fullfile(directory,'*_MMStack_Default.ome.tif'));

% remove files that start with '.' (sometimes there are hidden files on mac)
filelist_tif = filelist_tif(~startsWith({filelist_tif.name},'.'));

if isempty(filelist_tif)
    filelist = 0;
else
    % sort files in ascending order
    filelist_tif = struct2table(filelist_tif);
    filelist_tif = sortrows(filelist_tif,'name','ascend');
    
    % format for POLCAM-SR
    filelist = struct;
    for i=1:height(filelist_tif)
        [~,baseName_img,~] = fileparts(filelist_tif.name(i));
        filelist(i).filepath = char(fullfile(directory,filelist_tif.name(i)));
        filelist(i).baseName = extractBefore(baseName_img,'_MMStack_Default.ome');
    end
    
    % sort filenames based on suffix to get correct frame numbers (ASSUMES THORCAM INDEXING)
    for i=1:length(filelist)
        % find position of underscores '_' in filename
        indeces_underscore = strfind(filelist(i).baseName,'_');
        % get the index of the last underscore
        index_last_underscore = indeces_underscore(end);
        % extract the number after the last underscore
        filelist(i).id = str2double(filelist(i).baseName(index_last_underscore+1:end));
    end
    [~,idx] = sort([filelist.id]);
    filelist = filelist(idx);
end


