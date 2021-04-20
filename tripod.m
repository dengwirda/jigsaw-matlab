function [varargout] = tripod(opts)
%TRIPOD an interface to the JIGSAW's "restricted" Delaunay
%tessellator TRIPOD.
%
%   MESH = TRIPOD(OPTS);
%
%   Call the rDT tessellator TRIPOD using the confg. options
%   specified in the OPTS structure. See the SAVEMSH/LOADMSH
%   routines for a description of the MESH output structure.
%
%   OPTS is a user-defined set of meshing options:
%
%   REQUIRED fields:
%   ---------------
%
%   OPTS.INIT_FILE - 'INITNAME.MSH', a string containing the
%       name of the initial distribution file (is required
%       at input). See SAVEMSH for additional details regar-
%       ding the creation of *.MSH files.
%
%   OPTS.JCFG_FILE - 'JCFGNAME.JIG', a string containing the
%       name of the cofig. file (will be created on output).
%
%   OPTS.MESH_FILE - 'MESHNAME.MSH', a string containing the
%       name of the output file (will be created on output).
%
%   OPTIONAL fields (GEOM):
%   ----------------------
%
%   OPTS.GEOM_FILE - 'GEOMNAME.MSH', a string containing the
%       name of the geometry file (is required at input).
%       When a non-null geometry is passed, MESH is computed
%       as a "restricted" Delaunay tessellation, including
%       various 1-, 2- and/or 3-dimensional sub-meshes that
%       approximate the geometry definition.
%
%   OPTS.GEOM_FEAT - {default=false} attempt to auto-detect
%       "sharp-features" in the input geometry. Features can
%       lie adjacent to 1-dim. entities, (i.e. geometry
%       "edges") and/or 2-dim. entities, (i.e. geometry
%       "faces") based on both geometrical and/or topologic-
%       al constraints. Geometrically, features are located
%       between any neighbouring entities that subtend
%       angles less than GEOM_ETAX degrees, where "X" is the
%       (topological) dimension of the feature. Topological-
%       ly, features are located at the apex of any non-man-
%       ifold connections.
%
%   OPTS.GEOM_ETA1 - {default=45deg} 1-dim. feature-angle,
%       features are located between any neighbouring
%       "edges" that subtend angles less than ETA1 deg.
%
%   OPTS.GEOM_ETA2 - {default=45deg} 2-dim. feature angle,
%       features are located between any neighbouring
%       "faces" that subtend angles less than ETA2 deg.
%
%   OPTIONAL fields (MESH):
%   ----------------------
%
%   OPTS.MESH_DIMS - {default=3} number of "topological" di-
%       mensions to mesh. DIMS=K meshes K-dimensional featu-
%       res, irrespective of the number of spatial dim.'s of
%       the problem (i.e. if the geometry is 3-dimensional
%       and DIMS=2 a surface mesh will be produced).
%
%   OPTIONAL fields (MISC):
%   ----------------------
%
%   OPTS.VERBOSITY - {default=0} verbosity of log-file gene-
%       rated by JIGSAW. Set VERBOSITY >= 1 for more output.
%
%   See also LOADMSH, SAVEMSH
%

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   18-Apr-2021
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    jexename = '' ;

    if ( isempty(opts))
        error('TRIPOD: insufficient inputs!!') ;
    end

    if (~isempty(opts) && ~isstruct(opts))
        error('TRIPOD: invalid input types!!') ;
    end

    savejig(opts.jcfg_file,opts);

%---------------------------- set-up path for "local" binary
    if (strcmp(jexename,''))

    filename = ...
            mfilename('fullpath') ;
    filepath = ...
            fileparts( filename ) ;

    if (ispc())
        jexename = [filepath, ...
    '\external\jigsaw\bin\tripod.exe'];
    elseif (ismac ())
        jexename = [filepath, ...
    '/external/jigsaw/bin/tripod'];
    elseif (isunix())
        jexename = [filepath, ...
    '/external/jigsaw/bin/tripod'];
    end
    end

    if (exist(jexename,'file')~=2), jexename=''; end

%---------------------------- search machine path for binary
    if (strcmp(jexename,''))
    if (ispc())
        jexename =       'tripod.exe' ;
    elseif (ismac ())
        jexename =       'tripod' ;
    elseif (isunix())
        jexename =       'tripod' ;
    end
    end

    if (exist(jexename,'file')~=2), jexename=''; end

%---------------------------- call TRIPOD and capture stdout
    if (exist(jexename,'file')==2)

   [status, result] = system( ...
        ['"',jexename,'"',' ','"',opts.jcfg_file,'"'], ...
            '-echo') ;

%---------------------------- OCTAVE doesn't handle '-echo'!
    if (exist('OCTAVE_VERSION', 'builtin') > 0)
        fprintf(1, '%s', result) ;
    end

    else
%---------------------------- couldn't find JIGSAW's backend
        error([ ...
        'TRIPOD''s executable not found -- ', ...
        'has JIGSAW been compiled from src?', ...
        'See COMPILE for additional detail.', ...
            ] ) ;
    end

    if (nargout == +1)
%---------------------------- read mesh if output requested!
    if (status  == +0)
    varargout{1} = loadmsh (opts.mesh_file) ;
    else
    varargout{1} = [];
    end

    end

end



