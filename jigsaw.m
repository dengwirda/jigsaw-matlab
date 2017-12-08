function [varargout] = jigsaw(opts)
%JIGSAW a MATLAB interface to the JIGSAW mesh generator.
%
%   MESH = JIGSAW(OPTS);
%
%   Call the JIGSAW mesh generator using the configuration 
%   options specified in the OPTS structure. See SAVEMSH //
%   LOADMSH for a description of the MESH output structure.
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
%
%   OPTIONAL fields (OPTM):
%   ----------------------
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
%   OPTS.OPTM_QLIM - {default=0.9250} threshold on mesh cost
%       function above which gradient-based optimisation is
%       attempted.
%
%   OPTS.OPTM_ZIP_ - {default= true} allow for "merge" oper-
%       ations on sub-faces.
%
%   OPTS.OPTM_DIV_ - {default= true} allow for "split" oper-
%       ations on sub-faces.
%
%   OPTS.OPTM_TRIA - {default= true} allow for optimisation
%       of TRIA grid geometry.
%
%   OPTS.OPTM_DUAL - {default=false} allow for optimisation
%       of DUAL grid geometry.
%
%
%   OPTIONAL fields (MISC):
%   ----------------------
%
%   OPTS.VERBOSITY - {default=0} verbosity of log-file gene-
%       rated by JIGSAW. Set VERBOSITY >= 1 for more output.
%
%   See also LOADMSH, SAVEMSH
%

%   JIGSAW is a "restricted" Delaunay-refinement algorithm 
%   for 2- and 3-dimensional mesh generation. See the follo-
%   wing for additional details:
%
% * D. Engwirda, (2014): "Locally-optimal Delaunay-refineme-
%   nt and optimisation-based mesh generation", Ph.D. Thesis 
%   School of Mathematics and Statistics, Univ. of Sydney.
%   http://hdl.handle.net/2123/13148
%
% * D. Engwirda & D. Ivers, (2016): "Off-centre Steiner poi-
%   nts for Delaunay-refinement on curved surfaces", Comput-
%   er-Aided Design, 72, 157--171.
%   http://dx.doi.org/10.1016/j.cad.2015.10.007
%
% * D. Engwirda, (2016): "Voronoi-based Point-placement for 
%   Three-dimensional Delaunay-refinement", Proceedngs of 
%   the 24th International Meshing Roundtable, Procedia Eng-
%   ineering, 124, 330--342.
%   http://dx.doi.org/10.1016/j.proeng.2015.10.143
%
% * D. Engwirda, (2016): "Conforming Restricted Delaunay 
%   Mesh Generation for Piecewise Smooth Complexes", Procee-
%   dngs of the 25th International Meshing Roundtable, Proc-
%   edia Engineering, 163, 84--96.
%   https://doi.org/10.1016/j.proeng.2016.11.024
%
% * D. Engwirda, (2017): "JIGSAW-GEO (1.0): locally orthogo-
%   nal staggered unstructured grid generation for general 
%   circulation modelling on the sphere, Geosci. Model Dev., 
%   10, 2117-2140, https://doi.org/10.5194/gmd-10-2117-2017
%

%-----------------------------------------------------------
%   JIGSAW-0.9.5.x
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   03-Dec-2017
%   darren.engwirda@columbia.edu
%-----------------------------------------------------------
%

    jexename = '';

    if ( isempty(opts))
        error('JIGSAW: insufficient inputs.');
    end
    
    if (~isempty(opts) && ~isstruct(opts))
        error('JIGSAW: invalid input types.');
    end
        
    makejig(opts.jcfg_file,opts);
    
    filename = mfilename('fullpath');
    filepath = fileparts( filename );

%---------------------------------- default to _debug binary
    if (strcmp(jexename,''))
    if (ispc())
        jexename = [filepath, ...
            '\jigsaw\bin\WIN-64\jigsaw64d.exe'];
    elseif (ismac ())
        jexename = [filepath, ...
            '/jigsaw/bin/MAC-64/jigsaw64d'];
    elseif (isunix())
        jexename = [filepath, ...
            '/jigsaw/bin/LNX-64/jigsaw64d'];
    end
    end
    
    if (exist(jexename,'file')~=2), jexename=''; end
    
