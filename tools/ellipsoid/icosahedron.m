function [mesh] = icosahedron(opts,nlev)
%ICOSAHEDRON an Nth-level icosahedral mesh of the ellipsoid
%defined by GEOM.RADII.
%
%   See also JIGSAW
%

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   09-Jul-2020
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

%-------------------------------- setup icosahedron geometry
    la = atan(+1.0 / 2.0);
    lo = +1.0 / 5.0 * pi ;

    mesh.mshID =  'euclidean-mesh';
    apos = [
       +.00*pi, -.50*pi
       +.00*pi, +.50*pi
       +0.0*lo, +1.0*la
       +1.0*lo, -1.0*la
       +2.0*lo, +1.0*la
       +3.0*lo, -1.0*la
       +4.0*lo, +1.0*la
       +5.0*lo, -1.0*la
       +6.0*lo, +1.0*la
       +7.0*lo, -1.0*la
       +8.0*lo, +1.0*la
       +9.0*lo, -1.0*la
        ] ;

    mesh.point.coord = ...
        S2toR3(geom.radii,apos);

    mesh.point.coord(:,4) = -1 ;            % fix "corners"

%-------------------------------- setup icosahedron topology
    mesh.tria3.index = [
        1,  4,  6,  0
        1,  6,  8,  0
        1,  8, 10,  0
        1, 10, 12,  0
        1, 12,  4,  0
        2,  3,  5,  0
        2,  5,  7,  0
        2,  7,  9,  0
        2,  9, 11,  0
        2, 11,  3,  0
        4,  3,  5,  0
        6,  5,  7,  0
        8,  7,  9,  0
       10,  9, 11,  0
       12, 11,  3,  0
        5,  4,  6,  0
        7,  6,  8,  0
        9,  8, 10,  0
       11, 10, 12,  0
        3, 12,  4,  0 ] ;

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

    if (inspect(mesh,'tria3'))

    mark = mesh.tria3.index(:,1:3) ;
    mesh.point.coord(mark,end) = 2 ;

    end

    if (inspect(mesh,'edge2'))

    mark = mesh.edge2.index(:,1:2) ;
    mesh.point.coord(mark,end) = 1 ;

    end

end


