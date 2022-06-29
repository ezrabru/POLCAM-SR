function [] = writeJsonFile(myStruct,filepath)
%WRITEJSONFILE

% encode struct as json format
jsonFormat = jsonencode(myStruct,'PrettyPrint',true);

% write json file
fid = fopen(filepath,'w');
fprintf(fid,'%s',jsonFormat);
fclose(fid);

end