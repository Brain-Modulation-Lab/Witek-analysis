%%  This code is adapted from a C implementation of this algorithm posted on stackoverflow.com.
%%  The post credits the algorithm to "Tricks of the Windows Game Programming Gurus" by Andre LaMothe
%%
%% Returns 1 if the lines intersect, otherwise 0. In addition, if the lines 
%% intersect the intersection point may be stored in the floats i_x and i_y.

function intersects = SegmentIntersect(S1P1, S1P2, S2P1, S2P2)

s1_x = S1P2(1) - S1P1(1);
s1_y = S1P2(2) - S1P1(2);
s2_x = S2P2(1) - S2P1(1);
s2_y = S2P2(2) - S2P1(2);


s = (-s1_y * (S1P1(1) - S2P1(1)) + s1_x * (S1P1(2) - S2P1(2))) / (-s2_x * s1_y + s1_x * s2_y);
t = ( s2_x * (S1P1(2) - S2P1(2)) - s2_y * (S1P1(1) - S2P1(1))) / (-s2_x * s1_y + s1_x * s2_y);

intersects = 0;

if (s >= 0 && s <= 1 && t >= 0 && t <= 1) 
    % Collision detected
    %int_x = S1P1(1) + (t * s1_x); 
    %int_y = S1P1(2) + (t * s1_y); 
    intersects = 1;
end

end