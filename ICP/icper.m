% This function calls ICP algorythm, then transforms additional added points
% (the ones without pair - Padd) and adds them to the general picture.
function P0 = icper(P0, P1)
% [R, T] = icp (P0, P1, 10, 'Matching', 'kDtree', 'Minimize', 'plane');
% P1 = R * P1 + repmat (T, 1, 3072);
% P0 = [P0 P1];
[R, T, Padd] = myicp(P0, P1);
N = size (Padd, 2);
disp (N);
Padd = R * Padd + repmat (T, 1, N); %N - number of additional points
P0 = [P0 Padd];

% This function performs ICP algorithm. 
function [TR, TT, Padd] = myicp(P0, P1)

% Number of iterations
iter = 10;

% Np - the number of points in the P1
Np = size(P1,2);

% Building kDtree for P0:
kdOBJ = KDTreeSearcher(transpose(P0));

% Will do all the transformations during the iterations on the Pt, not on
% the P1
Pt = P1;

% Allocate vector for RMS of errors in every iteration.
ER = zeros(iter + 1, 1); 

% Initialize temporary transform vector and matrix.
% T = zeros(3,1);
% R = eye(3,3);

% Initialize total transform vector(s) and rotation matric(es).
TT = zeros(3, 1, iter + 1);
TR = repmat(eye(3,3), [1, 1, iter + 1]);

% iter - number of iterations for ICP algorithm per call
for k = 1:iter
    
    % 1 - select M points. Will use all of them yet, or will change the
    % number of points through modifier.m
    
    % 2 - match points from P1 to closests from P0. Will use kDtree for
    % that, which is already built.
    % After that will construct 2 matrices that will contain matched point 
    % pairs. 
    [match, mindist] = kDmatch(P0, Pt, kdOBJ);
    M = mean (mindist);
    j = 1;
    p = Pt;
    q = P0;
    for i = 1:size(match, 2)
        if (mindist (i) < M)
            p(1,j) = Pt(1,i);
            p(2,j) = Pt(2,i);
            p(3,j) = Pt(3,i);
            q(1,j) = P0(1,match (1, i));
            q(2,j) = P0(2,match (1, i));
            q(3,j) = P0(3,match (1, i));
            j = j + 1;
        end
    end
    p = p(1:3, 1:(j-1));
    q = q(1:3, 1:(j-1));
    
    % 2.5 - weight the correspondences. Not yet done, need to understand
    
    % 3 - reject bad pairs. Not yet done, need to understand
    
    % 4 - construct the error function. Error - RMS of distances
%     if k == 1
%         ER(k) = sqrt(sum(mindist.^2)/length(mindist));
%     end
    
    % 5 - minimize the error function.
    % Will start with point to point minimization. Later may implement
    % point to plane.
    % The input is p and q - matched point pairs.
    [R, T] = point2point(q, p);
    
    % Add to the total transformation
    TR(:,:,k+1) = R*TR(:,:,k);
    TT(:,:,k+1) = R*TT(:,:,k) + T;
    
    % Apply last transformation
    Pt = TR(:,:,k+1) * P1 + repmat(TT(:,:,k+1), 1, Np);
    
%     ER(k+1) = rms_error(P0, Pt);
end

% Returning the last element of full transformations 3-dimensional matrices
TR = TR(:,:,end);
TT = TT(:,:,end);

% This part excludes all the repeating points, leaving only new ones in the
% matrix Padd. The check for distance is done (if it is above average => 
% => the point is new)
[match, mindist] = kDmatch(P0, Pt, kdOBJ);
M = mean (mindist);
j = 1;
Paddt = Pt;
for i = 1:size(match, 2)
    if (mindist (i) > M)
        Paddt(1, j) = Pt (1, i);
        Paddt(2, j) = Pt (2, i);
        Paddt(3, j) = Pt (3, i);
        j = j + 1;
    end
end
Padd = Paddt(1:3, 1:(j-1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This function performs the search over kDtree for the best
% correspondences (minimal distance)
% match - is a column vector. Each row contains the index of nearest 
% neighbor in X for the corresponding row in Y. 
% mindist - is the vector containing the distances between each observation 
% in Y and the corresponding closest observation in X 
function [match, mindist] = kDmatch(~, p, kdOBJ)
[match, mindist] = knnsearch(kdOBJ,transpose(p));
match = transpose(match);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This function performs point to point minimization. The input matrices
% are matched.
function [R, T] = point2point(q, p)

m = size(p,2);
n = size(q,2);

p_c = sum(p, 2)./ m;
q_c = sum(q, 2)./ n;

q_mark = q - repmat(q_c, 1, n);
p_mark = p - repmat(p_c, 1, m);

N = p_mark * transpose(q_mark);

[U, ~, V] = svd(N);
R = V*diag([1 1 det(U*V')])*transpose(U);
T = q_c - R*p_c;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
function ER = rms_error (p1, p2)
dsq = sum(power(p1 - p2, 2),1);
ER = sqrt(mean(dsq));