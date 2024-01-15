packingfraclist_list = dir ('*.mat'); 
colors = winter(size(packingfraclist_list,1) );

for kk = 1:size(packingfraclist_list,1)
    points = open(packingfraclist_list(kk).name);
    x_center = points.xfinals;
    y_center = points.yfinals;
    num_sims = points.num_sims;
    N = points.N;
    L = points.L;  
    for uu =1:1:num_sims
        rr = L*[1 1 1 0 0 -1 -1 -1 ; -1 0 1 -1 1 -1 0 1];
        x_centertry = x_center(:,uu);
        y_centertry = y_center(:,uu);
        x_centers = x_center(:,uu);
        y_centers = y_center(:,uu);
        for yy = 1:8
            xadd = rr(1,yy);
            yadd = rr(2,yy);
            x_centers = [x_centers x_centertry+xadd];
            y_centers = [y_centers y_centertry+yadd];
        end
%% Plotting the Configuration and Saving the Plot        
        figure()
        plot(x_centers,y_centers,'.','color',[173 146 183]/256,'markersize',42);
        axis square
        set(gca,'linewidth',3.0)
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 16)
        title(['phi = ' num2str(points.phi)], 'Interpreter', 'Latex', 'FontSize', 16)
        xlim([-L*0.5,0.5*L]) %Plotting the Middle Grid
        ylim([-L*0.5,0.5*L]) %Plotting the Middle Grid
        set(gca,'XTick',[], 'YTick', [])
        set(gca,'XLabel',[], 'YLabel', [])
        set(gcf,'color','w')
        set(gca,'box','on')
        drawnow()
        %change to eps for paper, jpg for sharing now.
        saveas(gcf,append('example_phi_',num2str(uu),'_',num2str(1000*points.phi)),'jpg')
    end
end