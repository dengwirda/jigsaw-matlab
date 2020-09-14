function [mesh] = extrude( ...
          mesh,levs,idir,near,varargin)
%EXTRUDE exrude a base mesh into a higher-dim. tessellation.
%   MESH = EXTRUDE(BASE,LEVS,IDIR,NEAR) creates a prismatic
%   extrusion of the base mesh BASE, with new layers created
%   at the levels defined in LEVS. The extrusion is done
%   along the axis-aligned direction IDIR, with +ve or -ve
%   values indicating sign. NEAR is a minimum bound on layer
%   thickness, with vertices snapped from above/below to
%   prevent the formation of cells with thickness < NEAR.
%
%   See also BISECT

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   09-Aug-2019
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    if(~inspect(mesh,'point')), return; end

    if (isfield(mesh,'mshID'))
        mshID =  mesh.mshID ;
    else
        mshID = 'EUCLIDEAN-MESH' ;
    end

    pass = certify(mesh) ;

    if (~isnumeric(levs) || ...
        ~isnumeric(idir) || ...
        ~isnumeric(near) )
    error('extrude:incorrectInputClass', ...
        'Incorrect input class.') ;
    end

    if (~isvector (levs) || ...
        ~isscalar (idir) || ...
        ~isscalar (near) )
    error('extrude:incorrectDimensions', ...
        'Incorrect input dimensions.') ;
    end

    if (~all(diff(levs) > 0.) && ...
        ~all(diff(levs) < 0.) )
    error('extrude:incorrectArgument', ...
        'LEVS data must be monotone.') ;
    end

    idim = abs (idir) ;
    ndim = size(mesh.point.coord,2)-1 ;

    if (idim < +1 || idim > ndim)
    error('extrude:incorrectArgument', ...
        'Invalid extrusion direction') ;
    end

    base = mesh ;

    for ilev = +1 : length (levs)

        switch (upper(mshID))

        case 'EUCLIDEAN-MESH'

       [mesh,base] = ...
             layer ( ...
        mesh,base,levs(ilev),idir,near) ;

        otherwise
        error('Invalid mshID!') ;

        end

    end

end

function [mesh,next] = ...
        layer(mesh,base,lpos,idir,near)
%LAYER extrude a layer from BASE to NEXT and append to MESH.

    idim = abs(idir) ;
    near = abs(near) ;

%------------------------------ calc. POINT's to be extruded
    mask = false( ...
        size(mesh.point.coord,1),1) ;
    mark = false( ...
        size(mesh.point.coord,1),1) ;

    if (inspect(base,'edge2','index') && ...
           ~isempty(base.edge2.index) )
    %-------------------------- extrude from EDGE-2 elements
        mask(base.edge2.index(:,1:2))  = true ;
    end

    if (inspect(base,'tria3','index') && ...
           ~isempty(base.tria3.index) )
    %-------------------------- extrude from TRIA-3 elements
        mask(base.tria3.index(:,1:3))  = true ;
    end

    if (inspect(base,'quad4','index') && ...
           ~isempty(base.quad4.index) )
    %-------------------------- extrude from QUAD-4 elements
        mask(base.quad4.index(:,1:4))  = true ;
    end

    if (idir < +0)
    %-------------------------- extrude along -ve IDIM axis
        mark(mask) = ...
    mesh.point.coord(mask,idim) > lpos + near ;
    else
        mark(mask) = ...
    mesh.point.coord(mask,idim) < lpos - near ;
    end

%------------------------------ new POINT's to extrude level
    pnew = mesh.point.coord(mark,:) ;
    pnew(:,idim) = lpos ;

    inew = zeros( ...
        size(mesh.point.coord,1),1) ;

    inew( mark) = 1 ;

    inew = cumsum(inew) + ...
        size(mesh.point.coord,1) ;

    mesh.point.coord = [
        mesh.point.coord ; pnew] ;

