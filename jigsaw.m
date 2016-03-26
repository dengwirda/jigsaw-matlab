function [varargout] = jigsaw(opts)
%JIGSAW interface to the JIGSAW mesh generator.
%
%   MESH = JIGSAW(OPTS);
%
%   Call the JIGSAW mesh generator using the configuration options spec-
%   ified in the OPTS structure. See READMSH/MAKEMSH for a description of 
%   the MESH output structure.
%
%   OPTS is a user-defined set of meshing options:
%
%   REQUIRED fields:
%   ---------------
%
%   OPTS.GEOM_FILE - 'GEOMNAME.MSH', a string containing the name of the 
%       geometry file (is required at input). See MAKEMSH for additional
%       details regarding the creation of *.MSH files.
%
%   OPTS.JCFG_FILE - 'JCFGNAME.JIG', a string containing the name of the 
%       cofig. file (will be created on output).
%
%   OPTS.MESH_FILE - 'MESHNAME.MSH', a string containing the name of the 
%       output file (will be created on output).
%
%   OPTIONAL fields (GEOM):
%   ----------------------
%
%   OPTS.GEOM_SEED - {default=8} number of "seed" vertices used to init-
%       ialise mesh generation.
%
%   OPTS.GEOM_FEAT - {default=false} attempt to auto-detect sharp "feat-
%       ures" in the input geometry. Features can be adjacent to 1-dim.
%       entities, (i.e. geometry "edges") and/or 2-dim. entities, (i.e.
%       geometry "faces") based on both geometrical and/or topological
%       constraints. Geometrically, features are located between any ne-
%       ighbouring entities that subtend angles less than GEOM_ETAX deg-
%       rees, where X is the (topological) dimension of the feature. To-
%       pologically, features are located at the apex of any non-manifo-
%       ld connections.
%
%   OPTS.GEOM_ETA1 - {default=45deg} 1-dim. feature-angle, features are 
%       located between any neighbouring "edges" that subtend angles le-
%       ss than GEOM_ETA1 degrees.
%
%   OPTS.GEOM_ETA2 - {default=45deg} 2-dim. feature angle, features are 
%       located between any neighbouring "faces" that subtend angles le-
%       ss than GEOM_ETA2 degrees.
%
%   OPTIONAL fields (HFUN):
%   ----------------------
%
%   OPTS.HFUN_KERN - {default='constant'} mesh-size kernal, choice betw-
%       een a constant size-function (KERN='constant') and a Delaunay-
%       based medial-axis method (KERN='delaunay') that attempts to aut-
%       omatically generate geometry-adaptive sizing data.
%
%   OPTS.HFUN_SCAL - {default='relative'} scaling type for mesh-size fu-
%       ction. SCAL='relative' interprets mesh-size values as percentag-
%       es of the (mean) length of the axis-aligned bounding-box (AABB)
%       for the geometry. SCAL='absolute' interprets mesh-size values as
%       absolute measures.
%
%   OPTS.HFUN_HMAX - {default=0.02} max. mesh-size function value. Inte-
%       rpreted based on HFUN_SCAL setting.
%
%   OPTS.HFUN_HMIN - {default=0.00} min. mesh-size function value. Inte-
%       rpreted based on HFUN_SCAL setting.
%
%   OPTS.HFUN_GRAD - {default=0.25} max. allowable gradient in the mesh-
%       size function. 
%
%   OPTIONAL fields (MESH):
%   ----------------------
%
%   OPTS.MESH_DIMS - {default=3} number of "topological" dimensions to 
%       mesh. DIMS=K meshes K-dimensional features, irrespective of the
%       number of spatial dimensions of the problem (i.e. if the geomet-
%       ry is 3-dimensional and DIMS=2 a surface mesh will be produced).
%
%   OPTS.MESH_KERN - {default='delfront'} meshing kernal, choice of the
%       standard Delaunay-refinement algorithm (KERN='delaunay') or the 
%       Frontal-Delaunay method (KERN='delfront').
%
%   OPTS.MESH_ITER - {default=+INF} max. number of mesh refinement iter-
%       ations. Set ITER=N to see progress after N iterations. 
%
%   OPTS.MESH_TOP1 - {default=false} enforce 1-dim. topological constra-
%       ints. 1-dim. edges are refined until all embedded nodes are "lo-
%       cally 1-manifold", i.e. nodes are either centred at topological
%       "features", or lie on 1-manifold complexes.
%
%   OPTS.MESH_TOP2 - {default=false} enforce 2-dim. topological constra-
%       ints. 2-dim. trias are refined until all embedded nodes are "lo-
%       cally 2-manifold", i.e. nodes are either centred at topological
%       "features", or lie on 2-manifold complexes.
%
%   OPTS.MESH_RAD2 - {default=1.05} max. radius-edge ratio for 2-tria 
%       elements. 2-trias are refined until the ratio of the element ci-
%       rcumradius to min. edge length is less-than MESH_RAD2.
%
%   OPTS.MESH_RAD3 - {default=2.05} max. radius-edge ratio for 3-tria 
%       elements. 3-trias are refined until the ratio of the element ci-
%       rcumradius to min. edge length is less-than MESH_RAD3.
%
%   OPTS.MESH_EPS1 - {default=0.33} max. surface-discretisation error
%       multiplier for 1-edge elements. 1-edge elements are refined unt-
%       il the surface-disc. error is less-than MESH_EPS1 * HFUN(X).
%
%   OPTS.MESH_EPS2 - {default=0.33} max. surface-discretisation error 
%       multiplier for 2-tria elements. 2-tria elements are refined unt-
%       il the surface-disc. error is less-than MESH_EPS2 * HFUN(X).
%
%   OPTS.MESH_VOL3 - {default=0.00} min. volume-length ratio for 3-tria
%       elements. 3-tria elements are refined until the volume-length 
%       ratio exceeds MESH_VOL3. Can be used to supress "sliver" elemen-
%       ts.
%
%   OPTIONAL FIELDS (MISC):
%   ----------------------
%
%   OPTS.VERBOSITY - {default=0} verbosity of log-file output generated
%       by JIGSAW. Set VERBOSITY>=1 to display additional output.
%
%   See also READMSH, MAKEMSH, DRAWMESH
%

