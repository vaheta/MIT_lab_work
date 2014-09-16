% This function modifies the matrix D from 240*320 with depth value in each
% cell to 3 * N, where N is the number of used points and in each row there
% is a coordinate for each point.
function [P1, k] = modifier (D) 
P1temp = zeros (3, 76800);
k = 1;
for i = 1:10:240
    for j = 1:10:320
        if (D(i,j) ~= 32001)
            P1temp(1, k) = i;
            P1temp(2, k) = j;
            P1temp(3, k) = D(i,j);
            k = k + 1;
        end
    end
end
P1 = P1temp(1:3, 1:(k-1));
