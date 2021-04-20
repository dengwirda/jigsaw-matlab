function [varargout] = jigsaw(opts)
%JIGSAW an interface to the JIGSAW mesh generator.
%
%   MESH = JIGSAW(OPTS);
%
%   Call the JIGSAW mesh generator using the config. options
%   specified in the OPTS structure. See the SAVEMSH/LOADMSH
%   routines for a description of the MESH output structure.
%
%   OPTS is a user-defined set of meshing options:
%
%   REQUIRED fields:
%   ---------------
%
%   OPTS.GEOM_FILE - 'GEOMNAME.MSH', a string containing the
%       name of the geometry file (is required at input).
%       See SAVEMSH for additional details regarding the cr-
%       eation of *.MSH files.
%
%   OPTS.JCFG_FILE - 'JCFGNAME.JIG', a string containing the
%       name of the cofig. file (will be created on output).
%
%   OPTS.MESH_FILE - 'MESHNAME.MSH', a string containing the
%       name of the output file (will be created on output).
%
%   OPTIONAL fields (INIT):
%   ----------------------
%
%   OPTS.INIT_FILE - 'INITNAME.MSH', a string containing the
%       name of the initial distribution file (is required
%       at input).
%
%   OPTS.INIT_NEAR - {default = 1.E-8} relative "zip" tol.
%       applied when processing initial conditions. In cases
%       where "sharp-feature" detection is active, nodes in
%       the initial set are zipped to their nearest feature
%       node if the separation length is less than NEAR*SCAL
%       where SCAL is the max. bounding-box dimension.
%
%   OPTIONAL fields (GEOM):
%   ----------------------
%
%   OPTS.GEOM_SEED - {default=8} number of "seed" vertices
%       used to initialise mesh generation.
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
%   OPTIONAL fields (HFUN):
%   ----------------------
%
%   OPTS.HFUN_FILE - 'HFUNNAME.MSH', a string containing the
%       name of the mesh-size file (is required at input).
%       The mesh-size function is specified as a general pi-
%       ecewise linear function, defined at the vertices of
%       an unstructured triangulation. See SAVEMSH for addi-
%       tional details.
%
%   OPTS.HFUN_SCAL - {default='relative'} scaling type for
%       mesh-size fuction. HFUN_SCAL='relative' interprets
%       mesh-size values as percentages of the (mean) length
%       of the axis-aligned bounding-box (AABB) associated
%       with the geometry. HFUN_SCAL='absolute' interprets
%       mesh-size values as absolute measures.
%
%   OPTS.HFUN_HMAX - {default=0.02} max. mesh-size function
%       value. Interpreted based on SCAL setting.
%
%   OPTS.HFUN_HMIN - {default=0.00} min. mesh-size function
%       value. Interpreted based on SCAL setting.
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
%   OPTS.MESH_KERN - {default='delfront'} meshing kernal,
%       choice of the standard Delaunay-refinement algorithm
%       (KERN='delaunay') or the Frontal-Delaunay method
%       (KERN='delfront').
%
%   OPTS.MESH_ITER - {default=+INF} max. number of mesh ref-
%       inement iterations. Set ITER=N to see progress after
%       N iterations.
%
%   OPTS.MESH_TOP1 - {default=false} enforce 1-dim. topolog-
%       ical constraints. 1-dim. edges are refined until all
%       embedded nodes are "locally 1-manifold", i.e. nodes
%       are either centred at topological "features", or lie
%       on 1-manifold complexes.
%
%   OPTS.MESH_TOP2 - {default=false} enforce 2-dim. topolog-
%       ical constraints. 2-dim. trias are refined until all
%       embedded nodes are "locally 2-manifold", i.e. nodes
%       are either centred at topological "features", or lie
%       on 2-manifold complexes.
%
%   OPTS.MESH_RAD2 - {default=1.05} max. radius-edge ratio
%       for 2-tria elements. 2-trias are refined until the
%       ratio of the element circumradii to min. edge length
%       is less-than RAD2.
%
%   OPTS.MESH_RAD3 - {default=2.05} max. radius-edge ratio
%       for 3-tria elements. 3-trias are refined until the
%       ratio of the element circumradii to min. edge length
%       is less-than RAD3.
%
%   OPTS.MESH_OFF2 - {default=0.90} radius-edge ratio target
%       for insertion of "shape"-type offcentres for 2-tria
%       elements. When refining an element II, offcentres
%       are positioned to form a new "frontal" element JJ
%       that satisfies JRAD <= OFF2.
%
%   OPTS.MESH_OFF3 - {default=1.10} radius-edge ratio target
%       for insertion of "shape"-type offcentres for 3-tria
%       elements. When refining an element II, offcentres
%       are positioned to form a new "frontal" element JJ
%       that satisfies JRAD <= OFF3.
%
%   OPTS.MESH_SNK2 - {default=0.20} inflation tolerance for
%       insertion of "sink" offcentres for 2-tria elements.
%       When refining an element II, "sinks" are positioned
%       at the centre of the largest adj. circumball staisf-
%       ying |JBAL-IBAL| < SNK2 * IRAD, where IRAD is the
%       radius of the circumball, and [IBAL,JBAL] are the
%       circumball centres.
%
%   OPTS.MESH_SNK3 - {default=0.33} inflation tolerance for
%       insertion of "sink" offcentres for 3-tria elements.
%       When refining an element II, "sinks" are positioned
%       at the centre of the largest adj. circumball staisf-
%       ying |JBAL-IBAL| < SNK3 * IRAD, where IRAD is the
%       radius of the circumball, and [IBAL,JBAL] are the
%       circumball centres.
%
%   OPTS.MESH_EPS1 - {default=0.33} max. surface-discretisa-
%       tion error multiplier for 1-edge elements. 1-edge
%       elements are refined until the surface-disc. error
%       is less-than EPS1 * HFUN(X).
%
%   OPTS.MESH_EPS2 - {default=0.33} max. surface-discretisa-
%       tion error multiplier for 2-tria elements. 2-tria
%       elements are refined until the surface-disc. error
%       is less-than EPS2 * HFUN(X).
%
%   OPTS.MESH_VOL3 - {default=0.00} min. volume-length ratio
%       for 3-tria elements. 3-tria elements are refined
%       until the volume-length ratio exceeds VOL3. Can be
%       used to supress "sliver" elements.
%
%   OPTIONAL fields (OPTM):
%   ----------------------
%
%   OPTS.OPTM_KERN - {default='odt+dqdx'} mesh optimisation
%       kernel, choice of an Optimal Delaunay Tessellation
%       strategy (KERN='odt+dqdx') or a Centroidal Voronoi
%       Tessellation method (KERN='cvt+dqdx'). In both
%       cases a hybrid formulation is employed, using a
%       "blend" of the ODT/CVT updates, and gradients of a
%       "fall-back" mesh quality function Q.
%
%   OPTS.OPTM_ITER - {default=16} max. number of mesh optim-
%       isation iterations. Set ITER=N to see progress after
%       N iterations.
%
%   OPTS.OPTM_QTOL - {default=1.E-04} tolerance on mesh cost
%       function for convergence. Iteration on a given node
%       is terminated if adjacent element cost-functions are
%       improved by less than QTOL.
%
%   OPTS.OPTM_QLIM - {default=0.9375} threshold on mesh cost
%       function above which gradient-based optimisation is
%       attempted.
%
%   OPTS.OPTM_TRIA - {default= true} allow for optimisation
%       of TRIA grid geometry.
%
%   OPTS.OPTM_DUAL - {default=false} allow for optimisation
%       of DUAL grid geometry.
%
%   OPTS.OPTM_ZIP_ - {default= true} allow for "merge" oper-
%       ations on sub-face topology.
%
%   OPTS.OPTM_DIV_ - {default= true} allow for "split" oper-
%       ations on sub-face topology.
%
%   OPTIONAL fields (MISC):
%   ----------------------
%
%   OPTS.VERBOSITY - {default=0} verbosity of log-file gene-
%       rated by JIGSAW. Set VERBOSITY >= 1 for more output.
%
%   See also LOADMSH, SAVEMSH
%

