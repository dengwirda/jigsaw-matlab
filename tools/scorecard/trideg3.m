function [vdeg] = trideg3(pp,t3)
%TRIDEG3 calc. topological degree for vertices in a 3-simpl-
%ex triangulation.
%   [VDEG] = TRIDEG3(VERT,TRIA) returns the no. of triangles
%   incident to each vertex. VDEG is a V-by-1 array of vert-
%   ex degrees, VERT is a V-by-D array of XY coordinates,
%   and TRIA is a T-by-4 array of vertex indexing, where
%   each row defines a triangle, such that
%   VERT(TRIA(II,1),:), VERT(TRIA(II,2),:),
%   VERT(TRIA(II,2),:), VERT(TRIA(II,3),:) are the coordina-
%   tes of the II-TH tetrahedron.
%
%   See also TRISCR3, TRIVOL3, TRIANG3, TRIBAL3

%   Darren Engwirda : 2017 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 29/07/2018

%---------------------------------------------- basic checks
    if (~isnumeric(pp) || ~isnumeric(t3) )
        error('trideg3:incorrectInputClass' , ...
            'Incorrect input class.') ;
    end

%---------------------------------------------- basic checks
    if (ndims(pp) ~= +2 || ndims(t3) ~= +2 )
        error('trideg3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end
    if (size(pp,2) < +3 || size(t3,2) < +4 )
        error('trideg3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

    nvrt = size(pp,1) ;
    ntri = size(t3,1) ;

%---------------------------------------------- basic checks
    if (min(min(t3(:,1:4))) < +1 || ...
            max(max(t3(:,1:4))) > nvrt )
        error('trideg3:invalidInputs', ...
            'Invalid TRIA input array.') ;
    end

%------------------------------------- compute vertex degree
    vdeg = sum(sparse( ...
        t3(:,1:4),repmat( ...
            (1:ntri)',1,4),+1,nvrt,ntri),2) ;

    vdeg = full(vdeg);

end



