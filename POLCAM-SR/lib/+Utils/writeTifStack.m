function [] = writeTifStack(stack,filepath)

% set up tif for intensity
t = Tiff(filepath,'w');
tagstruct.ImageLength = size(stack,1); % image height
tagstruct.ImageWidth  = size(stack,2); % image width
tagstruct.Compression = Tiff.Compression.None;
tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP;
tagstruct.Photometric = Tiff.Photometric.LinearRaw;
tagstruct.BitsPerSample = 32;
tagstruct.SamplesPerPixel = 1;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.Software = 'MATLAB';

% write away first frame (to overwrite rather than append to an existing stack)
setTag(t,tagstruct)
write(t,squeeze(single(stack(:,:,1))));

% read file frame by frame
for i = 2:size(stack,3)    
    writeDirectory(t);
    setTag(t,tagstruct)
    write(t,squeeze(single(stack(:,:,i)))); % Append
end
close(t);
end