function f = init_cond_maker(R,n,a)
    points = [];
    %Choosing an initial point in the circle.
    p1 = [1/3.*R ; 0];
    points = [points p1];
    for j = 2:n
        totals = 1; %initial total number of overlapping particles 
        rmax = 2*R; %An initial rmax.
        while totals > 0 || rmax > R 
            rtry = R.*sqrt(rand(1));   
            thtry = rand(1).*2*pi;
            xtry = rtry.*cos(thtry) ; %trial point x value
            ytry = rtry.*sin(thtry) ; %trial point y value
            %conditions to ensure no overlap and in confinement.
            rmax = sqrt(xtry.^2 + ytry.^2); %Should be in confinement.
            xdiff = points(1,:) - xtry;
            ydiff = points(2,:) - ytry;
            rdiff = sqrt(xdiff.^2 + ydiff.^2) -2*a;
            totals = sum(rdiff < 0) ; 
        end
        newpoint = [ xtry ; ytry];
        points = [points newpoint]; %Add the new point to collection.
    end
    f = points' ;