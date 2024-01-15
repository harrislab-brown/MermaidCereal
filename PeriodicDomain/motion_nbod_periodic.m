function dydt = motion_nbod_periodic(t,th,that,avec,I,m,f_0,R,l_c,mu_0,L,grids)
%Function to invoke a simple rotation about the COM.
R_fun = @(theta) ([cos(theta) -sin(theta); sin(theta) cos(theta)]);
%Always start out as empty
xs_foci = [];
ys_foci = [];
x_center=[];
y_center=[];
%Get the same coordinates centered at the origin
%This will be helpful for torque calculations.
for pp = 1:length(avec)
    %You should take as input a vector of a's where a represents
    %the foci location for each of your disks.
    %If you want to do an n body simulation of disks, then you should make
    %avec = zeros(n,1);
    a = avec(pp);
    %Let a be the foci of the ellipse that you will
    %place half of the mass.
    p1 = [0 0 ;1 -1].*a;
    points1_xy = p1+ [th(2*pp-1); th(2*pp-0)];
    xs_foci = [xs_foci points1_xy(1,:)];
    ys_foci = [ys_foci points1_xy(2,:)];
    x_center=[x_center th(2*pp-1) th(2*pp-1)];
    y_center=[y_center th(2*pp-0) th(2*pp-0)];
end

%Arrange a 3x3 grid with our particles occupying the center square
rr = L*[1 1 1 0 0 -1 -1 -1 ; -1 0 1 -1 1 -1 0 1];
x_centertry = x_center;
y_centertry = y_center;
xs_focitry = xs_foci;
ys_focitry = ys_foci;
for yy = 1:8
    xadd = rr(1,yy);
    yadd = rr(2,yy);
    x_center = [x_center x_centertry+xadd];
    xs_foci = [xs_foci xs_focitry+xadd];
    y_center = [y_center y_centertry+yadd];
    ys_foci = [ys_foci ys_focitry+yadd];
end
x_center=x_center';
y_center=y_center';
xs_foci =  xs_foci';
ys_foci =  ys_foci';
%Difference matrices
Xs_foci = ( xs_foci' - xs_foci );
Ys_foci = ( ys_foci' - ys_foci );
X_center= (x_center'-x_center); 
Y_center= (y_center'-y_center);
Rs_foci = ( Xs_foci.^2 + Ys_foci.^2).^(1/2);
Rs_center= ( X_center.^2 + Y_center.^2).^(1/2);

Ones_Mat = ones(size(Rs_foci));
size(Ones_Mat);
%Make a block diagonal matrix that is a block of (1 1 ; 1 1) repeated
%n times if there are n disks/ellipses
A = [1 1 ; 1 1];
Blocks = kron(eye(grids*length(avec)),A);
%Now, we make the matrix which is one everywhere
%Except on the blocks where the self interaction occurs
Final_block = Ones_Mat - Blocks ; 
%Make the distance between self interacting terms super far away.
%This should kill the forces and avoid infintie blowups or something.
%we'll set forces on these blocks to zero in another line of code.
Rs_foci( Final_block < 1) = 1e12 ;
Rs_center( Final_block < 1) = 1e12 ;

Fmat = -f_0.*exp(-(Rs_foci-2*R)/l_c)+(3*mu_0*m^2/(4*pi)).*(Rs_center).^-4;
Fmat( Final_block < 1) = 0;
Fx = -Xs_foci ./ Rs_foci .*Fmat;
Fy = -Ys_foci ./ Rs_foci .*Fmat;

sumvec = ones(grids*length(avec)*2,1); %Given the code is written for 
% ellipses more generallyeach particle has two locations to sum forces over
Fxvec = Fx*sumvec;
Fyvec = Fy*sumvec;
F_xgroup = reshape(Fxvec,[2,grids*length(avec)]);
F_ygroup = reshape(Fyvec,[2,grids*length(avec)]);

%Total x force on each ellipse from pairwise interactions and confinement.
Fx_trans = sum(F_xgroup,1);
%Total y force on each ellipse from pairwise interactions and confinement.
Fy_trans = sum(F_ygroup,1);
dydt = [];
%Critically, we only write ODEs for the forces on the actual particles in
%the central grid.
for qq = 1:length(avec)
    dydt = [dydt ; that./m.*Fx_trans(qq) ; that./m.*Fy_trans(qq) ];
end