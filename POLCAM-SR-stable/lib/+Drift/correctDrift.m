function [x_corr,y_corr,dx,dy] = correctDrift(frame,x,y,methodParam)

switch methodParam.method
    
    case 'fiducial'
        disp([methodParam.method '-based drift correction selected.'])
        [x_corr,y_corr,dx,dy] = Drift.correctDriftFiducial(frame,x,y,methodParam.pixelsize);
    
    case 'RCC'
        disp([methodParam.method ' drift correction selected.'])
        [x_corr,y_corr,dx,dy] = Drift.correctDriftRCC(frame,x,y,methodParam.numFramesSegment,methodParam.binsize);

    otherwise
        disp('Unexpected value for "methodParam.method" in function "correctDrift".'); return

end

end
