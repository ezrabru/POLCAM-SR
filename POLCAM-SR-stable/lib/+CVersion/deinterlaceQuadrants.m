function [img00,img01,img10,img11] = deinterlaceQuadrants(img,mask00,mask01,mask10,mask11)
% DEINTERLACEQUADRANTS deinterlace the pixels of 1 image into 4 images
% using binary masks. This function will only work in the case of masks
% like those for a 4-channel polarisation camera.
%
% input:
%   img    - nxm array, the input image
%   mask00 - nxm array, binary mask specifying location pixels with
%            polarizer at same orientation as pixel img(1,1)
%   mask01 - nxm array, binary mask specifying location pixels with
%            polarizer at same orientation as pixel img(1,2)
%   mask10 - nxm array, binary mask specifying location pixels with
%            polarizer at same orientation as pixel img(2,1)
%   mask11 - nxm array, binary mask specifying location pixels with
%            polarizer at same orientation as pixel img(2,2)
%
% output:
%   img00 - pxq array, image formed by pixels in img masked by mask00
%   img01 - pxq array, image formed by pixels in img masked by mask01
%   img10 - pxq array, image formed by pixels in img masked by mask10
%   img11 - pxq array, image formed by pixels in img masked by mask11
[nx,ny] = size(img);
img00 = reshape(img(mask00==1),nx/2,ny/2);
img01 = reshape(img(mask01==1),nx/2,ny/2);
img10 = reshape(img(mask10==1),nx/2,ny/2);
img11 = reshape(img(mask11==1),nx/2,ny/2);
end