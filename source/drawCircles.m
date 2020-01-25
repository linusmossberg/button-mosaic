function drawCircles(c)
    for i = 1:length(c)
        
        c(i).radius = c(i).radius - 0.5;
        d = [c(i).radius * 2 c(i).radius * 2];
        pos = [c(i).position - (d / 2) d];
        rectangle('Position', pos, 'Curvature', [1 1], 'FaceColor', c(i).dominant_colors.colors(1,:), 'LineStyle', 'none');
        
        c(i).radius = c(i).radius * 0.707;
        d = [c(i).radius * 2 c(i).radius * 2];
        pos = [c(i).position - (d / 2) d];
        rectangle('Position', pos, 'Curvature', [1 1], 'FaceColor', c(i).dominant_colors.colors(2,:), 'LineStyle', 'none');
        
        c(i).radius = c(i).radius * 0.707;
        d = [c(i).radius * 2 c(i).radius * 2];
        pos = [c(i).position - (d / 2) d];
        rectangle('Position', pos, 'Curvature', [1 1], 'FaceColor', c(i).dominant_colors.colors(3,:), 'LineStyle', 'none');
    end
end

