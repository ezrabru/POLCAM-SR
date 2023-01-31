classdef Camera
    %CAMERA object contains camera properties and models.
    
    properties
        camPixSize % size camera pixels
        imgSize % size of one frame [rows cols]
        polariserUnitMosaic % a unit of the polarizer mosaic pattern (top left corner)
        camOffset % camera offset from calibration
        camGain % camera gain from calibration
        camVariance % camera variance from calibration
        QE % quantum efficiency camera
        
        masks
        mask00
        mask01
        mask10
        mask11
        
        imgSizeEven
    end
    
    methods
        
        function obj = Camera(camPixSize,imgSize,polariserUnitMosaic,camOffset,camGain,camVariance,QE)
            %CAMERA Construct an instance of this class
            obj.camPixSize = camPixSize;
            obj.imgSize = imgSize;
            obj.polariserUnitMosaic = polariserUnitMosaic;
            obj.camOffset = camOffset;
            obj.camGain = camGain;
            obj.camVariance = camVariance;
            obj.QE = QE;
            
            % images should have an even number of rows and columns
            imgSizeEven = imgSize;
            if mod(imgSize(1),2); imgSizeEven(1) = imgSize(1) - 1; end
            if mod(imgSize(2),2); imgSizeEven(2) = imgSize(2) - 1; end
            obj.imgSizeEven = imgSizeEven;
            
            [masks,mask00,mask01,mask10,mask11] = obj.getMasksPolarizerArray;
            obj.masks  = masks;
            obj.mask00 = mask00;
            obj.mask01 = mask01;
            obj.mask10 = mask10;
            obj.mask11 = mask11;
        end
        
        function [masks,mask00,mask01,mask10,mask11] = getMasksPolarizerArray(obj)
            %GETMASKSPOLARIZERARRAY Get binary masks for the differently
            %oriented polarisers in the image plane.
            
            % generate the masks for the correct number of pixels or slightly more
            numRows = obj.imgSizeEven(1);
            numCols = obj.imgSizeEven(2);
            numRepsMosaic = ceil(max(numRows,numCols)/2);
            [mask00,mask01,mask10,mask11] = obj.getMosaicMasks(numRepsMosaic);
                        
            % remove any excess rows or columns
            mask00 = mask00(1:numRows,1:numCols);
            mask01 = mask01(1:numRows,1:numCols);
            mask10 = mask10(1:numRows,1:numCols);
            mask11 = mask11(1:numRows,1:numCols);

            % assign masks to right pixels
            try
                switch obj.polariserUnitMosaic(1,1)

                    case 0 % top left pixel of image has a polarizer with transmission axis at 0 degrees
                        masks.mask0  = mask00;
                        masks.mask90 = mask11;
                        if obj.polariserUnitMosaic(1,2) == 45
                            masks.maskp45 = mask01;
                            masks.maskn45 = mask10;
                        else
                            masks.maskp45 = mask10;
                            masks.maskn45 = mask01;
                        end

                    case -45 % top left pixel of image has a polarizer with transmission axis at -45 degrees
                        masks.maskn45 = mask00;
                        masks.maskp45 = mask11;
                        if obj.polariserUnitMosaic(1,2) == 0
                            masks.mask0  = mask01;
                            masks.mask90 = mask10;
                        else
                            masks.mask0  = mask10;
                            masks.mask90 = mask01;
                        end

                    case 45 % top left pixel of image has a polarizer with transmission axis at 45 degrees
                        masks.maskp45 = mask00;
                        masks.maskn45 = mask11;
                        if obj.polariserUnitMosaic(1,2) == 0
                            masks.mask0  = mask01;
                            masks.mask90 = mask10;
                        else
                            masks.mask0  = mask10;
                            masks.mask90 = mask01;
                        end

                    case 90 % top left pixel of image has a polarizer with transmission axis at 90 degrees
                        masks.mask90 = mask00;
                        masks.mask0  = mask11;
                        if obj.polariserUnitMosaic(1,2) == 45
                            masks.maskp45 = mask01;
                            masks.maskn45 = mask10;
                        else
                            masks.maskp45 = mask10;
                            masks.maskn45 = mask01;
                        end
                end        
            catch            
                fprintf('Unexpected value for input variable "mosaic_unit" in method "getMasksPolarizerArray" in class "Camera".')
            end
        end

    end    
    
    methods (Static)
        
        function [mask00,mask01,mask10,mask11] = getMosaicMasks(numRepsMosaic)
            %GETMICROARRAYMASKS Get masks for a 2x2 repeating unit
            %polariser microarray sensor.
            mask00 = [1 0; 0 0]; mask00 = repmat(mask00,numRepsMosaic);
            mask01 = [0 1; 0 0]; mask01 = repmat(mask01,numRepsMosaic);
            mask10 = [0 0; 1 0]; mask10 = repmat(mask10,numRepsMosaic);
            mask11 = [0 0; 0 1]; mask11 = repmat(mask11,numRepsMosaic);
        end
        
    end
    
end
