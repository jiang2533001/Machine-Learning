function d = distance( center, sample )
%Calculate ditance between the given sample and the given center
difference = sample  - center;
d = sqrt(difference * (difference.'));
%
end