%   JIGSAW is a "restricted" Delaunay-refinement algorithm for 2- and 3-
%   dimensional mesh generation, based (primarily) on ideas described in 
%   the following references:
%
%   [1] Darren Engwirda and David Ivers, Off-centre Steiner-points for
%       Delaunay-refinement on curved surfaces. Computer Aided Design,
%       Volume 72, March 2016, Pages 157-171, ISSN 0010-4485, 
%       http://dx.doi.org/10.1016/j.cad.2015.10.007
%
%   [2] Darren Engwirda, Voronoi-based Point-placement for Three-dimens-
%       ional Delaunay-refinement, Proceedngs of the 24th International
%       Meshing Roundtable, Procedia Engineering, Volume 124, 2015, Page 
%       330-342, ISSN 1877-7058, 
%       http://dx.doi.org/10.1016/j.proeng.2015.10.143
%
%   [3] Darren Engwirda, Locally-optimal Delaunay-refinement and optimi-
%       sation-based mesh generation. Ph.D. Thesis, School of Mathemati-
%       cs and Statistics, University of Sydney, 2015.
%       http://hdl.handle.net/2123/13148
%
%   A number of other (important!) references are cited in the articles
%   above. See the full-text for additional information.
%

%---------------------------------------------------------------------
%   JIGSAW-0.9.2.x
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   26-Mar-2016
%   d_engwirda@outlook.com
%---------------------------------------------------------------------
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

