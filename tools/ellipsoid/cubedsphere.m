function [mesh] = cubedsphere(opts,nlev)
%CUBEDSPHERE an Nth-level cubedsphere mesh of the ellipsoid
%defined by GEOM.RADII.
%
%   See also JIGSAW
%

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   03-Sep-2020
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    if (~isempty(opts) && ~isstruct (opts))
        error('JIGSAW: invalid input types.');
    end
    if (~isempty(nlev) && ~isnumeric(nlev))
        error('JIGSAW: invalid input types.');
    end

    if (~isfield(opts, 'geom_file'))
        error('JIGSAW: need OPTS.GEOM_FILE.');
    end
    if (~isfield(opts, 'mesh_file'))
        error('JIGSAW: need OPTS.MESH_FILE.');
    end

    geom = loadmsh(opts.geom_file);

%-------------------------------- setup cubedsphere geometry
    aval = atan(sqrt(2.)/2.) / pi ;

    mesh.mshID =  'euclidean-mesh';
    apos = [
       +.25*pi, -aval*pi
       +.75*pi, -aval*pi
       -.75*pi, -aval*pi
       -.25*pi, -aval*pi
       +.25*pi, +aval*pi
       +.75*pi, +aval*pi
       -.75*pi, +aval*pi
       -.25*pi, +aval*pi
        ] ;

    mesh.point.coord = ...
        S2toR3(geom.radii,apos);

    mesh.point.coord(:,4) = -1 ;            % fix "corners"

%-------------------------------- setup icosahedron topology
    mesh.quad4.index = [
        1, 2, 3, 4, 0
        1, 2, 6, 5, 0
        2, 3, 7, 6, 0
        3, 4, 8, 7, 0
        4, 1, 5, 8, 0
        5, 6, 7, 8, 0 ] ;

    if (nlev <= +0) return, end ;

    opts.init_file = opts.mesh_file;

    savemsh(opts.init_file,mesh);

    mesh = refine(opts,nlev) ;

end

function [mesh] = refine (opts,nlev)

%---------------------------- call JIGSAW via inc. bisection

    opts.mesh_iter = +0;
    opts.optm_div_ = false;
    opts.optm_zip_ = false;

    for ilev = nlev : -1 : +0

        if (isfield(opts,'optm_dual'))

%---------------------------- create/write current DUAL flag
        opts.optm_dual = (ilev == +0) ;

        end

%---------------------------- call JIGSAW kernel at this lev
        mesh = jigsaw(opts) ;

        if (ilev >= +1)

%---------------------------- create/write current INIT data
        [path,name,fext] = ...
            fileparts(opts.mesh_file) ;

        if (~isempty(path))
            path = [path, '/'];
        end

        opts.init_file = ...
            [path,name,'-ITER', fext] ;

        mesh =   bisect (mesh);

        mesh =   attach (mesh);

        savemsh (opts.init_file,mesh) ;

        end

    end

end

function [mesh] = attach(mesh)
%ATTACH attach points to the underlying geometry definition.

    if (inspect(mesh,'quad4'))

    mark = mesh.quad4.index(:,1:4) ;
    mesh.point.coord(mark,end) = 2 ;

    end

    if (inspect(mesh,'edge2'))

    mark = mesh.edge2.index(:,1:2) ;
    mesh.point.coord(mark,end) = 1 ;

    end

end



