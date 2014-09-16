addpath('Mex')

% Open Device
CameraHandle = pxcOpenCamera();

if(CameraHandle == 0)
    error('no valid camera handle');
end

h = figure; 
title('Close this window to stop camera');

% Acquire a Camera Frame and lock
pxcAcquireFrame(CameraHandle);
D = pxcDepthImage(CameraHandle); 
D = permute(D,[2 1]);

[P0, n] = modifier(D);

% Release the camera frame
pxcReleaseFrame(CameraHandle);

i = 1;
while (ishandle(h));
    disp(i);
    i = i + 1;
    
    % Acquire a Camera Frame, and lock
    pxcAcquireFrame(CameraHandle);
    D = pxcDepthImage(CameraHandle); 
    D = permute(D,[2 1]);
    
    [P1, n] = modifier(D);
    
    P0 = icper(P0, P1);
    
	% Release the camera frame
    pxcReleaseFrame(CameraHandle);
    
    plot3(P0(2,:), P0(3,:),-P0(1,:), '.')
    axis ([0 350 200 1000 -350 0]);
    drawnow;
end

% Close the Camera
pxcCloseCamera(CameraHandle);