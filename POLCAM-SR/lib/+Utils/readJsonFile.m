function myStruct = readJsonFile(filepath)
%READJSONFILE

% read entire file
fid = fopen(filepath,'r');
A = fscanf(fid,'%c'); % format specifications c for char (not s for string, as that ignores spaces)
fclose(fid);

% decode json format into struct
myStruct = jsondecode(A);

end