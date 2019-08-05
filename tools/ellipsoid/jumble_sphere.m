function [mesh] = jumble_sphere(opts,mesh, ...
                                frac)
%JUMBLE-SPHERE perturb the points in a spheroidal mesh and 
%update the grid topology.
%   MESH = JUMBLE-SPHERE(OPTS,MESH,FRAC) returns a new "per-
%   turbed" mesh object MESH where the points have been 
%   (quasi-randomly) relocated by a relative fraction FRAC. 
%   Setting FRAC => 1.0 results in a larger perturbation.
%   Internally, JIGSAW is called to update the topology of 
%   the grid in the perturbed state. OPTS is a config. opti-
%   ons structure for JIGSAW that must define the GEOM-FILE 
%   and JCFG-FILE fields.
%
%   See also JIGSAW, TRIPOD
% 

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   30-Jul-2019
%   darren.engwirda@columbia.edu
%-----------------------------------------------------------
%

%------------------------------------ run perturbation iter.
    OPTS = opts; imax = +16 ;
    
    geom = loadmsh(OPTS.geom_file) ;
    
    for iter = 1:imax
    
        mesh = jumble(mesh,frac) ;
        
        mesh = attach(mesh,geom) ;
        
        if (iter == imax || mod(iter,4) == +0)
        
       [path,name,fext] = ...
            fileparts(opts.jcfg_file) ;
        
        if (~isempty(path)), 
            path = [path, '/']; 
        end
        
        OPTS.init_file = ...
            [path,name,'-INIT', '.msh'] ;
        OPTS.mesh_file = ...
            [path,name,'-TRIA', '.msh'] ;
        
        OPTS.mesh_dims = +2 ;
        
        mesh.point.coord(end+1,:) = [0,0,0,0];
        mesh.tria3.index = [] ;
        
        savemsh (OPTS.init_file,mesh) ;
        
        mesh = tripod(OPTS) ;

        end
    
    end

end

function [mesh] = attach(mesh,geom)
%ATTACH-POINTS project points on to the spheroidal surface.

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
        geom.radii(3) .* sin(xlat);

end

function [mesh] = jumble(mesh,frac)
%JUMBLE-POINTS perturb points by translating toward largest 
%adj. centroid by some (quasi-random) fraction FRAC.

    area = trivol2( ...
           mesh.point.coord(:,1:3), ...
           mesh.tria3.index(:,1:3)) ;
            
    pmid = mesh.point.coord( ...
           mesh.tria3.index(:,1),:) ...
         + mesh.point.coord( ...
           mesh.tria3.index(:,2),:) ...
         + mesh.point.coord( ...
           mesh.tria3.index(:,3),:) ;
    pmid = pmid / +3. ;

    SMAT = sparse(mesh.tria3.index(:,1:3), ...
        repmat((1:size(mesh.tria3.index,1))',1,3), ...
            repmat(area,1,3)) ;

   [junk,best] = max(SMAT,[],2) ;

    move =  frac .* (.5*rand(size(best))+.5) ;
    
    pnew(:,1) = ...
        (1. - move) .* mesh.point.coord(:,1) + ...
        (0. + move) .* pmid(best,1);
    pnew(:,2) = ...
        (1. - move) .* mesh.point.coord(:,2) + ...
        (0. + move) .* pmid(best,2);
    pnew(:,3) = ...
        (1. - move) .* mesh.point.coord(:,3) + ...
        (0. + move) .* pmid(best,3);

    okay = rand(size(pnew,1),1) >= .67 ;

    mesh.point.coord(okay,1:3) = pnew(okay,:);

end



