function drawmesh(mesh,varargin)
%DRAWMESH draw JIGSAW mesh data.

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   13-Aug-2018
%   darren.engwirda@columbia.edu
%-----------------------------------------------------------
%

    mask = [] ; cuts = [] ;

    if (nargin>=+2), mask = varargin{1}; end
    if (nargin>=+3), cuts = varargin{2}; end

    if (isfield(mesh,'mshID'))
        mshID =  mesh.mshID ;  
    else
        mshID = 'EUCLIDEAN-MESH' ;
    end

   [pass] = certify(mesh) ;

    if (isempty(mask))
 
 %-- draw all by default
    if (meshhas(mesh,'edge2'))
        mask.edge2 = ...
        true(size(mesh.edge2.index,1),1) ;
    end
    if (meshhas(mesh,'tria3'))
        mask.tria3 = ...
        true(size(mesh.tria3.index,1),1) ;
    end
    if (meshhas(mesh,'quad4'))
        mask.quad4 = ...
        true(size(mesh.quad4.index,1),1) ;
    end
    if (meshhas(mesh,'tria4'))
        mask.tria4 = ...
        true(size(mesh.tria4.index,1),1) ;
    end
    if (meshhas(mesh,'hexa8'))
        mask.hexa8 = ...
        true(size(mesh.hexa8.index,1),1) ;
    end
    if (meshhas(mesh,'value'))
        mask.value = ...
        true(size(mesh.value      ,1),1) ;
    end
    
    else
 
%-- draw nil by default 
    if (meshhas(mesh,'edge2') && ...
       ~isfield(mask,'edge2') )
        mask.edge2 = ...
       false(size(mesh.edge2.index,1),1) ;
    end
    if (meshhas(mesh,'tria3') && ...
       ~isfield(mask,'tria3') )
        mask.tria3 = ...
       false(size(mesh.tria3.index,1),1) ;
    end
    if (meshhas(mesh,'quad4') && ...
       ~isfield(mask,'quad4') )
        mask.quad4 = ...
       false(size(mesh.quad4.index,1),1) ;
    end
    if (meshhas(mesh,'tria4') && ...
       ~isfield(mask,'tria4') )
        mask.tria4 = ...
       false(size(mesh.tria4.index,1),1) ;
    end
    if (meshhas(mesh,'hexa8') && ...
       ~isfield(mask,'hexa8') )
        mask.hexa8 = ...
       false(size(mesh.hexa8.index,1),1) ;
    end
    if (meshhas(mesh,'value') && ...
       ~isfield(mask,'value') )
        mask.value = ...
       false(size(mesh.value.index,1),1) ;
    end
    
    end

    switch (upper(mshID))
    
    case 'EUCLIDEAN-MESH'
        draw_euclidean_mesh(mesh,mask,cuts) ;
    
    otherwise
        error('Invalid mshID!' )  ;
    
    end

end

function draw_euclidean_mesh(mesh,mask,cuts)
%DRAW-EUCLIDEAN-MESH draw mesh data in EUCLDIEAN-MESH format

    if (~meshhas(mesh,'point')), return ; end

    ndim = size(mesh.point.coord,2) - 1 ;

    switch (ndim)
    
    case +2
%-- draw mesh obj. in R^2

    if (meshhas(mesh,'edge2'))
    %-- draw EDGE2 mesh obj.
    if (meshhas(mesh,'value'))
        m = mask.edge2 ;
        drawedge_2(mesh.point.coord(:,1:2), ...
                   mesh.edge2.index(m,1:2)) ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    else
        m = mask.edge2 ;
        drawedge_2(mesh.point.coord(:,1:2), ...
                   mesh.edge2.index(m,1:2)) ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    end
    end
        
    if (meshhas(mesh,'tria3'))
    %-- draw TRIA3 mesh obj.
    if (meshhas(mesh,'value'))
        m = mask.tria3 ;
        drawtria_3(mesh.point.coord(:,1:2), ...
                   mesh.tria3.index(m,1:3), ...
        'facevertexcdata',mesh.value, ...
        'facecolor', 'flat') ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    else
        m = mask.tria3 ;
        drawtria_3(mesh.point.coord(:,1:2), ...
                   mesh.tria3.index(m,1:3)) ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    end
    end
    
    if (meshhas(mesh,'quad4'))
    %-- draw QUAD4 mesh obj.
    if (meshhas(mesh,'value'))
        m = mask.quad4 ;
        drawquad_4(mesh.point.coord(:,1:2), ...
                   mesh.quad4.index(m,1:4), ...
        'facevertexcdata',mesh.value, ...
        'facecolor', 'flat') ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    else
        m = mask.quad4 ;
        drawquad_4(mesh.point.coord(:,1:2), ...
                   mesh.quad4.index(m,1:4)) ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    end
    end
        
    case +3
%-- draw mesh obj. in R^3

    if (meshhas(mesh,'edge2'))
    %-- draw EDGE2 mesh obj.
    if (meshhas(mesh,'value'))
        m = mask.edge2 ;
        drawedge_2(mesh.point.coord(:,1:3), ...
                   mesh.edge2.index(m,1:2)) ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    else
        m = mask.edge2 ;
        drawedge_2(mesh.point.coord(:,1:3), ...
                   mesh.edge2.index(m,1:2)) ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    end
    end
        
    if (meshhas(mesh,'tria3'))
    %-- draw TRIA3 mesh obj.
    if (meshhas(mesh,'value'))
        m = mask.tria3 ;
        drawtria_3(mesh.point.coord(:,1:3), ...
                   mesh.tria3.index(m,1:3), ...
        'facevertexcdata',mesh.value, ...
        'facecolor', 'flat') ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    else
        m = mask.tria3 ;
        drawtria_3(mesh.point.coord(:,1:3), ...
                   mesh.tria3.index(m,1:3)) ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;      
    end
    end
    
    if (meshhas(mesh,'quad4'))
    %-- draw QUAD4 mesh obj.
    if (meshhas(mesh,'value'))
        m = mask.quad4 ;
        drawquad_4(mesh.point.coord(:,1:3), ...
                   mesh.quad4.index(m,1:4), ...
        'facevertexcdata',mesh.value, ...
        'facecolor', 'flat') ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    else
        m = mask.quad4 ;
        drawquad_4(mesh.point.coord(:,1:3), ...
                   mesh.quad4.index(m,1:4)) ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    end
    end
    
    if (meshhas(mesh,'tria4'))
    %-- draw TRIA4 mesh obj.
    if (meshhas(mesh,'value'))
        m = mask.tria4 ;
        drawtria_4(mesh.point.coord(:,1:3), ...
                   mesh.tria4.index(m,1:4), ...
        'facevertexcdata',mesh.value, ...
        'facecolor', 'flat') ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    else
        m = mask.tria4 ;
        drawtria_4(mesh.point.coord(:,1:3), ...
                   mesh.tria4.index(m,1:4)) ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    end
    end
    
    otherwise
    error('DRAWMESH: unsupported inputs.');
        
    end
    
end



