function drawCircles(c)
    for i = 1:length(c)
        
%         c1 = clamp(lab2rgb(c(i).dominant_colors.colors_lab(1,:)), 0, 1);
%         c2 = clamp(lab2rgb(c(i).dominant_colors.colors_lab(2,:)), 0, 1);
%         c3 = clamp(lab2rgb(c(i).dominant_colors.colors_lab(3,:)), 0, 1);
%         
%         c(i).radius = c(i).radius - 0.5;
%         d = [c(i).radius * 2 c(i).radius * 2];
%         pos = [c(i).position - (d / 2) d];
%         rectangle('Position', pos, 'Curvature', [1 1], 'FaceColor', c1, 'LineStyle', 'none');
%         
%         c(i).radius = c(i).radius * 0.707;
%         d = [c(i).radius * 2 c(i).radius * 2];
%         pos = [c(i).position - (d / 2) d];
%         rectangle('Position', pos, 'Curvature', [1 1], 'FaceColor', c2, 'LineStyle', 'none');
%         
%         c(i).radius = c(i).radius * 0.707;
%         d = [c(i).radius * 2 c(i).radius * 2];
%         pos = [c(i).position - (d / 2) d];
%         rectangle('Position', pos, 'Curvature', [1 1], 'FaceColor', c3, 'LineStyle', 'none');
        
        c1 = clamp(lab2rgb(c(i).dominant_colors.colors_lab(1,:)), 0, 1);
        c(i).radius = c(i).radius - 0.5;
        d = [c(i).radius * 2 c(i).radius * 2];
        pos = [c(i).position - (d / 2) d];
        rectangle('Position', pos, 'Curvature', [1 1], 'FaceColor', c1, 'LineStyle', 'none');
    end
end

