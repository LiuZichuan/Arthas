function [y] = fixquant(x, wordlength, frac)
%FIXQUANT Summary of this function goes here
%   Detailed explanation goes here
for i = 1:prod(size(x))
    x(i) = bin2fix(fix2bin(x(i), wordlength, frac), wordlength, frac);
end
y = x;
end

