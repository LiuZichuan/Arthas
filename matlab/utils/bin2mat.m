function [out] = bin2mat(data, length, frac)
%BIN2MAT 
out = [];
assert (ndims(data) == 2);
for i = 1: size(data, 1)
    row = bin2fix(data(i, :), length, frac);
    out = [out; row];
end
end

