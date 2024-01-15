packingfraclist_list = dir ('*.mat'); 
colors = winter(size(packingfraclist_list,1) );

for kk = 1:size(packingfraclist_list,1)
    points = open(packingfraclist_list(kk).name);
    xfinals = points.xfinals;
    yfinals = points.yfinals;
    num_sims = points.num_sims;
    confinement_radius = points.confinement_radius;
    R = points.R;
    N = points.N;
    x_confine = points.x_confine;
    y_confine = points.y_confine;  
%% Plotting the Configuration and Saving the Plot        
    for uu = 1:200:num_sims
        figure()
        plot(xfinals(:,uu),yfinals(:,uu),'.','color',[173 146 183]/256,'markersize',42);
        axis square
        hold on
        plot(x_confine,y_confine,'k-','LineWidth',2)
        xlim([-confinement_radius,confinement_radius]) %Plotting the Middle Grid
        ylim([-confinement_radius,confinement_radius]) %Plotting the Middle Grid
        axis square 
        box on
        set(gca,'linewidth',3.0)
        set(gca, 'FontName', 'Times New Roman', 'FontSize', 16)
        xlabel('$$x$$', 'Interpreter', 'Latex', 'FontSize', 16)
        ylabel('$$y$$', 'Interpreter', 'Latex', 'FontSize', 16)
        title(['phi = ' num2str(points.phi)], 'Interpreter', 'Latex', 'FontSize', 16)
        %change to eps for paper, jpg for sharing now.
        saveas(gcf,append('example_phi_',num2str(round(1000*points.phi)) ),'jpg')
    end
end