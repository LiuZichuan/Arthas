function [d2b] = fix2bin(a, wordlength, frac)
%FLOAT2BIN convert a floating-point to a binary.
n = wordlength - frac;
m = frac;
maxv = (2^(wordlength-1)-1)/2^frac;
minv = -(2^(wordlength-1))/2^frac;
% d2b = fix(rem(a.*pow2(-(n-1):m), 2));
a = max(min(maxv, a), minv);
v = double(abs(a));
s = double(sign(a));
o = double(round(v*2^frac));
if s == 1
    d2b = dec2bin(o, wordlength);
else
    d2b = dec2bin(2^wordlength-double(o), wordlength);
end
if size(d2b, 2) ~= wordlength
    warning(['float to fixed overflow: a = ', num2str(a), ', d2b = ', d2b]);
end
d2b = d2b(end-wordlength+1:end);
assert(size(logical(d2b-48), 2) == wordlength);
d2b = double(logical(d2b-48));

end

