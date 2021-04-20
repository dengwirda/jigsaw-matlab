function [mesh] = jitter(opts,imax,ibad)
%JITTER call JIGSAW iteratively, trying to improve topology.
%
%   See also JIGSAW

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   16-Apr-2021
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    mesh = []; OPTS = opts; done = false ;

    if (isfield(opts,'init_file'))

%---------------------------------- load IC's if they exist!
        mesh = loadmsh(opts.init_file);

    end

    next = mesh ; best = metric (mesh);

    for iter = +1 : imax

        if (~isempty(next))

        keep = ...
        true(size(next.point.coord, 1), 1) ;

%---------------------------------- setup initial conditions
       [path,name,fext] = ...
           fileparts(opts.mesh_file) ;

        if (~isempty(path))
            path = [path, '/'] ;
        end

        OPTS.init_file = ...
            [path,name,'-INIT',fext] ;

        if (inspect(next,'tria3'))

%---------------------------------- mark any irregular nodes

        vdeg = trideg2 ( ...
            next.point.coord(:,1:end-1), ...
                next.tria3.index(:,1:end-1)) ;

        ierr = abs(vdeg - 6) ;    % error wrt. topol. degree

        ierr(vdeg > 6) = ierr(vdeg > 6) * +2 ;

        M = sum(ierr( ...
        next.tria3.index(:,1:3)), 2) >= ibad ;

        keep(next.tria3.index(M,1:3)) = false;

        end

        if (inspect(next,'edge2'))

        keep(next.edge2.index(:,1:2)) = false;

        end

        if (sum(double(keep)) < 8)

%---------------------------------- don't delete everything!
        keep = true (size(keep)) ;

        end

%---------------------------------- keep nodes far from seam
        init.mshID = 'euclidean-mesh';
        init.point.coord = ...
            next.point.coord(keep,:) ;

        done = all(keep);

        savemsh(OPTS.init_file,init) ;

        end

%---------------------------------- call JIGSAW with new ICs
        next = jigsaw(OPTS) ;

        cost = metric(next) ;

        if (cost > best)

%---------------------------------- keep "best" mesh so far!
            mesh = next;
            best = cost;

        end

        if (done), break; end

    end

end

function [cnrm] = metric(mesh)
%METRIC assemble a combined "cosst" metric for a given mesh.

    cost = [] ; cnrm = +0.0 ;

    if (isempty(mesh)), return ; end

    if (inspect(mesh,'tria3'))
%--------------------------------------- append TRIA3 scores
        COST = triscr2( ...
            mesh.point.coord(:,1:end-1), ...
            mesh.tria3.index(:,1:end-1)) ;

        cost = [cost; COST] ;
    end

    if (inspect(mesh,'tria4'))
%--------------------------------------- append TRIA4 scores
        COST = triscr3( ...
            mesh.point.coord(:,1:end-1), ...
            mesh.tria4.index(:,1:end-1)) ;

        cost = [cost; COST] ;
    end

    if (isempty(cost)), return ; end

    norm = sum ((+1.0 ./ cost) .^ 3) ;

    cnrm = ...
    nthroot(length(cost) ./ norm, 3) ;

end



