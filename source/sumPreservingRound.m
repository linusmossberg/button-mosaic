% https://en.wikipedia.org/wiki/Largest_remainder_method

function integers = sumPreservingRound(real_numbers)
    integers = floor(real_numbers);
    
    % Remainder that has to be distributed to integers to preserve the sum
    remainder = round(sum(real_numbers)) - sum(integers);
    
    % Find the numbers that had the largest remainder in the floor conversion.
    remainders = real_numbers - integers;
    [~,idx] = sort(remainders, 'descend');
    
    % Distribute the remainder to these integers.
    integers(idx(1:remainder)) = integers(idx(1:remainder)) + 1;
end

