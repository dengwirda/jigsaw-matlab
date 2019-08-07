function [mesh] = jitter(opts,imax)
%JITTER call JIGSAW iteratively, trying to improve the regu-
%larity of the mesh topology.
%
%   MESH = JITTER(OPTS,ITER);
%
%   Call the JIGSAW mesh generator using the config. options 
%   specified in the OPTS structure. See the SAVEMSH/LOADMSH 
%   routines for a description of the MESH output structure.
%
%   OPTS is a set of user-defined config options. See JIGSAW
%   for details.
%
%   ITER is the number of iterative calls to JIGSAW. At each 
%   pass the mesh is initialised using only "regular-degree"
%   nodes from the previous iteration. 
%
%   See also JIGSAW
%

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   06-Aug-2019
%   darren.engwirda@columbia.edu
%-----------------------------------------------------------
%

    if (isfield(opts,'init_file'))
        mesh = ...
            loadmsh (opts.init_file) ;
    else
        mesh = [] ;
    end

    for iter = +1 : imax

        if (~isempty(mesh))
        
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
        
        mark = vdeg ~= +6 ;
        
        mark = mark(mesh.tria3.index(:,1)) ...
             | mark(mesh.tria3.index(:,2)) ...
             | mark(mesh.tria3.index(:,3)) ;
        
        mark = ...
        unique(mesh.tria3.index(mark,1:3)) ;
    
        keep =  ...
        true(size(mesh.point.coord, 1), 1) ;
        keep(mark) = false;
    
        if (inspect(mesh,'edge2'))
       
        keep(mesh.edge2.index(:,1:2)) = true ;
            
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



