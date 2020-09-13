function [tree] = idxtri3(vert,tria)
%IDXTRI3 create a spatial-indexing structure for a 3-simplex
%triangulation.
%   [TREE] = IDXTRI3(VERT,TRIA) returns an AABB-tree design-
%   ed to accelerate spatial queries into the triangulation
%   defined by {VERT,TRIA}. VERT is a V-by-D array of XY co-
%   ordinates and TRIA is a T-by-4 array of triangles. Each
%   row defines a triangle, such that VERT(TRIA(II,1),:),
%   VERT(TRIA(II,2),:), VERT(TRIA(II,3),:) and VERT(
%   TRIA(II,3),:) are the coordinates of the II-TH triangle.
%
%   See also MAKETREE

%   Darren Engwirda : 2017 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 10/07/2018

%---------------------------------------------- basic checks
    if ( ~isnumeric(vert) || ...
         ~isnumeric(tria) )
        error('idxtri3:incorrectInputClass' , ...
            'Incorrect input class.') ;
    end

%---------------------------------------------- basic checks
    if (ndims(vert) ~= +2 || ...
        ndims(tria) ~= +2 )
        error('idxtri3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end
    if (size(vert,2) < +3 || ...
        size(tria,2) < +4 )
        error('idxtri3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

    nvrt = size(vert,1) ;

%---------------------------------------------- basic checks
    if (min(min(tria(:,1:4))) < +1 || ...
            max(max(tria(:,1:4))) > nvrt )
        error('idxtri3:invalidInputs', ...
            'Invalid TRIA input array.') ;
    end

%------------------------------ calc. AABB indexing for TRIA
    bmin = vert(tria(:,1),:);
    bmax = vert(tria(:,1),:);

    for ii = 2 : size(tria,2)
        bmin = ...
        min(bmin,vert(tria(:,ii), :));
        bmax = ...
        max(bmax,vert(tria(:,ii), :));
    end

    isoctave = exist( ...
        'OCTAVE_VERSION','builtin') > +0 ;

    if (isoctave)

    %-- faster for OCTAVE with large tree block size; slower
    %-- loop execution...

        opts.nobj = +256 ;

    else

    %-- faster for MATLAB with small tree block size; better
    %-- loop execution...

        opts.nobj = + 16 ;

    end

    tree = maketree([bmin,bmax],opts);

end



