classdef Microscope
    %MICROSCOPE object contains microscope properties.
    
    properties
        Camera % instance of the camera class
        NA % numerical aperture of the objective
        magnification % total system magnification
        nImmersion % refractive index immersion medium (e.g. 1.518 for oil)
        
        virtualPixelSize % virtual pixel size in nm
    end
    
    methods
        
        function obj = Microscope(Camera,NA,magnification,nImmersion)
            %MICROSCOPE Construct an instance of this class
            obj.Camera = Camera;
            obj.NA = NA;
            obj.magnification = magnification;
            obj.nImmersion = nImmersion;
            
            obj.virtualPixelSize = 1e3*obj.Camera.camPixSize/obj.magnification;
        end
        
    end
    
    methods (Static)
        
        %...
        
    end
    
end
