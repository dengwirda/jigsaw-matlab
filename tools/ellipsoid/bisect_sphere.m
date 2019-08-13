function [mesh] = bisect_sphere(opts,nlev)
%BISECT-SPHERE generate a mesh via a "multi-level" strategy.
%   MESH = BISECT-SPHERE(OPTS,NLEV) generates MESH via a 
%   sequence of bisection/refinement/optimisation operations. 
%   At each pass, the mesh from the preceeding level is 
%   bisected uniformly, a "halo" of nodes associated with 
%   "irregular" topology are removed and JIGSAW is called to 
%   perform subsequent refinement/optimisation.
%   OPTS is the standard user-defined options struct. passed 
%   to JIGSAW.
%
%   See also JIGSAW

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   09-Aug-2019
%   darren.engwirda@columbia.edu
%-----------------------------------------------------------
%

    if ( isempty(opts))
        error('JIGSAW: insufficient inputs.');
    end
    if ( isempty(nlev))
        error('JIGSAW: insufficient inputs.');
    end
    
    if (~isempty(opts) && ~isstruct (opts))
        error('JIGSAW: invalid input types.');
    end
    if (~isempty(nlev) && ~isnumeric(nlev))
        error('JIGSAW: invalid input types.');
    end
    
%---------------------------- call JIGSAW via inc. bisection
    SCAL = +2. ^ nlev;

    OPTS = opts ;

    while (nlev >= +0)
    
        if (isfield(opts,'hfun_file'))

%---------------------------- create/write current HFUN data     
       [path,name,fext] = ...
            fileparts(opts.hfun_file) ;
    
        if (~isempty(path))
            path = [path, '/']; 
        end
    
        OPTS.hfun_file = ...
            [path,name,'-ITER', fext] ;
        
       [HFUN]=loadmsh(opts.hfun_file) ;
        
        HFUN.value = HFUN.value*SCAL;

        savemsh (OPTS.hfun_file,HFUN) ;
        
        end
        
        if (isfield(opts,'hfun_hmax'))
        
%---------------------------- create/write current HMAX data 
        OPTS.hfun_hmax = ...
        opts.hfun_hmax * SCAL ;
        
        end
        
        if (isfield(opts,'hfun_hmin'))
        
%---------------------------- create/write current HMIN data 
        OPTS.hfun_hmin = ...
        opts.hfun_hmin * SCAL ;
        
        end
        
%---------------------------- create/write current MESH data 
        if (isfield(opts,'optm_qlim'))
        if (nlev >= +1)
            
        OPTS.optm_qlim = ...
        opts.optm_qlim * 0.900 ;

        else
    
        OPTS.optm_qlim = ...
        opts.optm_qlim * 1.000 ;
            
        end
        else                % no QLIM specified!
        if (nlev >= +1)
            
        OPTS.optm_qlim = .8625 ;

        else
    
        OPTS.optm_qlim = .9375 ;
            
        end
        end
        
%---------------------------- call JIGSAW kernel at this lev
        if (nlev >= +1)
        mesh = jitter (OPTS, +8, +1) ;
        else
        mesh = jitter (OPTS, +2, +1) ;
        end
        
        nlev = nlev - 1 ;
        SCAL = SCAL / 2.;
        
        if (nlev >= +0)           
        if (isfield(opts,'init_file'))

%---------------------------- create/write current INIT data         
       [path,name,fext] = ...
            fileparts(opts.init_file) ;
  
        if (~isempty(path))
            path = [path, '/']; 
        end
  
        OPTS.init_file = ...
            [path,name,'-ITER', fext] ;
        
        mesh =   bisect (mesh);
 
        mesh =   attach (mesh);
        
        savemsh (OPTS.init_file,mesh) ;
        
        else
        
%---------------------------- create/write current INIT data 
        [path,name,fext] = ...
            fileparts(opts.mesh_file) ;
    
        if (~isempty(path))
            path = [path, '/']; 
        end
    
        OPTS.init_file = ...
            [path,name,'-ITER', fext] ;
        
        mesh =   bisect (mesh);

        mesh =   attach (mesh);
        
        savemsh (OPTS.init_file,mesh) ;
        
        end
        end
    
    end    
    
end

function [mesh] = attach(mesh)
%ATTACH attach points to the underlying geometry definition.

    if (inspect(mesh,'tria4'))

    mark = mesh.tria3.index(:,1:4);
    mesh.point.coord(mark,end) = 3;

    end

    if (inspect(mesh,'quad4'))

    mark = mesh.quad4.index(:,1:4);
    mesh.point.coord(mark,end) = 2;

    end

    if (inspect(mesh,'tria3'))

    mark = mesh.tria3.index(:,1:3);
    mesh.point.coord(mark,end) = 2;

    end

    if (inspect(mesh,'edge2'))

    mark = mesh.edge2.index(:,1:2);
    mesh.point.coord(mark,end) = 1;

    end

end

function [mesh] = jitter(opts,imax,ring)
%JITTER call JIGSAW iteratively, trying to improve topology.

    if (isfield(opts,'init_file'))
        mesh = ...
            loadmsh (opts.init_file) ;
    else
        mesh = [] ;
    end

    for iter = +1 : imax

        if (~isempty(mesh))
        
        keep =  ...
        true(size(mesh.point.coord, 1), 1) ;
            
%---------------------------------- setup initial conditions
       [path,name,fext] = ...
           fileparts(opts.mesh_file) ;
            
        if (~isempty(path))
            path = [path, '/'] ;
        end
       
        opts.init_file = ...
            [path,name,'-INIT',fext] ;
        
        if (inspect(mesh,'tria3'))
        
%---------------------------------- mark any irregular nodes
        vdeg = trideg2 ( ...
            mesh.point.coord(:,1:end-1), ...
                mesh.tria3.index(:,1:end-1)) ;
        
        keep(vdeg ~= +6) = false ;
        
        for iloc = +1:ring
            
        mark =~keep(mesh.tria3.index(:,1)) ...
             |~keep(mesh.tria3.index(:,2)) ...
             |~keep(mesh.tria3.index(:,3)) ;
        
        mark = ...
        unique(mesh.tria3.index(mark,1:3)) ;
    
        keep =  ...
        true(size(mesh.point.coord, 1), 1) ;
        keep(mark) = false;
        
        if (inspect(mesh,'edge2'))
       
        keep(mesh.edge2.index(:,1:2)) = true ;
            
        end
        
        end
        
        end
    
%---------------------------------- keep nodes far from seam
        init.mshID = 'euclidean-mesh';
        init.point.coord = ...
            mesh.point.coord(keep,:) ;
        
        savemsh(opts.init_file,init) ;
        
        end

%---------------------------------- call JIGSAW with new ICs
        mesh = jigsaw(opts) ;
    
    end
    
end


