function [ip,ix,tr] = findpoly(pp,ee,pj,varargin)
%FINDPOLY point-in-polygon queries for polygon collections.
%   [IP,IX] = FINDPOLY(PP,EE,PJ) returns the set of polygons
%   that enclose the points in the distribution PJ. Polygons
%   are specified via the cell arrays:
%
%       PP{kk} = [X11,Y11;X22,Y22;...;XNN,YNN];
%       EE{kk} = [E11,E12;E21,E22;...;EM1;EM2];
%
%   where PP{kk} defines the vertex coordinates of the KK-th
%   polygon, and EE{kk} defines its edges. Each edge is
%   specified as a pair of vertex indices, such that
%   PP{kk}(EE{kk}(II,1),:) and PP{kk}(EE{kk}(II,2),:) define
%   the endpoints of the II-th edge in the KK-th polygon.
%
%   A set of intersecting polygons is returned for each
%   query point in PJ, such that the II-th point is associa-
%   ted with the polygons IX(IP(II,1):IP(II,2)). Unenclosed
%   points have IP(II,1) == +0.
%
%   In general, query points may be matched to multiple pol-
%   gons (in cases where polygons overlap).
%
%   [IP,IX,TR] = FINDPOLY(PP,EE,PJ) additionally returns the
%   supporting aabb-tree used internally to compute the que-
%   ry. If the underlying collection [PP,EE] is static, the
%   tree TR may be passed to subsequent calls, via [...] =
%   FINDPOLY(PP,EE,PJ,TR). This syntax may lead to improved
%   performance, especially when the number of polygons
%   is large w.r.t. the number of query points. Note that in
%   such cases the underlying polygons are NOT permitted to
%   change between calls, or erroneous results may be retur-
%   ned. Additional parameters used to control the creation
%   of the underlying aabb-tree may also be passed via [...]
%   = FINDPOLY(PP,EE,PI,TR,OP). See MAKETREE for additional
%   information.
%
%   See also MAKETREE, EXCHANGE

%   Given K polygons (each with M edges on average) the task
%   is to find the enclosing polygons for a set of N points.
%   The (obvious) naive implementation is expensive, leading
%   to O(K*M*N) complexity (based on a simple loop over all
%   polygons, and calling a standard points-in-polygon test
%   for each individually). This code aims to do better:
%
% * Employing a "fast" inpolygon routine, reducing the comp-
%   lexity of each points-in-polygon test (based on spatial
%   sorting) to approximately O((N+M)*log(N)).
%
% * Employing a spatial tree (an aabb-tree) to localise each
%   points-in-polygon query within a spatially local "tile".
%   This typically gains another logarithmic factor, so is a
%   big win for large K.

%   Darren Engwirda : 2020 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 29/03/2020

    ip = []; ix = []; tr = []; op = [];

%---------------------------------------------- basic checks
    if (nargin < +3 || nargin > +5)
        error('findpoly:incorrectNumInputs', ...
            'Incorrect number of inputs.');
    end

%------------------------------- fast return on empty inputs
    if (isempty(pj)), return; end

%------------------------------- extract user-defined inputs
    if (nargin >= +4), tr = varargin{1}; end
    if (nargin >= +5), op = varargin{2}; end

%---------------------------------------------- basic checks
    if (~iscell(pp) || ~iscell(ee) || ...
        ~isnumeric(pj) )
        error('findpoly:incorrectInputClass', ...
            'Incorrect input class.') ;
    end

%---------------------------------------------- basic checks
    if (any(cellfun('ndims', pp) ~= +2) || ...
            any(cellfun('size', pp, 2) ~= +2))
        error('findpoly:incorrectDimensions', ...
            'Incorrect input dimensions.');
    end
    if (any(cellfun('ndims', ee) ~= +2) || ...
            any(cellfun('size', ee, 2) ~= +2))
        error('findpoly:incorrectDimensions', ...
            'Incorrect input dimensions.');
    end

%------------------------------- test query array for VERT's
    if (ndims(pj) ~= +2 || size(pj,2) ~= +2 )
        error('findpoly:incorrectDimensions', ...
            'Incorrect input dimensions.');
    end

%---------------------------------------------- basic checks
    if (~isempty(tr) && ~isstruct(tr) )
        error('findpoly:incorrectInputClass', ...
            'Incorrect input class.') ;
    end
    if (~isempty(op) && ~isstruct(op) )
        error('findpoly:incorrectInputClass', ...
            'Incorrect input class.') ;
    end

    if (isempty(tr))
%------------------------------ compute aabb's for poly-sets
        bb = zeros(numel(ee),4);
        xx = cellfun( ...
            @min,pp,'uniformoutput',false) ;
        xx = [xx{:}];
        bb(:,1) = xx(1:2:end-1);
        bb(:,2) = xx(2:2:end-0);

        xx = cellfun( ...
            @max,pp,'uniformoutput',false) ;
        xx = [xx{:}];
        bb(:,3) = xx(1:2:end-1);
        bb(:,4) = xx(2:2:end-0);

%------------------------------ compute aabb-tree for aabb's
        if (isempty(op) || ...
                ~isfield(op,'nobj'))
            op.nobj = +4;           % "aggressive" tree
        end
        tr = maketree(bb,op);       % compute aabb-tree
    end

%------------------------------ compute tree-to-vert mapping
    tm = mapvert(tr,pj) ;

%------------------------------ compute vert-to-poly queries
   [ii,px,ix] = ...
        queryset(tr,tm,@polykern,pj,pp,ee) ;

%------------------------------ re-index onto full obj. list
    ip = zeros(size(pj,1),2);
    ip( :,2) = -1 ;

    if (isempty(ii)), return; end

    ip(ii,:) = px ;

end

function [ip,ix] = polykern(pk,ik,pj,pp,ee)
%POLYKERN compute the "point vs. poly" matches within a tile

    Ip = cell(length(ik),1);
    Ix = cell(length(ik),1);

    for kk = 1:length(ik)

        in = inpoly2( ...
            pj(pk,:),pp{ik(kk)},ee{ik(kk)}) ;

        Ip{kk} = pk(in) ;
        Ix{kk} = ...
            ik(kk) * ones(length(Ip{kk}),1) ;

    end

    ip = vertcat(Ip{:}) ;
    ix = vertcat(Ix{:}) ;

end



