addpath('Mex')

% Open Device
CameraHandle  = pxcOpenCamera();

if(CameraHandle ==0)
    error('no valid camera handle');
end

h = figure; title('Close this window to stop camera');
% Acquire a Camera Frame, and lock
pxcAcquireFrame(CameraHandle);
D = pxcDepthImage(CameraHandle); D=permute(D,[2 1]);
% Release the camera frame
pxcReleaseFrame(CameraHandle);
subplot(1,2,2),h2=imshow(D,[200 750]); colormap('jet');
set(h2,'CDATA',D);
% Close the Camera
pxcCloseCamera(CameraHandle);