%-- default to _debug binary
    if (strcmp(jexename,''))
    switch (computer)
       %case {'GLNX86',i586-pc-linux-gnu}
       %jexename = [filepath,'/jigsaw/bin/LNX-32/jigsaw32d'];
        case {'GLNXA64','x86_64-pc-linux-gnu'}
        jexename = [filepath,'/jigsaw/bin/LNX-64/jigsaw64d'];
       %case 'PCWIN'  
       %jexename = [filepath,'\jigsaw\bin\WIN-32\jigsaw32d.exe'];
        case 'PCWIN64'
        jexename = [filepath,'\jigsaw\bin\WIN-64\jigsaw64d.exe'];
       %case 'MACI64'
       %jexename = [filepath,'/jigsaw/bin/MAC-64/jigsaw64d'];
        
        otherwise
        error('JIGSAW: unsupported platform');  
    end
    end
    
    if (exist(jexename,'file') ~= +2), jexename = '' ; end
    
%-- switch to release binary
    if (strcmp(jexename,''))
    switch (computer)
       %case {'GLNX86',i586-pc-linux-gnu}
       %jexename = [filepath,'/jigsaw/bin/LNX-32/jigsaw32r'];
        case {'GLNXA64','x86_64-pc-linux-gnu'}
        jexename = [filepath,'/jigsaw/bin/LNX-64/jigsaw64r'];
       %case 'PCWIN'  
       %jexename = [filepath,'\jigsaw\bin\WIN-32\jigsaw32r.exe'];
        case 'PCWIN64'
        jexename = [filepath,'\jigsaw\bin\WIN-64\jigsaw64r.exe'];
       %case 'MACI64'
       %jexename = [filepath,'/jigsaw/bin/MAC-64/jigsaw64r'];
        
        otherwise
        error('JIGSAW: unsupported platform');
    end
    end
    
%-- call JIGSAW and capture stdout
    if (exist(jexename,'file') == +2)
   [status,result] = system([jexename,' ',opts.jcfg_file]);
    else
    error('JIGSAW: executable not found.') ;
    end

    disp ( result) ;
    
    if (nargout == +1)
    varargout(1) = {readmsh(opts.mesh_file)} ;
    end
    
end

