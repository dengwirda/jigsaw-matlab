function [vdeg] = trideg2(pp,t2)
%TRIDEG2 calc. topological degree for vertices in a 2-simpl-
%ex triangulation.
%   [VDEG] = TRIDEG2(VERT,TRIA) returns the no. of triangles
%   incident to each vertex. VDEG is a V-by-1 array of vert-
%   ex degrees, VERT is a V-by-D array of XY coordinates,
%   and TRIA is a T-by-3 array of vertex indexing, where
%   each row defines a triangle, such that
%   VERT(TRIA(II,1),:), VERT(TRIA(II,2),:) and
%   VERT(TRIA(II,3),:) are the coordinates of the II-TH tri-
%   angle.
%
%   See also TRISCR2, TRIVOL2, TRIANG2, TRIBAL2

%   Darren Engwirda : 2017 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 29/07/2018

%---------------------------------------------- basic checks
    if (~isnumeric(pp) || ~isnumeric(t2) )
        error('trideg2:incorrectInputClass' , ...
            'Incorrect input class.') ;
    end

%---------------------------------------------- basic checks
    if (ndims(pp) ~= +2 || ndims(t2) ~= +2 )
        error('trideg2:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end
    if (size(pp,2) < +2 || size(t2,2) < +3 )
        error('trideg2:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

    nvrt = size(pp,1) ;
    ntri = size(t2,1) ;

%---------------------------------------------- basic checks
    if (min(min(t2(:,1:3))) < +1 || ...
            max(max(t2(:,1:3))) > nvrt )
        error('trideg2:invalidInputs', ...
            'Invalid TRIA input array.') ;
    end

%------------------------------------- compute vertex degree
    vdeg = sum(sparse( ...
        t2(:,1:3),repmat( ...
            (1:ntri)',1,3),+1,nvrt,ntri),2) ;

    vdeg = full(vdeg);

end