%---------------------------------- switch to release binary
    if (strcmp(jexename,''))
    if (ispc())
        jexename = [filepath, ...
            '\jigsaw\bin\WIN-64\jigsaw64r.exe'];
    elseif (ismac ())
        jexename = [filepath, ...
            '/jigsaw/bin/MAC-64/jigsaw64r'];
    elseif (isunix())
        jexename = [filepath, ...
            '/jigsaw/bin/LNX-64/jigsaw64r'];
    end
    end
  
    if (exist(jexename,'file')~=2), jexename=''; end
  
%---------------------------- call JIGSAW and capture stdout
    if (exist(jexename,'file')==2)
 
   [status, result] = system( ...
        [jexename,' ',opts.jcfg_file], '-echo');
   
%---------------------------- OCTAVE doesn't handle '-echo'!
    if (exist('OCTAVE_VERSION', 'builtin') > 0)
        fprintf(1, '%s', result) ;
    end
    
    else
    error('JIGSAW: executable not found.') ;
    end

    if (nargout == +1)
%---------------------------- read mesh if output requested!
    varargout{1} = loadmsh(opts.mesh_file) ;
    
    end
    
end

function makejig(name,opts)
%MAKEJIG make *.JIG configuration file for JIGSAW.

   [path,file,fext] = fileparts(name) ;

    if(~strcmp(lower(fext),'.jig'))
        error('Invalid file name');
    end

    try
   
    ffid = fopen(name, 'w' ) ;
   
    if (exist('OCTAVE_VERSION','builtin')  > 0)
    fprintf(ffid, ...
    '# %s.jig config. file; created by JIGSAW''s OCTAVE interface\n',file);
    else
    fprintf(ffid, ...
    '# %s.jig config. file; created by JIGSAW''s MATLAB interface\n',file);
    end
    
    data = fieldnames (opts) ;
    data = sort(data) ;
    
    for ii = +1:length(data) 
        
    switch (lower(data{ii})) 
    %------------------------------------------ MISC options
        case 'verbosity'
        pushints(ffid,opts.verbosity,'VERBOSITY');
    
        case 'jcfg_file' ;
        
    %------------------------------------------ GEOM options
        case 'geom_file'
        pushchar(ffid,opts.geom_file,'GEOM_FILE');
        
        case 'geom_seed'
        pushints(ffid,opts.geom_seed,'GEOM_SEED');
        
        case 'geom_feat'
        pushbool(ffid,opts.geom_feat,'GEOM_FEAT');
        
        case 'geom_phi1'
        pushreal(ffid,opts.geom_phi1,'GEOM_PHI1');
        case 'geom_phi2'
        pushreal(ffid,opts.geom_phi2,'GEOM_PHI2');
        
        case 'geom_eta1'
        pushreal(ffid,opts.geom_eta1,'GEOM_ETA1');
        case 'geom_eta2'
        pushreal(ffid,opts.geom_eta2,'GEOM_ETA2');
    
    %------------------------------------------ HFUN options    
        case 'hfun_file'
        pushchar(ffid,opts.hfun_file,'HFUN_FILE');
        
        case 'hfun_scal'
        pushchar(ffid,opts.hfun_scal,'HFUN_SCAL');
        
        case 'hfun_hmax'
        pushreal(ffid,opts.hfun_hmax,'HFUN_HMAX');
        case 'hfun_hmin'
        pushreal(ffid,opts.hfun_hmin,'HFUN_HMIN');
        
    %------------------------------------------ MESH options
        case 'mesh_file'
        pushchar(ffid,opts.mesh_file,'MESH_FILE');
        
        case 'mesh_kern'
        pushchar(ffid,opts.mesh_kern,'MESH_KERN');
        
        case 'mesh_iter'
        pushints(ffid,opts.mesh_iter,'MESH_ITER');
        
        case 'mesh_dims'
        pushints(ffid,opts.mesh_dims,'MESH_DIMS');
        
        case 'mesh_top1'
        pushbool(ffid,opts.mesh_top1,'MESH_TOP1');
        case 'mesh_top2'
        pushbool(ffid,opts.mesh_top2,'MESH_TOP2');
        
        case 'mesh_siz1'
        pushreal(ffid,opts.mesh_siz1,'MESH_SIZ1');
        case 'mesh_siz2'
        pushreal(ffid,opts.mesh_siz2,'MESH_SIZ2');
        case 'mesh_siz3'
        pushreal(ffid,opts.mesh_siz3,'MESH_SIZ3');
        
        case 'mesh_eps1'
        pushreal(ffid,opts.mesh_eps1,'MESH_EPS1');
        case 'mesh_eps2'
        pushreal(ffid,opts.mesh_eps2,'MESH_EPS2');
        
        case 'mesh_rad2'
        pushreal(ffid,opts.mesh_rad2,'MESH_RAD2');
        case 'mesh_rad3'
        pushreal(ffid,opts.mesh_rad3,'MESH_RAD3');
        
        case 'mesh_off2'
        pushreal(ffid,opts.mesh_off2,'MESH_OFF2');
        case 'mesh_off3'
        pushreal(ffid,opts.mesh_off3,'MESH_OFF3');
        
        case 'mesh_snk2'
        pushreal(ffid,opts.mesh_snk2,'MESH_SNK2');
        case 'mesh_snk3'
        pushreal(ffid,opts.mesh_snk3,'MESH_SNK3');
        
        case 'mesh_vol3'
        pushreal(ffid,opts.mesh_vol3,'MESH_VOL3');
        
    %------------------------------------------ OPTM options
        case 'optm_iter'
        pushints(ffid,opts.optm_iter,'OPTM_ITER');
        
        case 'optm_qtol'
        pushreal(ffid,opts.optm_qtol,'OPTM_QTOL');
        case 'optm_qlim'
        pushreal(ffid,opts.optm_qlim,'OPTM_QLIM');
        
        case 'optm_zip_'
        pushbool(ffid,opts.optm_zip_,'OPTM_ZIP_');
        case 'optm_div_'
        pushbool(ffid,opts.optm_div_,'OPTM_DIV_');
        case 'optm_tria'
        pushbool(ffid,opts.optm_tria,'OPTM_TRIA');
        case 'optm_dual'
        pushbool(ffid,opts.optm_dual,'OPTM_DUAL');

    %------------------------------------------ abandoned OP
        case{'hfun_kern', ...
             'hfun_grad'}
        warning( ...
        ['Deprecated!!: OPTS.', upper(data{ii})]);

        otherwise
        error  ( ...
        ['Invalid data: OPTS.', upper(data{ii})]);
    end
        
    end

    fclose(ffid);

    catch   err
    
    if (ffid>-1)
    fclose(ffid);
    end
    
    rethrow(err);
    
    end
    