function makejig(name,opts)
%MAKEJIG make *.JIG file for JIGSAW.

   [path,file,fext] = fileparts(name) ;

    if(~strcmp(lower(fext),'.jig'))
        error('Invalid file name');
    end

    try
   
    ffid = fopen(name, 'w' ) ;
   
    fprintf(ffid,'# %s.jig configuration file\r\n',file);
    
    data = fieldnames (opts) ;
    data = sort(data) ;
    
    for ii = +1:length(data) 
        
    switch (lower(data{ii})) 
    %!! if some of these options are undomcumented, it's because 
    %!! they are either (i) still experimental, or (ii) intended 
    %!! for internal use only...
    %!!
        case 'verbosity'
        pushints(ffid,opts.verbosity,'verbosity',false);
    %-- FILE options
        case 'jcfg_file' ;
        case 'geom_file'
        pushchar(ffid,opts.geom_file,'geom_file');
        
        case 'mesh_file'
        pushchar(ffid,opts.mesh_file,'mesh_file');
        
        case 'size_file'
        pushchar(ffid,opts.size_file,'size_file');
        
    %-- GEOM options
        case 'geom_seed'
        pushints(ffid,opts.geom_seed,'geom_seed',false);
        
        case 'geom_feat'
        pushbool(ffid,opts.geom_feat,'geom_feat');
        
        case 'geom_phi1'
        pushreal(ffid,opts.geom_phi1,'geom_phi1',false);
        case 'geom_phi2'
        pushreal(ffid,opts.geom_phi2,'geom_phi2',false);
        
        case 'geom_eta1'
        pushreal(ffid,opts.geom_eta1,'geom_eta1',false);
        case 'geom_eta2'
        pushreal(ffid,opts.geom_eta2,'geom_eta2',false);
        
    %-- HFUN options
        case 'hfun_kern'
        pushchar(ffid,opts.hfun_kern,'hfun_kern');
        
        case 'hfun_scal'
        pushchar(ffid,opts.hfun_scal,'hfun_scal');
        
        case 'hfun_grad'
        pushreal(ffid,opts.hfun_grad,'hfun_grad',true );
        
        case 'hfun_hmax'
        pushreal(ffid,opts.hfun_hmax,'hfun_hmax',true );
        case 'hfun_hmin'
        pushreal(ffid,opts.hfun_hmin,'hfun_hmin',true );
        
    %-- MESH options
        case 'mesh_kern'
        pushchar(ffid,opts.mesh_kern,'mesh_kern');
        
        case 'mesh_iter'
        pushints(ffid,opts.mesh_iter,'mesh_iter',false);
        
        case 'mesh_dims'
        pushints(ffid,opts.mesh_dims,'mesh_dims',true );
        
        case 'mesh_top1'
        pushbool(ffid,opts.mesh_top1,'mesh_top1');
        case 'mesh_top2'
        pushbool(ffid,opts.mesh_top2,'mesh_top2');
        
        case 'mesh_siz1'
        pushreal(ffid,opts.mesh_siz1,'mesh_siz1',true );
        case 'mesh_siz2'
        pushreal(ffid,opts.mesh_siz2,'mesh_siz2',true );
        case 'mesh_siz3'
        pushreal(ffid,opts.mesh_siz3,'mesh_siz3',true );
        
        case 'mesh_eps1'
        pushreal(ffid,opts.mesh_eps1,'mesh_eps1',true );
        case 'mesh_eps2'
        pushreal(ffid,opts.mesh_eps2,'mesh_eps2',true );
        
        case 'mesh_rad2'
        pushreal(ffid,opts.mesh_rad2,'mesh_rad2',true );
        case 'mesh_rad3'
        pushreal(ffid,opts.mesh_rad3,'mesh_rad3',true );
        
        case 'mesh_off2'
        pushreal(ffid,opts.mesh_off2,'mesh_off2',true );
        case 'mesh_off3'
        pushreal(ffid,opts.mesh_off3,'mesh_off3',true );
        
        case 'mesh_snk2'
        pushreal(ffid,opts.mesh_snk2,'mesh_snk2',true );
        case 'mesh_snk3'
        pushreal(ffid,opts.mesh_snk3,'mesh_snk3',true );
        
        case 'mesh_vol3'
        pushreal(ffid,opts.mesh_vol3,'mesh_vol3',true );

        otherwise
        error(['Invalid data: OPTS.', upper(data{ii})]);
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
%PUSHBOOL push data onto JCFG file.

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
%PUSHCHAR push data onto JCFG file.

    if (ischar(data))
        fprintf(ffid,[name,'=%s\r\n'],data);
    else
        error(['Incorrect type: OPTS.',upper(name)]) ;
    end

end

function pushreal(ffid,data,name,list)
%PUSHREAL push data onto JCFG file.

    if (isnumeric(data))
    if (list)
    if (numel(data)==+1)
        fprintf(ffid,[name,'=-1;%1.16g\r\n'],data );
    else
        if (ndims(data)==+2 && size(data,2)==+2)
        fprintf(ffid,[name,'=%i;%1.16g\r\n'],data');
        else
        error(['Incorrect dims: OPTS.',upper(name)]) ;
        end
    end
    else
        if (numel(data)==+1)
        fprintf(ffid,[name,'=%1.16g\r\n'],data);
        else
        error(['Incorrect dims: OPTS.',upper(name)]) ;
        end
    end
    else
        error(['Incorrect type: OPTS.',upper(name)]) ;
    end
    
end

function pushints(ffid,data,name,list)
%PUSHINTS push data onto JCFG file.

    if (isnumeric(data))
    if (list)
    if (numel(data)==+1)
        fprintf(ffid,[name,'=-1;%i\r\n'],data );
    else
        if (ndims(data)==+2 && size(data,2)==+2)
        fprintf(ffid,[name,'=%i;%i\r\n'],data');
        else
        error(['Incorrect dims: OPTS.',upper(name)]) ;
        end
    end
    else
        if (numel(data)==+1)
        fprintf(ffid,[name,'=%i\r\n'],data);
        else
        error(['Incorrect dims: OPTS.',upper(name)]) ;
        end
    end
    else
        error(['Incorrect type: OPTS.',upper(name)]) ;
    end

end

