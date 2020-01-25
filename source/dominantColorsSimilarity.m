function similarity = dominantColorsSimilarity(DC1, DC2, num_nodes)

% Returns a value in range [negative largest lab color distance, 0], where 
% large values means that the dominant color descriptors DC1 and DC2 are 
% similar. The dominant color descriptors consists of the K most dominant 
% colors of a set of colors, with a dominance percentage assigned to each 
% dominant color. They are generated by kDominantColors.m using k-means. 
% Larger num_nodes increases the accuracy, but the time complexity is 
% something like O(num_nodes^3), depending on the algorithm used by matchpairs.

% This similarity measure is based on the OCCD measure presented in the paper:
%
% Extraction of Perceptually Important Colors and Similarity Measurement 
% for Image Matching, Retrieval, and Analysis, 2002
% Aleksandra Mojsilovic, Jianying Hu and Emina Soljanin
%
% I.e create a set of num_nodes nodes for each of the two dominant color 
% descriptors and then distribute the dominant colors across these nodes
% based on the dominance percentage of the colors. Then connect
% the nodes between these two sets to create a bipartite graph, and define
% the weight/cost of each edge to be the distance between the colors of the
% connected nodes.
%
% Then it's a matter of selecting the best pairs between the sets by
% selecting the connections that minimizes the total cost of the resulting 
% graph. This is called the Assignment Problem and it can be solved using 
% the Hungarian/Munkres algorithm for example. Here I use the built in 
% 'matchpairs' function.

    % Quantize dominance distribution into discrete nodes with indexes to 
    % the corresponding dominant color
    nodes1 = quantizeDistribution(DC1.dominance, num_nodes);
    nodes2 = quantizeDistribution(DC2.dominance, num_nodes);
    
    % Calculate pair-wise color distances. dists(i,j) is the distance between
    % dominant color i in DC1 and dominant color j in DC2.
    dists = pdist2(DC1.colors_lab, DC2.colors_lab);
    
    % Create cost table / bipartite graph edge weights.
    costs = dists(nodes1, nodes2);
    
    % Find the pairings that minimizes the total cost
    matched = matchpairs(costs, 1e6);
    
    % Find the total cost by summing the cost of each pairing.
    % Use (col-1)*row_width+row to vectorize lookup
    unsimilarity = sum(costs((matched(:,2) - 1) * num_nodes +  matched(:,1)));
    
    % Normalize by dividing by the number of nodes used to quantize the
    % dominant colors so that the result is similar regardless of nodes.
    similarity = -unsimilarity / num_nodes;
end

function result = quantizeDistribution(distribution, num_elements)
    counts = sumPreservingRound(distribution * num_elements);
    ranges = cumsum(counts);
    result = ones(1, num_elements, 'uint32');
    for i = 2:length(ranges)
        result(ranges(i - 1) + 1:ranges(i)) = i;
    end
end
