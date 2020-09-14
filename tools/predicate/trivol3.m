function [vol3] = trivol3(pp,t3)
%TRIVOL3 calc. simplex volumes for a 3-simplex triangulation
%embedded in euclidean space.
%   [VOL3] = TRIVOL3(VERT,TRIA) returns the signed simplex
%   volumes, where VOL3 is a T-by-1 vector, VERT is a V-by-D
%   array of XY coordinates, and TRIA is a T-by-4 array of
%   vertex indexing, where each row defines a triangle, such
%   that VERT(TRIA(II,1),:), VERT(TRIA(II,2),:), VERT(
%   TRIA(II,3),:) and VERT(TRIA(II,4),:) are the coordinates
%   of the II-TH tetrahedron.
%
%   See also TRISCR3, TRIANG3, TRIBAL3

%   Darren Engwirda : 2017 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 10/0/2018

%---------------------------------------------- basic checks
    if (~isnumeric(pp) || ~isnumeric(t3) )
        error('trivol3:incorrectInputClass' , ...
            'Incorrect input class.') ;
    end

%---------------------------------------------- basic checks
    if (ndims(pp) ~= +2 || ndims(t3) ~= +2 )
        error('trivol3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end
    if (size(pp,2) < +3 || size(t3,2) < +4 )
        error('trivol3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

    nnod = size(pp,1) ;

%---------------------------------------------- basic checks
    if (min(min(t3(:,1:4))) < +1 || ...
            max(max(t3(:,1:4))) > nnod )
        error('trivol3:invalidInputs', ...
            'Invalid TRIA input array.') ;
    end

%--------------------------------------- compute signed vol.
    switch (size(pp,2))
        case +3

        vv14 = pp(t3(:,4),:)-pp(t3(:,1),:) ;
        vv24 = pp(t3(:,4),:)-pp(t3(:,2),:) ;
        vv34 = pp(t3(:,4),:)-pp(t3(:,3),:) ;

        vdet = ...
            + vv14(:,1) .* ...
             (vv24(:,2).*vv34(:,3)  ...
            - vv24(:,3).*vv34(:,2)) ...
            - vv14(:,2) .* ...
             (vv24(:,1).*vv34(:,3)  ...
            - vv24(:,3).*vv34(:,1)) ...
            + vv14(:,3) .* ...
             (vv24(:,1).*vv34(:,2)  ...
            - vv24(:,2).*vv34(:,1)) ;

        vol3 = vdet / 6.0;

        otherwise
        error('Unsupported dimension.') ;

    end

end



