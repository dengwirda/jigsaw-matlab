function [fval] = trifun2(test,vert,tria,tree,ftri)
%TRIFUN2 evaluate a discrete function defined on a 2-simplex
%triangulation embedded in R^2.
%   [FVAL] = TRIFUN2(TEST,VERT,TRIA,TREE,FTRI) returns an
%   interpolation of the triangle-based function FTRI to the
%   queries points TEST. FVAL is a Q-by-1 array of function
%   values associated with the Q-by-D array of XY coordina-
%   tes TEST. {VERT,TRIA,FTRI} is a discrete triangle-based
%   function, where VERT is a V-by-2 array of XY coordinates
%   TRIA is a T-by-3 array of triangles and FTRI is a V-by-1
%   array of mesh-size values. Each row of TRIA defines a
%   triangle, such that VERT(TRIA(II,1),:),
%   VERT(TRIA(II,2),:) and VERT(TRIA(II,3),:) are the coord-
%   inates of the II-TH triangle. TREE is a spatial indexing
%   structure for {VERT,TRIA}, as returned by IDXTRI2.
%
%   See also IDXTRI2

%   Darren Engwirda : 2017 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 25/07/2018

%---------------------------------------------- basic checks
    if ( ~isnumeric(test) || ...
         ~isnumeric(vert) || ...
         ~isnumeric(tria) || ...
         ~isnumeric(ftri) || ...
         ~isstruct (tree) )
        error('trifun2:incorrectInputClass' , ...
            'Incorrect input class.') ;
    end

%---------------------------------------------- basic checks
    if (ndims(test) ~= +2 || ...
        ndims(vert) ~= +2 || ...
        ndims(tria) ~= +2 || ...
        ndims(ftri) ~= +2 )
        error('trifun2:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end
    if (size(test,2)~= +2 || ...
        size(vert,2)~= +2 || ...
        size(tria,2) < +3 || ...
        size(ftri,2)~= +1 || ...
        size(vert,1)~= size(ftri,1) )
        error('trifun2:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

    nvrt = size(vert,1) ;

%---------------------------------------------- basic checks
    if (min(min(tria(:,1:3))) < +1 || ...
            max(max(tria(:,1:3))) > nvrt )
        error('trifun2:invalidInputs', ...
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

    a1 = orient1(vert(tria(ti,2),:),...
                 vert(tria(ti,3),:),...
                 test(in,:)) ;

    a2 = orient1(vert(tria(ti,3),:),...
                 vert(tria(ti,1),:),...
                 test(in,:)) ;

    a3 = orient1(vert(tria(ti,1),:),...
                 vert(tria(ti,2),:),...
                 test(in,:)) ;

    fval(in) = a1.*ftri(tria(ti,1)) ...
             + a2.*ftri(tria(ti,2)) ...
             + a3.*ftri(tria(ti,3)) ;

    fval(in) = fval(in)./(a1+a2+a3) ;

    end

end



