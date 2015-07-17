tof2;
path(:,:,1) = data;
tof3;
path(:,:,2) = data;
tof4;
path(:,:,3) = data;
tof5;
path(:,:,4) = data;

amp2;
ampl(:,:,1) = data;
amp3;
ampl(:,:,2) = data - ampl(:,:,1);
amp4;
ampl(:,:,3) = data - ampl(:,:,2) - ampl(:,:,1);
amp5;
ampl(:,:,4) = data - ampl(:,:,3) - ampl(:,:,2) - ampl(:,:,1);

save('timeprofgen.mat','path', 'ampl')