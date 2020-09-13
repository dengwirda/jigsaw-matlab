function [area] = trivol2(pp,t2)
%TRIVOL2 calc. triangle areas for a 2-simplex triangulation
%embedded in euclidean space.
%   [AREA] = TRIVOL2(VERT,TRIA) returns the signed triangle
%   areas, where AREA is a T-by-1 vector, VERT is a V-by-2
%   array of XY coordinates, and TRIA is a T-by-3 array of
%   vertex indexing, where each row defines a triangle, such
%   that VERT(TRIA(II,1),:), VERT(TRIA(II,2),:) and VERT(
%   TRIA(II,3),:) are the coordinates of the II-TH triangle.
%
%   See also TRISCR2, TRIANG2, TRIBAL2

%   Darren Engwirda : 2017 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 03/05/2018

%---------------------------------------------- basic checks
    if (~isnumeric(pp) || ~isnumeric(t2) )
        error('trivol2:incorrectInputClass' , ...
            'Incorrect input class.') ;
    end

%---------------------------------------------- basic checks
    if (ndims(pp) ~= +2 || ndims(t2) ~= +2 )
        error('trivol2:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end
    if (size(pp,2) < +2 || size(t2,2) < +3 )
        error('trivol2:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

    nnod = size(pp,1) ;

%---------------------------------------------- basic checks
    if (min(min(t2(:,1:3))) < +1 || ...
            max(max(t2(:,1:3))) > nnod )
        error('trivol2:invalidInputs', ...
            'Invalid TRIA input array.') ;
    end

%--------------------------------------- compute signed area
    ev12 = pp(t2(:,2),:)-pp(t2(:,1),:) ;
    ev13 = pp(t2(:,3),:)-pp(t2(:,1),:) ;

    switch (size(pp,2))
        case +2

        area = ev12(:,1).*ev13(:,2) ...
             - ev12(:,2).*ev13(:,1) ;
        area = 0.5 * area;

        case +3

        avec = cross(ev12,ev13);
        area = sqrt(sum(avec.^2,2)) ;
        area = 0.5 * area;

        otherwise
        error('Unsupported dimension.') ;

    end

end



