function out = normalizeSet(set, rounding)
%Returns the values of a set normalized to between 0 and 1


if nargin < 2
    rounding =  100;
end


input = double(set);

image = input - min(input(:));
image = image./max(image(:));

out = round((image)*rounding)/rounding;
end