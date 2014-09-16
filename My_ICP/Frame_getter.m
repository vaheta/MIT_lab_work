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

[Face0, n] = modifier(D);

% Release the camera frame
pxcReleaseFrame(CameraHandle);
plot3(Face0(2,:), Face0(3,:),-Face0(1,:), 'b.')
axis ([0 350 200 1000 -350 0]);
drawnow;
% Close the Camera
pxcCloseCamera(CameraHandle);