%------------------------------ new ELEMENT to extrude level
    next = struct () ;

    if (inspect(base,'edge2','index') && ...
           ~isempty(base.edge2.index) )
    %-------------------------- extrude from EDGE-2 elements
        M = false(size( ...
            base.edge2.index,1),2) ;
        M(:,1) = ...
        mark(base.edge2.index(:,1));
        M(:,2) = ...
        mark(base.edge2.index(:,2));

        Q = sum(int32(M),2) == +2 ;
        T = sum(int32(M),2) == +1 ;
        N = sum(int32(M),2) == +0 ;

        if (any(N))
    %-------------------------- copy "no-extrusion" elements
        if (~inspect(next,'edge2'))
        next.edge2.index = [];
        end
        next.edge2.index = [
             next.edge2.index(:,:) ;
             base.edge2.index(N,1) , ...
             base.edge2.index(N,2) , ...
             base.edge2.index(N,3)
            ] ;
        end

        if (any(Q))
    %-------------------------- extrude into QUAD-4 elements
        if (~inspect(mesh,'quad4'))
        mesh.quad4.index = [];
        end
        if (~inspect(next,'edge2'))
        next.edge2.index = [];
        end
        mesh.quad4.index = [
             mesh.quad4.index(:,:) ;
             base.edge2.index(Q,1) , ...
             base.edge2.index(Q,2) , ...
        inew(base.edge2.index(Q,2)), ...
        inew(base.edge2.index(Q,1)), ...
             base.edge2.index(Q,3)
            ] ;
        next.edge2.index = [
             next.edge2.index(:,:) ;
        inew(base.edge2.index(Q,1)), ...
        inew(base.edge2.index(Q,2)), ...
             base.edge2.index(Q,3)
            ] ;
        end

        if (any(T))
    %-------------------------- extrude into TRIA-3 elements
        if (~inspect(mesh,'tria3'))
        mesh.tria3.index = [];
        end
        if (~inspect(next,'edge2'))
        next.edge2.index = [];
        end
    %-------------------------------------- from 1-point
        V = T & M(:,1) ;
        mesh.tria3.index = [
             mesh.tria3.index(:,:) ;
             base.edge2.index(V,1) , ...
             base.edge2.index(V,2) , ...
        inew(base.edge2.index(V,1)), ...
             base.edge2.index(V,3)
            ] ;
        next.edge2.index = [
             next.edge2.index(:,:) ;
        inew(base.edge2.index(V,1)), ...
             base.edge2.index(V,2) , ...
             base.edge2.index(V,3)
            ] ;
    %-------------------------------------- from 2-point
        V = T & M(:,2) ;
        mesh.tria3.index = [
             mesh.tria3.index(:,:) ;
             base.edge2.index(V,1) , ...
             base.edge2.index(V,2) , ...
        inew(base.edge2.index(V,2)), ...
             base.edge2.index(V,3)
            ] ;
        next.edge2.index = [
             next.edge2.index(:,:) ;
             base.edge2.index(V,1) , ...
        inew(base.edge2.index(V,2)), ...
             base.edge2.index(V,3)
            ] ;
        end

    end

    if (inspect(base,'tria3','index') && ...
           ~isempty(base.tria3.index) )
    %-------------------------- extrude from TRIA-3 elements
        M = false(size( ...
            base.tria3.index,1),3) ;
        M(:,1) = ...
        mark(base.tria3.index(:,1));
        M(:,2) = ...
        mark(base.tria3.index(:,2));
        M(:,3) = ...
        mark(base.tria3.index(:,3));

        W = sum(int32(M),2) == +3 ;
        P = sum(int32(M),2) == +2 ;
        T = sum(int32(M),2) == +1 ;
        N = sum(int32(M),2) == +0 ;

        if (any(N))
    %-------------------------- copy "no-extrusion" elements
        if (~inspect(next,'tria3'))
        next.tria3.index = [];
        end
        next.tria3.index = [
             next.tria3.index(:,:) ;
             base.tria3.index(N,1) , ...
             base.tria3.index(N,2) , ...
             base.tria3.index(N,3) , ...
             base.tria3.index(N,4)
            ] ;
        end

        if (any(W))
    %-------------------------- extrude into WEDG-6 elements
        if (~inspect(mesh,'wedg6'))
        mesh.wedg6.index = [];
        end
        if (~inspect(next,'tria3'))
        next.tria3.index = [];
        end
        mesh.wedg6.index = [
             mesh.wedg6.index(:,:) ;
             base.tria3.index(W,1) , ...
             base.tria3.index(W,2) , ...
             base.tria3.index(W,3) , ...
        inew(base.tria3.index(W,1)), ...
        inew(base.tria3.index(W,2)), ...
        inew(base.tria3.index(W,3)), ...
             base.tria3.index(W,4)
            ] ;
        next.tria3.index = [
             next.tria3.index(:,:) ;
        inew(base.tria3.index(W,1)), ...
        inew(base.tria3.index(W,2)), ...
        inew(base.tria3.index(W,3)), ...
             base.tria3.index(W,4)
            ] ;
        end

        if (any(P))
    %-------------------------- extrude into PYRA-5 elements
        if (~inspect(mesh,'pyra5'))
        mesh.pyra5.index = [];
        end
        if (~inspect(next,'tria3'))
        next.tria3.index = [];
        end
    %-------------------------------------- from 12-edge
        E = P & M(:,1) & M(:,2);
        mesh.pyra5.index = [
             mesh.pyra5.index(:,:) ;
        inew(base.tria3.index(E,1)), ...
        inew(base.tria3.index(E,2)), ...
             base.tria3.index(E,2) , ...
             base.tria3.index(E,1) , ...
             base.tria3.index(E,3) , ...
             base.tria3.index(E,4)
            ] ;
        next.tria3.index = [
             next.tria3.index(:,:) ;
        inew(base.tria3.index(E,1)), ...
        inew(base.tria3.index(E,2)), ...
             base.tria3.index(E,3) , ...
             base.tria3.index(E,4)
            ] ;
    %-------------------------------------- from 23-edge
        E = P & M(:,2) & M(:,3);
        mesh.pyra5.index = [
             mesh.pyra5.index(:,:) ;
        inew(base.tria3.index(E,2)), ...
        inew(base.tria3.index(E,3)), ...
             base.tria3.index(E,3) , ...
             base.tria3.index(E,2) , ...
             base.tria3.index(E,1) , ...
             base.tria3.index(E,4)
            ] ;
        next.tria3.index = [
             next.tria3.index(:,:) ;
        inew(base.tria3.index(E,2)), ...
        inew(base.tria3.index(E,3)), ...
             base.tria3.index(E,1) , ...
             base.tria3.index(E,4)
            ] ;
    %-------------------------------------- from 31-edge
        E = P & M(:,3) & M(:,1);
        mesh.pyra5.index = [
             mesh.pyra5.index(:,:) ;
             base.tria3.index(E,1) , ...
             base.tria3.index(E,3) , ...
        inew(base.tria3.index(E,3)), ...
        inew(base.tria3.index(E,1)), ...
             base.tria3.index(E,2) , ...
             base.tria3.index(E,4)
            ] ;
        next.tria3.index = [
             next.tria3.index(:,:) ;
        inew(base.tria3.index(E,3)), ...
        inew(base.tria3.index(E,1)), ...
             base.tria3.index(E,2) , ...
             base.tria3.index(E,4)
            ] ;
        end

        if (any(T))
    %-------------------------- extrude into TRIA-4 elements
        if (~inspect(mesh,'tria4'))
        mesh.tria4.index = [];
        end
        if (~inspect(next,'tria3'))
        next.tria3.index = [];
        end
    %-------------------------------------- from 1-point
        V = T & M(:,1) ;
        mesh.tria4.index = [
             mesh.tria4.index(:,:) ;
             base.tria3.index(V,1) , ...
             base.tria3.index(V,2) , ...
             base.tria3.index(V,3) , ...
        inew(base.tria3.index(V,1)), ...
             base.tria3.index(V,4)
            ] ;
        next.tria3.index = [
             next.tria3.index(:,:) ;
        inew(base.tria3.index(V,1)), ...
             base.tria3.index(V,2) , ...
             base.tria3.index(V,3) , ...
             base.tria3.index(V,4)
            ] ;
    %-------------------------------------- from 2-point
        V = T & M(:,2) ;
        mesh.tria4.index = [
             mesh.tria4.index(:,:) ;
             base.tria3.index(V,1) , ...
             base.tria3.index(V,2) , ...
             base.tria3.index(V,3) , ...
        inew(base.tria3.index(V,2)), ...
             base.tria3.index(V,4)
            ] ;
        next.tria3.index = [
             next.tria3.index(:,:) ;
        inew(base.tria3.index(V,2)), ...
             base.tria3.index(V,3) , ...
             base.tria3.index(V,1) , ...
             base.tria3.index(V,4)
            ] ;
    %-------------------------------------- from 3-point
        V = T & M(:,3) ;
        mesh.tria4.index = [
             mesh.tria4.index(:,:) ;
             base.tria3.index(V,1) , ...
             base.tria3.index(V,2) , ...
             base.tria3.index(V,3) , ...
        inew(base.tria3.index(V,3)), ...
             base.tria3.index(V,4)
            ] ;
        next.tria3.index = [
             next.tria3.index(:,:) ;
        inew(base.tria3.index(V,3)), ...
             base.tria3.index(V,1) , ...
             base.tria3.index(V,2) , ...
             base.tria3.index(V,4)
            ] ;
        end

    end

    if (inspect(base,'quad4','index') && ...
           ~isempty(base.quad4.index) )
    %-------------------------- extrude from QUAD-4 elements
        warning( ...
        'QUAD-4 currently unsupported');
    end

end



