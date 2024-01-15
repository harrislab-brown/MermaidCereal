clear all
close all

num_sims = 1; %% Number of times for each packing fraction to run sim
nvec = 30:10:60;%% Vector of number of particles to run per trial

for mm = 1:length(nvec)
    N = nvec(mm) %% Number of particles
    t0         = 0;     %% beginning time
    tEnd1      = 200; %% end first mass at tEnd1
    for kk = 1:num_sims
%% Potential parameters
        R=0.003; %% Disk radius
        w=1; %% weight coefficient for when mass change is applied
        mass_disk=(1.9e-04/2)/w; %% disk mass
        m=1.15*0.00087/2; %% magnet dipole strength for each foci point. Remeber this is the general ellipse code.
        rho=1141; %% liquid density
        gamma=0.066; %% liquid surfae tension
        l_c=sqrt(gamma/((rho-1)*9.8)); %% capillary length
        mu_0=4*pi*10^-7; %% magnetic constant
        f_0=(mass_disk*9.8)^2*sqrt(R)/(pi^2*gamma*(l_c)^(3/2)*((R/l_c)^2+(2*R/l_c))^2); %% Capillary force coefficient from 2019 preprint
        confinement_radius=0.06; %% condinement size in m
        psi=0:360; %% angle parameter for confinement's x y coordinate
        x_confine=confinement_radius*cosd(psi); %% x position of confinement's points
        y_confine=confinement_radius*sind(psi); %% y position of confinement's points
        phi=N*pi*R^2/(pi*confinement_radius^2);  %% surface packing fraction of disks
        I=pi*R^4/4; %% disks' moment of inertia
        a=0; %% eccentricity for the ellipse model in unit m. 0 for circles
        avec=a*ones(N,1); %% vector of eccentricity values for all disks. A combination of disks and ellipses can be incorporated.
        that=0.5; %% viscous time scale for damping
%% polar random initial distribution
        randinitcons = init_cond_maker(0.92*confinement_radius,N,R); %Initial conditions are chosen to fit in a slightly smaller
        %initial confinement space to mimic a meniscus present
        xvec= randinitcons(:,1);
        yvec= randinitcons(:,2);
        initcon = [xvec yvec]';  
%% first mass ODE45 solver
        [t,th] = ode45(@(t,th) motion_nbod_confine(t,th,that,avec,I,m,f_0,R,l_c,mu_0,confinement_radius),[t0 tEnd1],initcon);
        %Outputting data from the simulation
        Xset=th(:,1:2:end); %% X position of N disks at M times (MxN)
        Yset=th(:,2:2:end); %% Y position of N disks at M times (MxN)
        xfinals(:,kk) = Xset(end,:)';
        yfinals(:,kk) = Yset(end,:)';
        end
    save(num2str(nvec(mm) ) );
    clear xfinals yfinals
end