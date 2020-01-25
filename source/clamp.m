function result = clamp(value, lower, upper)
  result = min(max(value, lower), upper);
end