end

function pushbool(ffid,data,name)
%PUSHBOOL push "bool" param-value onto JCFG file for JIGSAW.

    if (islogical(data))
        if (data)
            pushchar(ffid,'true' ,name);
        else
            pushchar(ffid,'false',name);
        end
    else
        error(['Incorrect type: OPTS.',upper(name)]) ;
    end

end

function pushchar(ffid,data,name)
%PUSHCHAR push "char" param-value onto JCFG file for JIGSAW.

    if (ischar(data))
        fprintf(ffid,['  ',name,'=%s\n'],data);
    else
        error(['Incorrect type: OPTS.',upper(name)]) ;
    end

end

function pushints(ffid,data,name)
%PUSHINTS push "ints" param-value onto JCFG file for JIGSAW.

    if (isnumeric(data))
        if (numel(data)==+1)
        fprintf(ffid,['  ',name,'=%i\n'],data);
        else
        error(['Incorrect dims: OPTS.',upper(name)]) ;
        end
    else
        error(['Incorrect type: OPTS.',upper(name)]) ;
    end

end

function pushreal(ffid,data,name)
%PUSHREAL push "real" param-value onto JCFG file for JIGSAW.

    if (isnumeric(data))
        if (numel(data)==+1)
        fprintf(ffid,['  ',name,'=%1.16g\n'],data);
        else
        error(['Incorrect dims: OPTS.',upper(name)]) ;
        end
    else
        error(['Incorrect type: OPTS.',upper(name)]) ;
    end
    
end



