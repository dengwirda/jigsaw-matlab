function [mesh] = tetris(opts,nlev)
%TETRIS generate a mesh using a "multi-level" strategy.
%   MESH = TETRIS(OPTS,NLEV) generates MESH using a sequence 
%   of bisection/refinement/optimisation operations. At each 
%   pass, the mesh from the preceeding level is bisected 
%   uniformly, a "halo" of nodes associated with "irregular" 
%   topology is removed and JIGSAW is called to perform 
%   subsequent refinement/optimisation.
%   OPTS is the standard user-defined options struct. passed 
%   to JIGSAW.
%
%   See also JIGSAW

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   30-Aug-2019
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
 
        if (isfield(opts,'optm_qlim'))

%---------------------------- create/write current QLIM data            
        FACT = max(0.50, ...
            1.00 - sqrt(nlev) * 0.10);

        OPTS.optm_qlim = ...
        opts.optm_qlim * FACT ;

        else                % no QLIM specified => defaults!

        FACT = max(0.50, ...
            1.00 - sqrt(nlev) * 0.10);

        OPTS.optm_qlim = ...
                +.9375 * FACT ;
            
        end
        
        if (isfield(opts,'optm_qtol'))

%---------------------------- create/write current QTOL data

        OPTS.optm_qtol = ...
        opts.optm_qtol *  (nlev + 1) ;

        else                % no QTOL specified => defaults!

        OPTS.optm_qtol = ...
            +1.00E-004 *  (nlev + 1) ;

        end

        if (nlev >= +1)

%---------------------------- call JIGSAW kernel at this lev
        mesh = jitter ( ...
            OPTS, +2^(nlev + 1), +1) ;
        
        else

        mesh = jitter ( ...
            OPTS, +2^(nlev + 1), +2) ;

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

    if (inspect(mesh,'tria3'))

    mark = mesh.tria3.index(:,1:3);
    mesh.point.coord(mark,end) = 2;

    end

    if (inspect(mesh,'edge2'))

    mark = mesh.edge2.index(:,1:2);
    mesh.point.coord(mark,end) = 1;

    end

end



