function [mesh] = bisect_sphere(opts,nlev)
%BISECT-SPHERE generate a grid via incremental bisection.
%   MESH = BISECT-SPHERE(OPTS,NLEV) generates MESH via
%   a sequence of NLEV bisection/optimisation operations.
%   OPTS is the standard user-options structure passed 
%   to JIGSAW.
%
%   See also JIGSAW

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   06-Aug-2019
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
    
    GEOM = loadmsh  (opts.geom_file) ;
    
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
        mesh = jitter (OPTS, +8) ;
        else
        mesh = jitter (OPTS, +2) ;
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
  
        OPTS.mesh_iter = +0 ;
        OPTS.init_file = ...
            [path,name,'-ITER', fext] ;
        
        mesh =   bisect      (mesh) ;
 
        mesh =   attach (GEOM,mesh) ;
        
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
        
        mesh =   bisect      (mesh) ;
        
        mesh =   attach (GEOM,mesh) ;
        
        savemsh (OPTS.init_file,mesh) ;
        
        end
        end
    
    end    
    
end

function [mesh] = attach(geom,mesh)
%ATTACH attach points to the surface of spheroidal geometry.

    xrad = mesh.point.coord(:,1) .^ 2 ...
         + mesh.point.coord(:,2) .^ 2 ...
         + mesh.point.coord(:,3) .^ 2 ;
    xrad = max(sqrt(xrad),eps) ;
    
    xlat = asin (mesh.point.coord(:,3)./xrad);
    xlon = atan2(mesh.point.coord(:,2), ...
                 mesh.point.coord(:,1)) ;

    mesh.point.coord(:,1) = ...
        geom.radii(1) .* cos(xlon).*cos(xlat);
    mesh.point.coord(:,2) = ...
        geom.radii(2) .* sin(xlon).*cos(xlat);
    mesh.point.coord(:,3) = ...
        geom.radii(3) .* sin(xlat) ;

end



