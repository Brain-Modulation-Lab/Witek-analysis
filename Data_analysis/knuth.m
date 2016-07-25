function [ Xperm ] =knuth( X )
% Knuth shuffling random permutation method
% https://en.wikipedia.org/wiki/Random_permutation

Xperm = X;

    % Knuth shuffles
    for i = 1:length(X)
        j = randi([i, length(X)]);
        swap = Xperm(i);
        Xperm(i) = Xperm(j);
        Xperm(j) = swap;
    end

end

