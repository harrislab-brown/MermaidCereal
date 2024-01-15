function f = init_cond_maker_square(L,n,a)
    points = [];
    %Choosing an initial point in the square.
    p1 = [0.01.*L ; 0.01.*L];
    points = [points p1];
    for j = 2:n
        totals = 1;
        while totals > 0 
        xtry = L.*rand()-L/2 ;  %trial point x value
        ytry = L.*rand()-L/2 ;  %trial point y value  
        xdiff = points(1,:) - xtry;
        ydiff = points(2,:) - ytry;
        %conditions to ensure no overlap and in confinement.
        rdiff = sqrt(xdiff.^2 + ydiff.^2) -2*a;
        totals = sum(rdiff < 0) ; 
        end
        newpoint = [ xtry ; ytry];
        points = [points newpoint]; %Add the new point to collection.
    end
    f = points' ; 