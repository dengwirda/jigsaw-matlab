function [tscr] = triscr3(pp,t3)
%TRISCR3 calc. vol.-len. ratios for triangles in a 3-simplex
%triangulation in euclidean space.
%   [SCR3] = TRISCR3(VERT,TRIA) returns the vol.-len. ratios
%   where SCR3 is a T-by-1 vector, VERT is a V-by-D array of
%   XY coordinates, and TRIA is a T-by-4 array of
%   vertex indexing, where each row defines a triangle, such
%   that VERT(TRIA(II,1),:), VERT(TRIA(II,2),:),
%   VERT(TRIA(II,3),:) and VERT(TRIA(II,4),:) are the coord-
%   inates of the II-TH triangle.
%
%   See also TRIVOL3, TRIANG3, TRIBAL3

%   Darren Engwirda : 2017 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 10/08/2018

%--------------------------- compute signed area-len. ratios
    scal = 6.0 * sqrt(2.0);

    lrms = sum((pp(t3(:,2),:)        ...
              - pp(t3(:,1),:)).^2,2) ...
         + sum((pp(t3(:,3),:)        ...
              - pp(t3(:,2),:)).^2,2) ...
         + sum((pp(t3(:,1),:)        ...
              - pp(t3(:,3),:)).^2,2) ...
         + sum((pp(t3(:,4),:)        ...
              - pp(t3(:,1),:)).^2,2) ...
         + sum((pp(t3(:,4),:)        ...
              - pp(t3(:,2),:)).^2,2) ...
         + sum((pp(t3(:,4),:)        ...
              - pp(t3(:,3),:)).^2,2) ;

    lrms =(lrms / 6.0) .^ 1.50 ;

    tvol = trivol3(pp,t3) ;

    tscr = scal * tvol ./ lrms ;


end



