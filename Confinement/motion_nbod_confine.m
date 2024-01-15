function dydt = motion_nbod_confine(t,th,that,avec,I,m,f_0,R,l_c,mu_0,confinement_radius)
%Function to invoke a simple rotation about the COM.
R_fun = @(theta) ([cos(theta) -sin(theta); sin(theta) cos(theta)]);
%Always start out as empty
xs_foci = [];
ys_foci = [];
x_center=[];
y_center=[];
x_c=[];
y_c=[];
%Get the same coordinates centered at the origin
%This will be helpful for torque calculations in the case of ellipses /
%non-axissym
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
    x_c= [x_c th(2*pp-1)];
    y_center=[y_center th(2*pp-0) th(2*pp-0)];
    y_c=[y_c th(2*pp-0)];
end
%Transpose all of the coordinates
x_center=x_center';
y_center=y_center';
x_c=x_c';
y_c=y_c';
xs_foci =  xs_foci';
ys_foci =  ys_foci';
%Difference matrix
Xs_foci = ( xs_foci' - xs_foci );
Ys_foci = ( ys_foci' - ys_foci );
X_center= (x_center'-x_center); 
Y_center= (y_center'-y_center);


Rs_foci = ( Xs_foci.^2 + Ys_foci.^2).^(1/2);
Rs_center= ( X_center.^2 + Y_center.^2).^(1/2);

Ones_Mat = ones(size(Rs_foci));
%Make a block diagonal matrix that is a block of (1 1 ; 1 1) repeated
%n times if there are n disks/ellipses
A = [1 1 ; 1 1];
Blocks = kron(eye(length(avec)),A);
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

sumvec = ones(length(avec)*2,1); %Given the code is written for ellipses more generally
%each particle has two locations to sum forces over 
 
Fxvec = Fx*sumvec;
Fyvec = Fy*sumvec;
F_xgroup = reshape(Fxvec,[2,length(avec)]);
F_ygroup = reshape(Fyvec,[2,length(avec)]);

%Total x force on each ellipse from pairwise interactions and confinement.
Fx_trans = sum(F_xgroup,1)-sign(x_c').*(abs(x_c')./sqrt(x_c'.^2+y_c'.^2)).*0.3.*sech( 15.*abs(R+sqrt(x_c'.^2+y_c'.^2)-confinement_radius)./l_c );
%Total y force on each ellipse from pairwise interactions and confinement.
Fy_trans = sum(F_ygroup,1)-sign(y_c').*(abs(y_c')./sqrt(x_c'.^2+y_c'.^2)).*0.3.*sech( 15.*abs(R+sqrt(x_c'.^2+y_c'.^2)-confinement_radius)./l_c );
dydt = [];
for qq = 1:length(avec)
    dydt = [dydt ; that./m.*Fx_trans(qq) ; that./m.*Fy_trans(qq) ];
end