%   JIGSAW is a "restricted" Delaunay-refinement and optimi-
%   sation algorithm for 2- and 3-dimensional meshes. Please
%   see the following for additional details:
%
% * D. Engwirda, (2018): "Generalised primal-dual grids for
%   unstructured co-volume schemes", J. Comput. Phys., 375
%   155--176.
%   https://doi.org/10.1016/j.jcp.2018.07.025
%
% * D. Engwirda & D. Ivers, (2016): "Off-centre Steiner poi-
%   nts for Delaunay-refinement on curved surfaces", Comput-
%   er-Aided Design, 72, 157--171.
%   https://doi.org/10.1016/j.cad.2015.10.007
%
% * D. Engwirda, (2016): "Conforming Restricted Delaunay
%   Mesh Generation for Piecewise Smooth Complexes", Proced-
%   ia Engineering, 163, 84--96.
%   https://doi.org/10.1016/j.proeng.2016.11.024
%
% * D. Engwirda, (2015): "Voronoi-based Point-placement for
%   Three-dimensional Delaunay-refinement", Procedia Engin-
%   eering, 124, 330--342.
%   https://doi.org/10.1016/j.proeng.2015.10.143
%
% * D. Engwirda, (2014): "Locally-optimal Delaunay-refineme-
%   nt and optimisation-based mesh generation", Ph.D. Thesis
%   School of Mathematics and Statistics, Univ. of Sydney.
%   https://hdl.handle.net/2123/13148
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
        error('JIGSAW: insufficient inputs!!') ;
    end

    if (~isempty(opts) && ~isstruct(opts))
        error('JIGSAW: invalid input types!!') ;
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
    '\external\jigsaw\bin\jigsaw.exe'];
    elseif (ismac ())
        jexename = [filepath, ...
    '/external/jigsaw/bin/jigsaw'];
    elseif (isunix())
        jexename = [filepath, ...
    '/external/jigsaw/bin/jigsaw'];
    end
    end

    if (exist(jexename,'file')~=2), jexename=''; end

%---------------------------- search machine path for binary
    if (strcmp(jexename,''))
    if (ispc())
        jexename =       'jigsaw.exe' ;
    elseif (ismac ())
        jexename =       'jigsaw' ;
    elseif (isunix())
        jexename =       'jigsaw' ;
    end
    end

    if (exist(jexename,'file')~=2), jexename=''; end

%---------------------------- call JIGSAW and capture stdout
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
        'JIGSAW''s executable not found -- ', ...
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



