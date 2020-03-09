function drawCircles(c, width, height)
    for i = 1:length(c)  
        c1 = clamp(lab2rgb(c(i).dominant_colors.colors_lab(1,:)), 0, 1);
        radius = (c(i).radius * 2 + 1) / 2;
        radius = radius - 1;
        d = [radius * 2 radius * 2];
        pos = [c(i).position - (d / 2) d];
        rectangle('Position', pos, 'Curvature', [1 1], 'FaceColor', c1, 'LineStyle', 'none');
    end
    
    xlim([0 width])
    ylim([0 height])

    set ( gca, 'ydir', 'reverse' )
    pbaspect([width height 1])
    set(gca,'Color','k')
end

