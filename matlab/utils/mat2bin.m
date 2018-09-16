function [out] = mat2bin(data, wordlen, fraclen)
%MAT2ROM 
out = [];
assert (ndims(data) == 2);
for i = 1: size(data, 1)
    row = [];
    for j = 1: size(data, 2)
        row = [row, fix2bin(data(i, j), wordlen, fraclen)];
    end
    out = [out; row];
end
out = logical(out);
