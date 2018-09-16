function [b2d] = bin2fix(a, wordlength, frac)
%BIN2FLOAT convert the binary value into double format.
n = wordlength - frac;
m = frac;
% b2d = a*pow2([n-1:-1:-m]).';
a = sum(2.^(wordlength-1:-1:0).*a);

if (a >= 2^(wordlength-1))
    a = 2^wordlength - a;
    assert (a >= 0);
    b2d = -a/ 2^frac;
else
    assert (a >= 0);
    b2d = a/ 2^frac;
end

