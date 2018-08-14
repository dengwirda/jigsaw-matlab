function [cost] = meshcost(varargin)
%MESHCOST calculate cost metrics for a given mesh.

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   26-Jul-2018
%   de2363@columbia.edu
%-----------------------------------------------------------
%

    cost = struct(); mesh = [] ; hfun = [] ;
    
    if (nargin>=+1), mesh = varargin{1}; end
    if (nargin>=+2), hfun = varargin{2}; end

    if (isempty(hfun)), hfun = struct(); end

    if (~isfield(mesh,'mshID'))
        mesh.mshID = 'EUCLIDEAN-MESH';
    end
    
   [pass] = certify(mesh) ;
    
    if (~isfield(hfun,'mshID'))
        hfun.mshID = 'EUCLIDEAN-MESH';
    end

   [pass] = certify(hfun) ;

%-- eval. mesh-spacing function via interpolation
    
    if (~meshhas(hfun,'point'))
    
        hvrt =   [] ;
    
    else
    
        hvrt = interp_hfun(mesh,hfun);

    end
   
%-- eval. mesh quality metrics for TRIA3 elements 
     
    if (meshhas(mesh,'tria3'))
    
    if (meshhas(mesh,'point','power'))
    
    cost.tria3.score_d = vorscr2( ...
        mesh.point.coord(:,1:end-1), ...
        mesh.point.power, ...
        mesh.tria3.index(:,1:end-1)) ;
    
    end
    
    cost.tria3.score_t = triscr2( ...
        mesh.point.coord(:,1:end-1), ...
        mesh.tria3.index(:,1:end-1)) ;
               
    cost.tria3.angle_t = triang2( ...
        mesh.point.coord(:,1:end-1), ...
        mesh.tria3.index(:,1:end-1)) ;

    if (~isempty(hvrt))

    cost.tria3.scale_t = relhfn2( ...
        mesh.point.coord(:,1:end-1), ...
        mesh.tria3.index(:,1:end-1), ...
        hvrt) ;
    
    end

    end
 
%-- eval. mesh quality metrics for TRIA4 elements 
    
    if (meshhas(mesh,'tria4'))
    
    if (meshhas(mesh,'point','power'))
    
    cost.tria4.score_d = vorscr3( ...
        mesh.point.coord(:,1:end-1), ...
        mesh.point.power, ...
        mesh.tria4.index(:,1:end-1)) ;
    
    end
    
    cost.tria4.score_t = triscr3( ...
        mesh.point.coord(:,1:end-1), ...
        mesh.tria4.index(:,1:end-1)) ;
               
    cost.tria4.angle_t = triang3( ...
        mesh.point.coord(:,1:end-1), ...
        mesh.tria4.index(:,1:end-1)) ;
        
    if (~isempty(hvrt))

    cost.tria4.scale_t = relhfn3( ...
        mesh.point.coord(:,1:end-1), ...
        mesh.tria4.index(:,1:end-1), ...
        hvrt) ;
    
    end
    
    end

end

function [hvrt] = interp_hfun(mesh,hfun)
%INTERP-HFUN eval. HFUN. at mesh vertices via interpolation.

    switch (lower(mesh.mshID))
        
    case 'euclidean-mesh'

        switch (lower(hfun.mshID))

        case 'euclidean-mesh'
        
    %-- eval. an unstructured euclidean HFUN mesh
        
            if (size( ...
            mesh.point.coord,2) == +3 && ...
                size( ...
            hfun.point.coord,2) == +3 )
                
            tree = idxtri2( ...
                hfun.point.coord(:,1:2), ...
                hfun.tria3.index(:,1:3)) ;
                
            hvrt = trifun2( ...
                mesh.point.coord(:,1:2), ...
                hfun.point.coord(:,1:2), ...
                hfun.tria3.index(:,1:3), ...
                tree,hfun.value) ;
                
            end
            
            if (size( ...
            mesh.point.coord,2) == +4 && ...
                size( ...
            hfun.point.coord,2) == +4 )
                
            tree = idxtri3( ...
                hfun.point.coord(:,1:3), ...
                hfun.tria4.index(:,1:4)) ;
                
            hvrt = trifun3( ...
                mesh.point.coord(:,1:3), ...
                hfun.point.coord(:,1:3), ...
                hfun.tria4.index(:,1:4), ...
                tree,hfun.value) ;
                
            end
        
        case 'euclidean-grid'
        
    %-- eval. HFUN from structured euclidean grid
        
            if (size( ...
                mesh.point.coord,2)==3&& ...
                size( ...
                hfun.point.coord,2)==2 )
               
            hvrt = interp2( ...
                hfun.point.coord{  1}, ...
                hfun.point.coord{  2}, ...
                hfun.value, ...
                mesh.point.coord(:,1), ...
                mesh.point.coord(:,2)) ;
                
            end
            
            if (size( ...
                mesh.point.coord,2)==4&& ...
                size( ...
                hfun.point.coord,2)==3 )
               
            hvrt = interp3( ...
                hfun.point.coord{  1}, ...
                hfun.point.coord{  2}, ...
                hfun.point.coord{  3}, ...
                hfun.value, ...
                mesh.point.coord(:,1), ...
                mesh.point.coord(:,2), ...
                mesh.point.coord(:,3)) ;
                
            end
        
        case 'ellipsoid-mesh'
        
    %-- eval. an unstructured ellipsoid HFUN mesh
        
            %%!! TODO!!
        
        
        case 'ellipsoid-grid'

    %-- eval. HFUN from structured ellipsoid grid

            if (size( ...
                mesh.point.coord,2)==4&& ...
                size( ...
                hfun.point.coord,2)==2 )
               
            xrad = ...
                mesh.point.coord(:,1).^2 ...
              + mesh.point.coord(:,2).^2 ...
              + mesh.point.coord(:,3).^2 ;
            
            xlat = asin ( ...
                mesh.point.coord(:,3)./...
                max(sqrt(xrad), eps )) ;
            xlon = atan2( ...
                mesh.point.coord(:,2), ...
                mesh.point.coord(:,1)) ;
            
            hvrt = interp2( ...
                hfun.point.coord{  1}, ...
                hfun.point.coord{  2}, ...
                hfun.value,xlon,xlat ) ;
                
            end

        end   

    otherwise
    
        error('Unsupported MESH types.') ;
    
    end

end



