a = 45;
b = 45;
c = 45;
Ma = [1 0 0; 0 cosd(a) -sind(a); 0 sind(a) cosd(a)];
Mb = [cosd(b) 0 sind(b); 0 1 0; -sind(b) 0 cosd(b)];
Mc = [cosd(c) -sind(c) 0; sind(c) cosd(c) 0; 0 0 1];
R = Ma * Mb * Mc;
T = [50; 50; 50];
Face1 = R * Face0 + repmat(T, 1, size(Face0, 2));
Face1_c = sum(Face1, 2) ./ size (Face1, 2);
Face1 = Face1 - repmat(Face1_c, 1, size (Face1, 2));

% plot3(Face1(2,:), Face1(3,:),-Face1(1,:), 'r.');
% hold on;
% plot3(Face0(2,:), Face0(3,:),-Face0(1,:), 'b.');
% drawnow;
for i = 1:80
    [TR, TT, ~] = myicp (Face0, Face1);
    Face1 = TR * Face1 + repmat(TT, 1, size(Face1, 2));
end
plot3(Face1(2,:), Face1(3,:),-Face1(1,:), 'r.');
hold on;
plot3(Face0(2,:), Face0(3,:),-Face0(1,:), 'b.');
drawnow;