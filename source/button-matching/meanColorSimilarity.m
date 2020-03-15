function similarity = meanColorSimilarity(MC1, MC2)
    similarity = -sqrt(sum((MC2 - MC1).^2));
end

