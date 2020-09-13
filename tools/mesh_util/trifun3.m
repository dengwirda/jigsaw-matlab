function [fval] = trifun3(test,vert,tria,tree,ftri)
%TRIFUN3 evaluate a discrete function defined on a 3-simplex
%triangulation embedded in R^3.
%   [FVAL] = TRIFUN3(TEST,VERT,TRIA,TREE,FTRI) returns an
%   interpolation of the triangle-based function FTRI to the
%   queries points TEST. FVAL is a Q-by-1 array of function
%   values associated with the Q-by-D array of XY coordina-
%   tes TEST. {VERT,TRIA,FTRI} is a discrete triangle-based
%   function, where VERT is a V-by-D array of XY coordinates
%   TRIA is a T-by-4 array of triangles and FTRI is a V-by-1
%   array of mesh-size values. Each row of TRIA defines a
%   triangle, such that VERT(TRIA(II,1),:), VERT(
%   TRIA(II,2),:), VERT(TRIA(II,3),:) and VERT(TRIA(II,4),:)
%   are the coordinates of the II-TH triangle. TREE is a
%   spatial indexing structure for {VERT,TRIA}, as returned
%   by IDXTRI3.
%
%   See also IDXTRI3

%   Darren Engwirda : 2017 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 25/07/2018

%---------------------------------------------- basic checks
    if ( ~isnumeric(test) || ...
         ~isnumeric(vert) || ...
         ~isnumeric(tria) || ...
         ~isnumeric(ftri) || ...
         ~isstruct (tree) )
        error('trifun3:incorrectInputClass' , ...
            'Incorrect input class.') ;
    end

%---------------------------------------------- basic checks
    if (ndims(test) ~= +2 || ...
        ndims(vert) ~= +2 || ...
        ndims(tria) ~= +2 || ...
        ndims(ftri) ~= +2 )
        error('trifun3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end
    if (size(test,2)~= +3 || ...
        size(vert,2)~= +3 || ...
        size(tria,2) < +4 || ...
        size(ftri,2)~= +1 || ...
        size(vert,1)~= size(ftri,1) )
        error('trifun3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

    nvrt = size(vert,1) ;

%---------------------------------------------- basic checks
    if (min(min(tria(:,1:4))) < +1 || ...
            max(max(tria(:,1:4))) > nvrt )
        error('trifun3:invalidInputs', ...
            'Invalid TRIA input array.') ;
    end

%-------------------------------------- test-to-tria queries
   [tp,tj] = ...
    findtria (vert,tria,test,tree);

    if (isempty(tp))
        in = false(size(test,1),1);
        ti = [];
    else
        in = tp(:,1) > +0 ;
        ti = tj(tp(in,+1));
    end

%-------------------------------------- calc. linear interp.
    fval = +inf * ones(size(test,1),1) ;

    if (any(in))

    v1 = orient2(vert(tria(ti,2),:),...
                 vert(tria(ti,3),:),...
                 vert(tria(ti,4),:),...
                 test(in,:)) ;

    v2 = orient2(vert(tria(ti,1),:),...
                 vert(tria(ti,3),:),...
                 vert(tria(ti,4),:),...
                 test(in,:)) ;

    v3 = orient2(vert(tria(ti,1),:),...
                 vert(tria(ti,2),:),...
                 vert(tria(ti,4),:),...
                 test(in,:)) ;

    v4 = orient2(vert(tria(ti,1),:),...
                 vert(tria(ti,2),:),...
                 vert(tria(ti,3),:),...
                 test(in,:)) ;

    fval(in) = v1.*ftri(tria(ti,1)) ...
             + v2.*ftri(tria(ti,2)) ...
             + v3.*ftri(tria(ti,3)) ...
             + v4.*ftri(tria(ti,4)) ;

    fval(in) = fval(in)./(v1+v2+v3+v4) ;

    end

end



