classdef Process
    %PROCESS object contains properties and methods to process
    %polarisation camera images.
    
    properties
        Microscope % instance of the Microscope class
        Camera % instance of the Camera class
        bkgndEstimation % method for background estimation
        conversionMethod % method for converting raw image to stokes images
        localisationParams % localisation parameters
        
        border
        
        alpha
        A
        B
        C
    end
    
    methods
        
        function obj = Process(Microscope,Camera,bkgndEstimation,conversionMethod,localisationParams)
            %PROCESS Construct an instance of this class
            obj.Microscope        = Microscope;
            obj.Camera            = Camera;
            obj.bkgndEstimation   = bkgndEstimation;
            obj.conversionMethod  = conversionMethod;
            obj.localisationParams = localisationParams;
            
            obj.border = max([localisationParams.w.xy,localisationParams.w.phi,localisationParams.w.theta]) + 1;

            [obj.alpha,obj.A,obj.B,obj.C] = obj.getConstantsForThetaCalculation;
        end
        
        function locs = processFrame(obj,img,bkgnd)
            % PROCESSFRAME
            
            % remove a row and/or column if dimensions are not even
            img = img(1:obj.Camera.imgSizeEven(1),1:obj.Camera.imgSizeEven(2));
            img = (img - bkgnd - obj.Camera.camOffset)./(obj.Camera.camGain*obj.Camera.QE); % convert to photons

            [S0,S1,S2,DoLP,AoLP] = convertUnprocessed(obj,img);
            AoLP_shift = mod(AoLP + pi,pi) - pi/2; % get a version of AoLP that is shifted by 90 degrees
            
            [x,y] = find2DlocalisationCandidates(obj,S0);
            % figure; imshow(S0,[0 150]); colorbar; hold on; scatter(y,x,'or')
            
            locs = fit2Dlocalisations(obj,S0,x,y);
            % hold on; scatter([locs.y],[locs.x],'xg')
            
            if ~isempty(locs) % if there are localisations in the frame
                for i = 1:numel([locs.x])
                    [phi,theta,avgDoLP,netDoLP] = getOrientation(obj,x(i),y(i),S0,S1,S2,AoLP,AoLP_shift,DoLP);
                    locs(i).phi     = phi;
                    locs(i).theta   = theta;
                    locs(i).avgDoLP = avgDoLP;
                    locs(i).netDoLP = netDoLP;
                end
            else
                locs = nan;
            end
            
        end
        
        function [phi,theta,avgDoLP,netDoLP] = getOrientation(obj,x,y,S0,S1,S2,AoLP,AoLP_shift,DoLP)
            % GETORIENTATION
            
            % round to integer for cropping region out of images
            x = round(x);
            y = round(y);
            
            % theta estimation
            s0 = obj.cropToROI(S0,x,y,obj.localisationParams.w.theta); %imshow(kron(s0,ones(5)),[]); pause(0.1)
            s1 = obj.cropToROI(S1,x,y,obj.localisationParams.w.theta);
            s2 = obj.cropToROI(S2,x,y,obj.localisationParams.w.theta);
            
            weights = fspecial('disk',(2*obj.localisationParams.w.theta+1)/2); % calculate out-of-plane angle and netDoLP using weighted average (weights are a disk)
            weights = weights/sum(weights(:));
            S0_mean = nansum(weights.*s0,'all');
            S1_mean = nansum(weights.*s1,'all');
            S2_mean = nansum(weights.*s2,'all');
            netDoLP = sqrt((S1_mean.^2 + S2_mean.^2)./(S0_mean.^2));
            theta   = obj.getThetaFromNetDoLP(netDoLP);
            
            % phi estimation
            AoLP       = obj.cropToROI(AoLP,      x,y,obj.localisationParams.w.phi);
            AoLP_shift = obj.cropToROI(AoLP_shift,x,y,obj.localisationParams.w.phi);
            s0         = obj.cropToROI(S0,        x,y,obj.localisationParams.w.phi);
            dolp       = obj.cropToROI(DoLP,      x,y,obj.localisationParams.w.phi);
            
            weights = s0 - min(s0(:)); % calculate in-plane angle and avgDoLP using weighted average (weights from S0)
            weights = weights/sum(weights(:));
            avgDoLP = nansum(weights.*dolp,'all');
            
            % Coarse histogram to determine which quadrant most counts are in
            [countsCoarse,~] = histcounts(AoLP(:),-pi/2:pi/4:pi/2);
            Q1 = countsCoarse(1);
            Q2 = countsCoarse(2);
            Q3 = countsCoarse(3);
            Q4 = countsCoarse(4);
            if (Q2 + Q3 > Q1 + Q4)
                phi = nansum(weights.*AoLP,'all');
            else
                if Q1 > Q4
                    phi = nansum(weights.*AoLP_shift,'all')-pi/2;
                    if phi > pi/2; phi = phi - pi;
                    elseif phi < -pi/2; phi = phi + pi;
                    end
                else
                    phi = nansum(weights.*AoLP_shift,'all')+pi/2;
                    if phi > pi/2; phi = phi - pi;
                    elseif phi < -pi/2; phi = phi + pi;
                    end
                end
            end
            
        end

        function bkgnd = estimateBackground(obj,filepath)
            % ESTIMATEBACKGROUND Different methods to estimate
            % fluorescence background in the four polarised channels.
            
            warning('off','imageio:tiffmexutils:libtiffWarning'); % turn off a warning caused by format thorcam tif files that blows up the command window

            switch obj.bkgndEstimation.method

                case 'none'; bkgnd = 0;
                
                case 'medfilt mip'
                    mip = obj.getMinimumIntensityProjectionFromPath(filepath);
                    mip = mip(1:obj.Camera.imgSizeEven(1),1:obj.Camera.imgSizeEven(2));
                    mip = mip - obj.Camera.camOffset;
                    [bkgnd00,bkgnd01,bkgnd10,bkgnd11] = obj.deinterlaceQuadrants(mip,obj.Camera.mask00,obj.Camera.mask01,obj.Camera.mask10,obj.Camera.mask11);
                    params = obj.bkgndEstimation.params;
                    bkgnd00 = medfilt2(bkgnd00,[params.k params.k],'symmetric');
                    bkgnd01 = medfilt2(bkgnd01,[params.k params.k],'symmetric');
                    bkgnd10 = medfilt2(bkgnd10,[params.k params.k],'symmetric');
                    bkgnd11 = medfilt2(bkgnd11,[params.k params.k],'symmetric');
                    bkgnd = obj.interlaceQuadrants(bkgnd00,bkgnd01,bkgnd10,bkgnd11);
                    
                case 'medfilt avg'
                    avg = obj.getAverageIntensityProjectionFromPath(filepath);
                    avg = avg(1:obj.Camera.imgSizeEven(1),1:obj.Camera.imgSizeEven(2));
                    avg = avg - obj.Camera.camOffset;
                    [bkgnd00,bkgnd01,bkgnd10,bkgnd11] = obj.deinterlaceQuadrants(avg,obj.Camera.mask00,obj.Camera.mask01,obj.Camera.mask10,obj.Camera.mask11);
                    params = obj.bkgndEstimation.params;
                    bkgnd00 = medfilt2(bkgnd00,[params.k params.k],'symmetric');
                    bkgnd01 = medfilt2(bkgnd01,[params.k params.k],'symmetric');
                    bkgnd10 = medfilt2(bkgnd10,[params.k params.k],'symmetric');
                    bkgnd11 = medfilt2(bkgnd11,[params.k params.k],'symmetric');
                    bkgnd = obj.interlaceQuadrants(bkgnd00,bkgnd01,bkgnd10,bkgnd11);

                case 'medfilt med'
                    tr = Tiff(filepath,'r'); % set up object for reading frame by frame
                    params = obj.bkgndEstimation.params;
                    numFrames = length(imfinfo(filepath));
                    for i=1:numFrames
                        tr.nextDirectory();
                        img = double(tr.read());
                        img = img(1:obj.Camera.imgSizeEven(1),1:obj.Camera.imgSizeEven(2));
                        img = img - obj.Camera.camOffset;
                        [Q00,Q01,Q10,Q11] = obj.deinterlaceQuadrants(img,obj.Camera.mask00,obj.Camera.mask01,obj.Camera.mask10,obj.Camera.mask11);
                        if i==1
                            bkgnd00 = nan(size(Q00,1),size(Q00,2),numFrames);
                            bkgnd01 = nan(size(Q01,1),size(Q01,2),numFrames);
                            bkgnd10 = nan(size(Q10,1),size(Q10,2),numFrames);
                            bkgnd11 = nan(size(Q11,1),size(Q11,2),numFrames);
                        end
                        bkgnd00(:,:,i) = Q00;
                        bkgnd01(:,:,i) = Q01;
                        bkgnd10(:,:,i) = Q10;
                        bkgnd11(:,:,i) = Q11;
                    end
                    % temporal median projection
                    bkgnd00 = median(bkgnd00,3);
                    bkgnd01 = median(bkgnd01,3);
                    bkgnd10 = median(bkgnd10,3);
                    bkgnd11 = median(bkgnd11,3);
                    % spatial median filter
                    bkgnd00 = medfilt2(bkgnd00,[params.k params.k],'symmetric');
                    bkgnd01 = medfilt2(bkgnd01,[params.k params.k],'symmetric');
                    bkgnd10 = medfilt2(bkgnd10,[params.k params.k],'symmetric');
                    bkgnd11 = medfilt2(bkgnd11,[params.k params.k],'symmetric');
                    bkgnd = obj.interlaceQuadrants(bkgnd00,bkgnd01,bkgnd10,bkgnd11);
                    bkgnd = bkgnd(1:obj.Camera.imgSizeEven(1),1:obj.Camera.imgSizeEven(2));

                otherwise; disp('Unexpected value for variable "methodBkgndEstimation".'); return

            end
        end

        function [S0,S1,S2,DoLP,AoLP] = convertUnprocessed(obj,img)
            %CONVERTUNPROCESSED
            switch obj.conversionMethod
                case 'halveNumPix';          [S0,S1,S2] = estimatesStokes_halveNumPix(obj,img);
                case 'interpolation linear'; [S0,S1,S2] = estimatesStokes_interpolation(obj,img,'linear');
                case 'interpolation cubic';  [S0,S1,S2] = estimatesStokes_interpolation(obj,img,'cubic');
                case 'interpolation makima'; [S0,S1,S2] = estimatesStokes_interpolation(obj,img,'makima');
                case 'interpolation spline'; [S0,S1,S2] = estimatesStokes_interpolation(obj,img,'spline');
                case 'fourier';              [S0,S1,S2] = estimatesStokes_fourier(obj,img);
                otherwise; disp("The entered value of the property 'conversionMethod' of the class 'Process' is invalid.");
            end
            DoLP = obj.getDoLPFromStokes(S0,S1,S2); % degree of linear polarisation
            AoLP = obj.getAzimuthFromStokes(S1,S2); % angle of linear polarisation
        end

        function [S0,S1,S2] = estimatesStokes_halveNumPix(obj,img)
            %CONVERTUNPROCESSED_HALVENUMPIX
            masks = obj.Camera.masks;
            [I0,Ip45,I90,In45] = obj.deinterlaceQuadrants(img,masks.mask0,masks.maskp45,masks.mask90,masks.maskn45);
            [S0,S1,S2] = obj.getStokesParametersFromIntensities(I0,Ip45,I90,In45);
        end
        
        function [S0,S1,S2] = estimatesStokes_interpolation(obj,img,interpolationMethod)
            %CONVERTUNPROCESSED_INTERPOLATION
            I0   = obj.interpolatePolarisationChannel(img,obj.Camera.masks.mask0,  interpolationMethod);
            Ip45 = obj.interpolatePolarisationChannel(img,obj.Camera.masks.maskp45,interpolationMethod);
            I90  = obj.interpolatePolarisationChannel(img,obj.Camera.masks.mask90, interpolationMethod);
            In45 = obj.interpolatePolarisationChannel(img,obj.Camera.masks.maskn45,interpolationMethod);
            [S0,S1,S2] = obj.getStokesParametersFromIntensities(I0,Ip45,I90,In45);
        end
        
        function [S0,S1,S2] = estimatesStokes_fourier(obj,img)
            %CONVERTUNPROCESSED_FOURIER
            padFactor = 1;
            
            % fourier transform unprocessed image
            imgPadded = padarray(img,round(padFactor*size(img)));
            fftImg = fftshift(fft2(fftshift(imgPadded)));
            [nx,ny] = size(imgPadded);
            
            % estimate S0
            mask = obj.convertUnprocessed_fourier_generateCircularMask(fftImg);
            fftImgPadded_S0 = fftImg.*mask;
            S0 = real(ifftshift(ifft2(ifftshift(fftImgPadded_S0))));
            
            % depending on number of rows and columns, cut up frequency space in
            % different ways to make sure everything remains centered after pasting
            % back together
            if mod(nx,2) && mod(ny,2) % if uneven number of rows and columns
                fft_S1mS2_T = fftImg(1:floor(nx/2),:);
                fft_S1mS2_B = fftImg(floor(nx/2)+2:end,:);
                fft_S1pS2_L = fftImg(:,1:floor(ny/2));
                fft_S1pS2_R = fftImg(:,floor(ny/2)+2:end);
                
            elseif ~mod(nx,2) && mod(ny,2) % if even number of rows and uneven number of columns
                fft_S1mS2_T = fftImg(1:floor(nx/2),:);
                fft_S1mS2_B = fftImg(floor(nx/2)+1:end,:);
                fft_S1pS2_L = fftImg(:,1:floor(ny/2));
                fft_S1pS2_R = fftImg(:,floor(ny/2)+2:end);
                
            elseif mod(nx,2) && ~mod(ny,2) % if uneven number of rows and even number of columns
                fft_S1mS2_T = fftImg(1:floor(nx/2),:);
                fft_S1mS2_B = fftImg(floor(nx/2)+2:end,:);
                fft_S1pS2_L = fftImg(:,1:floor(ny/2));
                fft_S1pS2_R = fftImg(:,floor(ny/2)+1:end);
                
            else % if even number of rows and columns
                fft_S1mS2_T = fftImg(1:floor(nx/2),:);
                fft_S1mS2_B = fftImg(floor(nx/2)+1:end,:);
                fft_S1pS2_L = fftImg(:,1:floor(ny/2));
                fft_S1pS2_R = fftImg(:,floor(ny/2)+1:end);
            end
            
            % get S1 + S2 in frequency domain
            fft_S1mS2 = [fft_S1mS2_B; fft_S1mS2_T];
            mask = obj.convertUnprocessed_fourier_generateCircularMask(fft_S1mS2);
            fft_S1mS2 = fft_S1mS2.*mask;
            S1mS2 = real(ifftshift(ifft2(ifftshift(fft_S1mS2))));
            
            % get S1 - S2 in frequency domain
            fft_S1pS2 = [fft_S1pS2_R fft_S1pS2_L];
            mask = obj.convertUnprocessed_fourier_generateCircularMask(fft_S1pS2);
            fft_S1pS2 = fft_S1pS2.*mask;
            S1pS2 = real(ifftshift(ifft2(ifftshift(fft_S1pS2))));
            
            % crop back to size of original image
            S0    = obj.cropToROICentered(S0,size(img));
            S1pS2 = obj.cropToROICentered(S1pS2,size(img));
            S1mS2 = obj.cropToROICentered(S1mS2,size(img));
            
            % get Stokes parameters, angle and degree of linear polarisation
            S0 = real(S0);
            S1 = real(S1pS2 + S1mS2);
            S2 = real(S1pS2 - S1mS2);
        end
        
        function [I0,Ip45,I90,In45] = channelsFromUnprocessed(obj,img)
            %CHANNELSFROMUNPROCESSED
            switch obj.conversionMethod
                case 'interpolation spline'; [I0,Ip45,I90,In45] = estimateChannels_interpolation(obj,img,'spline');
                otherwise; disp("The entered value of the property 'conversionMethod' of the class 'Process' is invalid.");
            end
        end
        
        function [I0,Ip45,I90,In45] = estimateChannels_interpolation(obj,img,interpolationMethod)
            %CONVERTUNPROCESSED_INTERPOLATION
            I0   = obj.interpolatePolarisationChannel(img,obj.Camera.masks.mask0,  interpolationMethod);
            Ip45 = obj.interpolatePolarisationChannel(img,obj.Camera.masks.maskp45,interpolationMethod);
            I90  = obj.interpolatePolarisationChannel(img,obj.Camera.masks.mask90, interpolationMethod);
            In45 = obj.interpolatePolarisationChannel(img,obj.Camera.masks.maskn45,interpolationMethod);
        end
        
        function [x,y] = find2DlocalisationCandidates(obj,img)
            % FIND2DLOCALISATIONCANDIDATES find local maxima in an image after a
            % difference-of-gaussian (DoG) filter.
            % 
            % DoG = (img guassian blurred with sigma1) - (img guassian blurred with sigma2)
            % 
            % input:
            %   img    - array, the image
            %   sigma1 - double, standard deviation of the first gaussian filter
            %   sigma1 - double, standard deviation of the second gaussian filter
            %   DoGmin - double, ignore all maxima in regions where DoG < DoGmin
            % output:
            %   x - nx1 array, the x-coordinates of identified local maxima (pixel resolution)
            %   y - nx1 array, the y-coordinates of identified local maxima (pixel resolution)

            % pre-processing filter
            imgMed = medfilt2(img,[3,3],'symmetric');
            G1 = imgaussfilt(imgMed,obj.localisationParams.DoGsigmaSmall);
            G2 = imgaussfilt(imgMed,obj.localisationParams.DoGsigmaLarge);
            DoG = G1 - G2;

            % find local maxima (localisation candidates)
            DoG(DoG < obj.localisationParams.DoGminThreshold) = 0;
            if all(DoG == 0) % if everything was below the threshold
                x = [];
                y = [];
            else
                BW = imregionalmax(DoG);
                [x,y] = find(BW); % get coordinates of local maxima
                
                % remove candidates that are too close to image borders
                keep_x = (x > obj.border).*(x < obj.Camera.imgSizeEven(1) - obj.border);
                keep_y = (y > obj.border).*(y < obj.Camera.imgSizeEven(2) - obj.border);
                keep = logical(keep_x.*keep_y);
                x = x(keep);
                y = y(keep);
            end
        end

        
        function locs = fit2Dlocalisations(obj,img,x,y)
            % FIT2DLOCALISATIONS
                                    
            % create meshgrid for centroid calculation in small 2*w+1 square roi
            x_mesh = -obj.localisationParams.w.xy:obj.localisationParams.w.xy;
            [x_mesh,y_mesh] = meshgrid(x_mesh,x_mesh);
            locs = {};
            switch obj.localisationParams.method
                
                case 'centroid'
                    for i=1:length(x)
                        roi = obj.cropToROI(img,x(i),y(i),obj.localisationParams.w.xy);
                        roi = roi - min(roi(:));
                        intensity = sum(roi(:));
                        x_centroid = sum(x_mesh.*roi,'all')/intensity;
                        y_centroid = sum(y_mesh.*roi,'all')/intensity;
                        locs(i).photons = intensity/2;
                        locs(i).x = (x(i) + y_centroid)*obj.Microscope.virtualPixelSize;
                        locs(i).y = (y(i) + x_centroid)*obj.Microscope.virtualPixelSize;
                    end
                    
                case 'symmetric gaussian'
                    for i=1:length(x)
                        roi = obj.cropToROI(img,x(i),y(i),obj.localisationParams.w.xy);
                        [params,~,~] = obj.fit2DGaussian(roi,obj.localisationParams.w.xy,'symmetric');
                        locs(i).amplitude = params.amplitude;
                        locs(i).x = (x(i) + params.y0)*obj.Microscope.virtualPixelSize;
                        locs(i).y = (y(i) + params.x0)*obj.Microscope.virtualPixelSize;
                        locs(i).sigma = params.sigma;
                        locs(i).bkgnd = params.bkgnd/2;
                        locs(i).photons = (2*pi*params.amplitude.*params.sigma.*params.sigma)/2;
                        
                        a = obj.Microscope.virtualPixelSize;
                        s = a*locs(i).sigma;
                        b = locs(i).bkgnd;
                        N = locs(i).photons;
                        [uncertainty_xy, uncertainty_photons] = obj.getThompsonUncertainty(s,a,b,N);
                        locs(i).uncertainty_xy = uncertainty_xy;
                        locs(i).uncertainty_photons = uncertainty_photons;
                    end
                    
                case 'asymmetric gaussian'
                    for i=1:length(x)
                        roi = obj.cropToROI(img,x(i),y(i),obj.localisationParams.w.xy);
                        [params,~,~] = obj.fit2DGaussian(roi,obj.localisationParams.w.xy,'asymmetric');
                        locs(i).amplitude = params.amplitude;
                        locs(i).x = (x(i) + params.y0)*obj.Microscope.virtualPixelSize;
                        locs(i).y = (y(i) + params.x0)*obj.Microscope.virtualPixelSize;
                        locs(i).sigmax = params.sigmax;
                        locs(i).sigmay = params.sigmay;
                        locs(i).bkgnd = params.bkgnd/2;
                        locs(i).photons = (2*pi*params.amplitude.*params.sigmax.*params.sigmay)/2;
                        
                        a = obj.Microscope.virtualPixelSize;
                        s = a*(locs(i).sigmax + locs(i).sigmay)/2;
                        b = locs(i).bkgnd;
                        N = locs(i).photons;
                        [uncertainty_xy, uncertainty_photons] = obj.getThompsonUncertainty(s,a,b,N);
                        locs(i).uncertainty_xy = uncertainty_xy;
                        locs(i).uncertainty_photons = uncertainty_photons;
                    end
                    
                case 'rotated asymmetric gaussian'
                    for i=1:length(x)
                        roi = obj.cropToROI(img,x(i),y(i),obj.localisationParams.w.xy);
                        [params,~,~] = obj.fit2DGaussian(roi,obj.localisationParams.w.xy,'rotated asymmetric');
                        locs(i).amplitude = params.amplitude;
                        locs(i).x = (x(i) + params.y0)*obj.Microscope.virtualPixelSize;
                        locs(i).y = (y(i) + params.x0)*obj.Microscope.virtualPixelSize;
                        locs(i).sigmax = params.sigmax;
                        locs(i).sigmay = params.sigmay;
                        locs(i).rot = params.theta;
                        locs(i).bkgnd = params.bkgnd/2;
                        locs(i).photons = (2*pi*params.amplitude.*params.sigmax.*params.sigmay)/2;
                        locs(i).sigmaRatio = params.sigmax./params.sigmay;
                        
                        a = obj.Microscope.virtualPixelSize;
                        s = a*(locs(i).sigmax + locs(i).sigmay)/2;
                        b = locs(i).bkgnd;
                        N = locs(i).photons;
                        [uncertainty_xy, uncertainty_photons] = obj.getThompsonUncertainty(s,a,b,N);
                        locs(i).uncertainty_xy = uncertainty_xy;
                        locs(i).uncertainty_photons = uncertainty_photons;

                        % get orientation estimate from orientation fit
                        angleGaus = locs(i).rot;
                        angleGaus(locs(i).sigmax./locs(i).sigmay > 1) = angleGaus(locs(i).sigmax./locs(i).sigmay > 1) + pi/2;
                        angleGaus = (angleGaus - pi/2)*180/pi;
                        angleGaus(angleGaus < - 90) = angleGaus(angleGaus < - 90) + 180;
                        locs(i).angleGaus = angleGaus*pi/180;

                    end
                    
                otherwise; fprintf('Unexpected value for "method" in function "fit2Dlocalisations".')
            end
            
        end
                
        function Theta = getThetaFromNetDoLP(obj,netDoLP)
            %GETTHETAFROMNETDOLP
            Theta = abs(asin(sqrt((obj.A*netDoLP)./(obj.C - obj.B*netDoLP))));
        end
        
        function [alpha,A,B,C] = getConstantsForThetaCalculation(obj)
            %GETCONSTANTSFORTHETACALCULATION
            alpha = asin(obj.Microscope.NA/obj.Microscope.nImmersion);
            A = (1/6) - (1/4)*cos(alpha) + (1/12)*cos(alpha)^3;
            B = (1/8)*cos(alpha) - (1/8)*cos(alpha)^3;
            C = (7/48) - (1/16)*cos(alpha) - (1/16)*cos(alpha)^2 - (1/48)*cos(alpha)^3;
        end

    end
    
    methods (Static)

        function Vq = interpolatePolarisationChannel(img,mask,interpolationMethod)
            %INTERPOLATEPOLARISATIONCHANNEL
            % get pixels from channel and make meshgrid
            [nx,ny] = size(img);
            V = reshape(img(mask==1),nx/2,ny/2);
            
            if mask(1,1);     [X,Y] = meshgrid(1:2:nx,1:2:ny);
            elseif mask(1,2); [X,Y] = meshgrid(2:2:nx+1,1:2:ny);
            elseif mask(2,1); [X,Y] = meshgrid(1:2:nx,2:2:ny+1);
            elseif mask(2,2); [X,Y] = meshgrid(2:2:nx+1,2:2:ny+1);
            else; disp("Unexpected mask in function 'interpolatePolarisationChannel' in class 'Process'."); return
            end
            
            [Xq,Yq] = meshgrid(1:1:nx,1:1:ny);
            switch interpolationMethod
                case 'linear'; Vq = interp2(X,Y,V',Xq,Yq,'linear')';
                case 'cubic';  Vq = interp2(X,Y,V',Xq,Yq,'cubic')';
                case 'makima'; Vq = interp2(X,Y,V',Xq,Yq,'makima')';
                case 'spline'; Vq = interp2(X,Y,V',Xq,Yq,'spline')';
                otherwise; disp('Unexpected interpolation method in function "interpolatePolarisationChannel".'); return
            end
        end
        
        function mask = convertUnprocessed_fourier_generateCircularMask(img)
            %CONVERTUNPROCESSED_FOURIER_GENERATECIRCULARMASK
            [nx,ny] = size(img);
            
            if mod(nx,2) && mod(ny,2) % if uneven number of rows and columns
                
                x = -floor(nx/2):floor(nx/2);
                y = -floor(ny/2):floor(ny/2);
                [x,y] = meshgrid(x,y);
                r = x.^2 + y.^2 + 0.0001; % add 0.0001 to avoid a tiny hole in the center of the mask
                r(r > floor(nx/4)^2) = 0;
                mask = logical(r);
                
            elseif ~mod(nx,2) && mod(ny,2) % if even number of rows and uneven number of columns
                
                x = -floor(nx/2):floor(nx/2);
                y = -floor(ny/2):floor(ny/2)-1; y = y + 0.5;
                [x,y] = meshgrid(x,y);
                r = x.^2 + y.^2 + 0.0001; % add 0.0001 to avoid a tiny hole in the center of the mask
                r(r > floor(nx/4)^2) = 0;
                mask = logical(r);
                
            elseif mod(nx,2) && ~mod(ny,2) % if uneven number of rows and even number of columns
                
                x = -floor(nx/2):floor(nx/2)-1; x = x + 0.5;
                y = -floor(ny/2):floor(ny/2);
                [x,y] = meshgrid(x,y);
                r = x.^2 + y.^2 + 0.0001; % add 0.0001 to avoid a tiny hole in the center of the mask
                r(r > floor(nx/4)^2) = 0;
                mask = logical(r);
                
            else % if even number of rows and columns
                
                x = -floor(nx/2):floor(nx/2)-1; x = x + 0.5;
                y = -floor(ny/2):floor(ny/2)-1; y = y + 0.5;
                [x,y] = meshgrid(x,y);
                r = x.^2 + y.^2 + 0.0001; % add 0.0001 to avoid a tiny hole in the center of the mask
                r(r > floor(nx/4)^2) = 0;
                mask = logical(r);
                
            end
        end
        
        function img = makeDimensionsEven(img)
            % MAKEDIMENSIONSEVEN removes a row or column at the end of an image if the
            % dimensions are uneven.
            if mod(size(img,1),2)
                img = img(1:end-1,:);
            end
            if mod(size(img,2),2)
                img = img(:,1:end-1);
            end
        end
        
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
        
        function img = interlaceQuadrants(img00,img01,img10,img11)
            % INTERLACEQUADRANTS interlace the pixels of 4 images like
            %   img00(1,1)  img01(1,1)  img00(1,2)  img01(1,2)
            %   img10(1,1)  img11(1,1)  img10(1,2)  img11(1,2)
            %   img00(2,1)  img01(2,1)  img00(2,2)  img01(2,2)
            %   img10(2,1)  img11(2,1)  img10(2,2)  img11(2,2) etc.
            % 
            % input:
            %   img00 - nxm array, an image
            %   img01 - nxm array, an image
            %   img10 - nxm array, an image
            %   img11 - nxm array, an image
            % 
            % output:
            %   img - 2nx2m array, the 4 images interlaced

            interlaced_13 = [img00(:)'; img10(:)']; 
            interlaced_13 = interlaced_13(:);
            interlaced_13 = reshape(interlaced_13,[2*size(img00,1),size(img10,2)]);

            interlaced_24 = [img01(:)'; img11(:)']; 
            interlaced_24 = interlaced_24(:);
            interlaced_24 = reshape(interlaced_24,[2*size(img01,1),size(img11,2)]);

            il13 = (interlaced_13); il13 = il13';
            il24 = (interlaced_24); il24 = il24';

            img = [il13(:)'; il24(:)']; img = img(:);
            img = reshape(img,[2*size(img00,2),2*size(img00,1)])';

        end
        
        function [S0,S1,S2] = getStokesParametersFromIntensities(I0,Ip45,I90,In45)
            %GETSTOKESPARAMETERSFROMINTENSITIES
            S0 = (I0 + Ip45 + I90 + In45)/2;
            S1 = I0 - I90;
            S2 = Ip45 - In45;
        end
        
        function [I0,Ip45,I90,In45] = getIntensitiesFromStokesParameters(S0,S1,S2)
            %GETINTENSITIESFROMSTOKESPARAMETERS
            I0   = (S0 + S1)/2;
            I90  = (S0 - S1)/2;
            Ip45 = (S0 + S2)/2;
            In45 = (S0 - S2)/2;
        end
        
        function Phi = getAzimuthFromStokes(S1,S2)
            %GETAZIMUTHFROMSTOKES
            Phi = (1/2)*atan2(S2,S1);
        end
        
        function DoLP = getDoLPFromStokes(S0,S1,S2)
            %GETDOLPFROMSTOKES
            DoLP = sqrt((S1.^2 + S2.^2)./(S0.^2));
        end
        
        function crop = cropToROICentered(img,fov)
            %CROPTOROICENTERED
            [nx,ny] = size(img);
            xc = ceil(nx/2);
            yc = ceil(ny/2);
            w = floor(fov/2);
            crop = img(xc-w:xc-w+fov-1,...
                yc-w:yc-w+fov-1,:);
        end
        
        function crop = cropToROI(img,xc,yc,w)
            %CROPTOROI
            crop = img(xc-w:xc+w,yc-w:yc+w,:);
        end

        function [params,resnorm,residual] = fit2DGaussian(img,w,type)
            % FITSYMMETRIC2DGAUSSIAN fits a symmetric 2d gaussian to a square image.
            % input:
            %   img  - square array of size [2*w+1, 2*w+1], the image
            %   w    - int, as defined above (could be calculated each time, but as it usually is
            %               a constant variable it can just be supplied to the function)
            %   type - string, 'symmetric', 'asymmetric' or 'rotated asymmetric' type
            %               of 2d gaussian
            % output:
            %   params - ...
            %   amplitude - double, the amplitude of the fitted gaussian
            %   x0 and y0 - double, the x and y coordinate of the center of the
            %               gaussian, relative to the center of the middle pixel which
            %               is at (0,0)
            %   sigma     - double, the standard deviation of the fitted gaussian
            %   resnorm   - double, sum of the square of the residuals, i.e. sum(residual(:).^2)
            %   residual  - array, the residual of the fit, same size as img

            % get (x,y) meshgrid
            x = -w:w;
            [x,y] = meshgrid(x,x);
            xdata = cat(3,x,y);

            switch type

                case 'symmetric'
                    % set lower and upper bounds and initial values of x = [amplitude,xo,yo,sigma]
                    lb = [0,-w,-w,0,-inf];
                    ub = [realmax('double'),w,w,w^2,inf];
                    x0 = [max(img(:)),0,0,1,min(img(:))]; % initial values
                    options = optimset('Display','off'); % don't flood command window with messages
                    
                    % symmetric 2D gaussian
                    f = @(x,xdata)x(1)*exp(-( (xdata(:,:,1)-x(2)).^2  + ...
                                              (xdata(:,:,2)-x(3)).^2  )/(2*x(4).^2)) + x(5);
                    [x,resnorm,residual,~] = lsqcurvefit(f,x0,xdata,img,lb,ub,options);
                    params.amplitude = x(1);
                    params.x0        = x(2);
                    params.y0        = x(3);
                    params.sigma     = x(4);
                    params.bkgnd     = x(5);

                case 'asymmetric'
                    % set lower and upper bounds and initial values of x = [amplitude,xo,yo,sigmax,sigmay]
                    lb = [0,-w,-w,0,0,-inf];
                    ub = [realmax('double'),w,w,w^2,w^2,inf];
                    x0 = [max(img(:)),0,0,1,1,min(img(:))]; % initial values
                    options = optimset('Display','off'); % don't flood command window with messages
                    
                    % asymmetric 2D gaussian
                    f = @(x,xdata)x(1)*exp(-( ((xdata(:,:,1)-x(2)).^2)/(2*x(4).^2) + ...
                                              ((xdata(:,:,2)-x(3)).^2)/(2*x(5).^2) )) + x(6);
                    [x,resnorm,residual,~] = lsqcurvefit(f,x0,xdata,img,lb,ub,options);
                    params.amplitude = x(1);
                    params.x0        = x(2);
                    params.y0        = x(3);
                    params.sigmax    = x(4);
                    params.sigmay    = x(5);
                    params.bkgnd     = x(6);

                case 'rotated asymmetric'
                    % set lower and upper bounds and initial values of x = [amplitude,xo,yo,sigmax,sigmay,theta]
                    lb = [0,-w,-w,0,0,-pi/4,-inf];
                    ub = [realmax('double'),w,w,w^2,w^2,pi/4,inf];
                    x0 = [max(img(:)),0,0,1,1,0,min(img(:))]; % initial values
                    options = optimset('Display','off'); % don't flood command window with messages
                    
                    % asymmetric 2d gaussian but using rotated coordinates
                    f = @(x,xdata)x(1)*exp(-(((xdata(:,:,1)*cos(x(6)) - xdata(:,:,2)*sin(x(6))) - (x(2)*cos(x(6)) - x(3)*sin(x(6)))).^2/(2*x(4)^2) + ...
                                             ((xdata(:,:,1)*sin(x(6)) + xdata(:,:,2)*cos(x(6))) - (x(2)*sin(x(6)) + x(3)*cos(x(6)))).^2/(2*x(5)^2))) + x(7);
                    
                    [x,resnorm,residual,~] = lsqcurvefit(f,x0,xdata,img,lb,ub,options);
                    params.amplitude = x(1);
                    params.x0        = x(2);
                    params.y0        = x(3);
                    params.sigmax    = x(4);
                    params.sigmay    = x(5);
                    params.theta     = x(6);
                    params.bkgnd     = x(7);

                otherwise
                    disp('Unexpected value for "type" in function "fit2DGaussian".')
            end

        end

        function F = symmetric2DGaussian(x,xdata)
            % SYMMETRIC2DGAUSSIAN function describing a symmetric 2d gaussian used as
            % input for lsqcurvefit during fitting.
            % input:
            %   x     - 1x4 array containing parameters [amplitude, x0, y0, sigma]
            %   xdata - NxNx2 matrix, containing spatial x and y values at which to
            %           calculate the function
            % output:
            %   F - NxN matrix, the calcualted 2d gaussian
            F = x(1)*exp(-(  (xdata(:,:,1)-x(2)).^2  + ...
                             (xdata(:,:,2)-x(3)).^2  )/(2*x(4).^2));
        end

        function F = asymmetric2DGaussian(x,xdata)
            % ASYMMETRIC2DGAUSSIAN function describing an asymmetric 2d gaussian used as
            % input for lsqcurvefit during fitting.
            % input:
            %   x     - 1x5 array containing parameters [amplitude, x0, y0, sigmax, sigmay]
            %   xdata - NxNx2 matrix, containing spatial x and y values at which to
            %           calculate the function
            % output:
            %   F - NxN matrix, the calcualted 2d gaussian
            F = x(1)*exp(-(  ((xdata(:,:,1)-x(2)).^2)/(2*x(4).^2) + ...
                             ((xdata(:,:,2)-x(3)).^2)/(2*x(5).^2)  ));
        end

        function F = rotatedAsymmetric2DGaussian(x,xdata)
            % ROTATEDASYMMETRIC2DGAUSSIAN function describing a rotated asymmetric 2d
            % gaussian used as input for lsqcurvefit during fitting.
            % input:
            %   x     - 1x6 array containing parameters [amplitude, x0, y0, sigmax, sigmay, theta]
            %   xdata - NxNx2 matrix, containing spatial x and y values at which to
            %           calculate the function
            % output:
            %   F - NxN matrix, the calcualted 2d gaussian

            % rotate x and y coordinate space by angle theta = x(6) around origin
            xdatarot(:,:,1) = xdata(:,:,1)*cos(x(6)) - xdata(:,:,2)*sin(x(6));
            xdatarot(:,:,2) = xdata(:,:,1)*sin(x(6)) + xdata(:,:,2)*cos(x(6));

            % rotate centroid position by angle theta = x(6) around origin
            x0rot = x(2)*cos(x(6)) - x(3)*sin(x(6));
            y0rot = x(2)*sin(x(6)) + x(3)*cos(x(6));

            % asymmetric 2d gaussian but using rotated coordinates
            F = x(1)*exp(-((xdatarot(:,:,1)-x0rot).^2/(2*x(4)^2) + ...
                           (xdatarot(:,:,2)-y0rot).^2/(2*x(5)^2)));
        end
        
        function mip = getMinimumIntensityProjectionFromPath(filepath)
            % GETMINIMUMINTENSITYPROJECTIONFROMPATH Get a minimum intensity
            % projection of a tiff stack from file.
            tr = Tiff(filepath,'r'); % set up object for reading frame by frame
            mip = double(tr.read()); % read first frame
            if tr.lastDirectory()
                return
            else
                tr.nextDirectory();
                while true % read remaining frames
                    mip = min(cat(3,mip,double(tr.read())),[],3);
                    if tr.lastDirectory(); break;
                    else; tr.nextDirectory();
                    end
                end
            end
            close(tr)
        end
        
        function avg = getAverageIntensityProjectionFromPath(filepath)
            % GETAVERAGEINTENSITYPROJECTIONFROMPATH Get a minimum intensity
            % projection of a tiff stack from file.
            tr = Tiff(filepath,'r'); % set up object for reading frame by frame
            count = 1;
            avg = double(tr.read()); % read first frame
            if tr.lastDirectory()
                return
            else
                tr.nextDirectory();
                while true % read remaining frames
                    avg = avg + double(tr.read());
                    count = count + 1;
                    if tr.lastDirectory(); break;
                    else; tr.nextDirectory();
                    end
                end
            end
            close(tr)
            avg = avg/count;
        end
        
        function [uncertainty_xy, uncertainty_photons] = getThompsonUncertainty(s,a,b,N)
            % GETTHOMPSONUNCERTAINTY Calculate the theoretical localisation
            % uncertainty and photon number estimate uncertainty using the
            % equations 17 and 19 from Thompson, Larson and Webb, Biophys J
            % 82(5):2775-2783, 2002
            % s: sigma width of fitted gaussian (in nm)
            % a: virtual pixel size (in nm)
            % b: background/pixel in photons
            % N: total number of detected signal photons (without background)
            
            % uncertainty xy localisation
            term1 = (s.^2 + (a.^2/12))./N;
            term2 = (8*pi*(s.^4).*(b.^2))./(N*a).^2;
            uncertainty_xy = sqrt(term1 + term2);
            
            % uncertainty intensity estimate
            term1 = N;
            term2 = (4*pi*(s.^2).*(b.^2))./(a.^2);
            uncertainty_photons = sqrt(term1 + term2);
        end
        
    end
end
