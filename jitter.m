function [mesh] = jitter(opts,imax,ibad)
%JITTER call JIGSAW iteratively, trying to improve topology.
%
%   See also JIGSAW

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   15-Jan-2023
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    mesh = []; OPTS = opts; done = false ;

    if (isfield(opts,'init_file'))

%---------------------------------- load IC's if they exist!
        mesh = loadmsh(opts.init_file);

    end

    for iter = +1 : imax

        scal = min(2., ...
            .25 * (log2(imax - iter + 1) + 4)) ;

        if (isfield(opts,'optm_qlim'))

%---------------------------- create/write current QLIM flag

            QLIM = opts.optm_qlim ;
            OPTS.optm_qlim = QLIM / scal ;

        else

            QLIM = 0.93333 ;
            OPTS.optm_qlim = QLIM / scal ;

        end

        if (isfield(opts,'optm_dual'))

%---------------------------- create/write current DUAL flag

        OPTS.optm_dual = nlev == imax ;

        end

        if (inspect(mesh,'point'))

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

        if (inspect(mesh,'edge2'))

        ierr(mesh.edge2.index(:,1:2)) = +0 ;

        end

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

        savemsh(OPTS.init_file,init) ;

        end

%---------------------------------- call JIGSAW with new ICs
        mesh = jigsaw(OPTS) ;

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



