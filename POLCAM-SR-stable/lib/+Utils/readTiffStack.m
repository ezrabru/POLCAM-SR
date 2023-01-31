function stack = readTiffStack(filepath)
% READTIFFSTACK
warning('off','all') % Suppress all the tiff warnings
tr = Tiff(filepath);
[nx,ny] = size(tr.read());
nz = length(imfinfo(filepath));
stack = zeros(nx,ny,nz);
stack(:,:,1) = tr.read();
for n = 2:nz
    tr.nextDirectory()
    stack(:,:,n) = tr.read();
end
warning('on','all')
end
