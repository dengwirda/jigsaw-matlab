function [mesh] = jitter(opts,imax,ibad)
%JITTER call JIGSAW iteratively, trying to improve topology.
%
%   See also JIGSAW

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   12-Feb-2020
%   darren.engwirda@columbia.edu
%-----------------------------------------------------------
%

    mesh = []; OPTS = opts; done = false ;

    if (isfield(opts,'init_file'))

%---------------------------------- load IC's if they exist!
        mesh = loadmsh(opts.init_file);

    end

    for iter = +1 : imax

        if (~isempty(mesh))

        keep = ...
        true(size(mesh.point.coord, 1), 1) ;

%---------------------------------- setup initial conditions
       [path,name,fext] = ...
           fileparts(opts.mesh_file) ;

        if (~isempty(path))
            path = [path, '/'] ;
        end

        OPTS.init_file = ...
            [path,name,'-INIT',fext] ;

        if (inspect(mesh,'tria3'))

%---------------------------------- mark any irregular nodes

        vdeg = trideg2 ( ...
            mesh.point.coord(:,1:end-1), ...
                mesh.tria3.index(:,1:end-1)) ;

        ierr = abs(vdeg - 6) ;    % error wrt. topol. degree

        ierr(vdeg > 6) = ierr(vdeg > 6) * +2 ;

        M = sum(ierr( ...
        mesh.tria3.index(:,1:3)), 2) >= ibad ;

        keep(mesh.tria3.index(M,1:3)) = false;

        end

        if (inspect(mesh,'edge2'))

        keep(mesh.edge2.index(:,1:2)) = true ;

        end

        if (sum(double(keep)) < 8)

%---------------------------------- don't delete everything!
        keep = true (size(keep)) ;

        end

%---------------------------------- keep nodes far from seam
        init.mshID = 'euclidean-mesh';
        init.point.coord = ...
            mesh.point.coord(keep,:) ;

        done = all(keep);

        savemsh(OPTS.init_file,init) ;

        end

%---------------------------------- call JIGSAW with new ICs
        mesh = jigsaw(OPTS) ;

        if (done), break; end

    end

end



