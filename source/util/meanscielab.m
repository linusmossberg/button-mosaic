function mean_scielab = meanscielab(reproduced, reference, distance, PPI)
    D65_wp = [0.9504, 1.0000, 1.0888];
    XYZ_reference = rgb2xyz(reference, 'WhitePoint', 'd65');
    XYZ_reproduced = rgb2xyz(reproduced, 'WhitePoint', 'd65');
    D = distance * 39.3700787;
    SPD = PPI * D * tan(pi/180);
    scielab_map = scielab(SPD, XYZ_reference, XYZ_reproduced, D65_wp, 'xyz');
    mean_scielab = mean(scielab_map(:));
end

