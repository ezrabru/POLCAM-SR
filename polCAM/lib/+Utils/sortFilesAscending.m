function filenamesSorted = sortFilesAscending(filenames)

filenameNumChar = sort(unique(strlength(filenames)),'ascend');

filenamesSorted = cell(numel(filenames),1);
count = 0;
for i=1:numel(filenameNumChar)
    filenames_i = filenames(strlength(filenames) == filenameNumChar(i));
    filenames_i = sort(filenames_i); % default sorting = ascending
    for j=1:numel(filenames_i)
        count = count + 1;
        filenamesSorted(count) = {filenames_i{j}};
    end
end

end