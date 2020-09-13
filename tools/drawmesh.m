function drawmesh(mesh,varargin)
%DRAWMESH draw JIGSAW mesh data.

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   07-Aug-2019
%   d.engwirda@gmail.com
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
    if (inspect(mesh,'edge2'))
        mask.edge2 = ...
        true(size(mesh.edge2.index,1),1) ;
    end
    if (inspect(mesh,'tria3'))
        mask.tria3 = ...
        true(size(mesh.tria3.index,1),1) ;
    end
    if (inspect(mesh,'quad4'))
        mask.quad4 = ...
        true(size(mesh.quad4.index,1),1) ;
    end
    if (inspect(mesh,'tria4'))
        mask.tria4 = ...
        true(size(mesh.tria4.index,1),1) ;
    end
    if (inspect(mesh,'hexa8'))
        mask.hexa8 = ...
        true(size(mesh.hexa8.index,1),1) ;
    end
    if (inspect(mesh,'wedg6'))
        mask.wedg6 = ...
        true(size(mesh.wedg6.index,1),1) ;
    end
    if (inspect(mesh,'pyra5'))
        mask.pyra5 = ...
        true(size(mesh.pyra5.index,1),1) ;
    end
    if (inspect(mesh,'value'))
        mask.value = ...
        true(size(mesh.value      ,1),1) ;
    end

    else

%-- draw nil by default
    if (inspect(mesh,'edge2') && ...
       ~isfield(mask,'edge2') )
        mask.edge2 = ...
       false(size(mesh.edge2.index,1),1) ;
    end
    if (inspect(mesh,'tria3') && ...
       ~isfield(mask,'tria3') )
        mask.tria3 = ...
       false(size(mesh.tria3.index,1),1) ;
    end
    if (inspect(mesh,'quad4') && ...
       ~isfield(mask,'quad4') )
        mask.quad4 = ...
       false(size(mesh.quad4.index,1),1) ;
    end
    if (inspect(mesh,'tria4') && ...
       ~isfield(mask,'tria4') )
        mask.tria4 = ...
       false(size(mesh.tria4.index,1),1) ;
    end
    if (inspect(mesh,'hexa8') && ...
       ~isfield(mask,'hexa8') )
        mask.hexa8 = ...
       false(size(mesh.hexa8.index,1),1) ;
    end
    if (inspect(mesh,'wedg6') && ...
       ~isfield(mask,'wedg6') )
        mask.wedg6 = ...
       false(size(mesh.wedg6.index,1),1) ;
    end
    if (inspect(mesh,'pyra5') && ...
       ~isfield(mask,'pyra5') )
        mask.pyra5 = ...
       false(size(mesh.pyra5.index,1),1) ;
    end
    if (inspect(mesh,'value') && ...
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

    if (~inspect(mesh,'point')), return ; end

    ndim = size(mesh.point.coord,2) - 1 ;

    switch (ndim)

    case +2
%-- draw mesh obj. in R^2

    if (inspect(mesh,'edge2'))
    %-- draw EDGE2 mesh obj.
    if (inspect(mesh,'value'))
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

    if (inspect(mesh,'tria3'))
    %-- draw TRIA3 mesh obj.
    if (inspect(mesh,'value'))
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

    if (inspect(mesh,'quad4'))
    %-- draw QUAD4 mesh obj.
    if (inspect(mesh,'value'))
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

    if (inspect(mesh,'edge2'))
    %-- draw EDGE2 mesh obj.
    if (inspect(mesh,'value'))
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

    if (inspect(mesh,'tria3'))
    %-- draw TRIA3 mesh obj.
    if (inspect(mesh,'value'))
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

    if (inspect(mesh,'quad4'))
    %-- draw QUAD4 mesh obj.
    if (inspect(mesh,'value'))
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

    if (inspect(mesh,'tria4'))
    %-- draw TRIA4 mesh obj.
    if (inspect(mesh,'value'))
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

    if (inspect(mesh,'hexa8'))
    %-- draw HEXA8 mesh obj.
    if (inspect(mesh,'value'))
        m = mask.hexa8 ;
        drawhexa_8(mesh.point.coord(:,1:3), ...
                   mesh.hexa8.index(m,1:8), ...
        'facevertexcdata',mesh.value, ...
        'facecolor', 'flat') ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    else
        m = mask.hexa8 ;
        drawhexa_8(mesh.point.coord(:,1:3), ...
                   mesh.hexa8.index(m,1:8)) ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    end
    end

    if (inspect(mesh,'wedg6'))
    %-- draw WEDG6 mesh obj.
    if (inspect(mesh,'value'))
        m = mask.wedg6 ;
        drawwedg_6(mesh.point.coord(:,1:3), ...
                   mesh.wedg6.index(m,1:6), ...
        'facevertexcdata',mesh.value, ...
        'facecolor', 'flat') ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    else
        m = mask.wedg6 ;
        drawwedg_6(mesh.point.coord(:,1:3), ...
                   mesh.wedg6.index(m,1:6)) ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    end
    end

    if (inspect(mesh,'pyra5'))
    %-- draw PYRA5 mesh obj.
    if (inspect(mesh,'value'))
        m = mask.pyra5 ;
        drawpyra_5(mesh.point.coord(:,1:3), ...
                   mesh.pyra5.index(m,1:5), ...
        'facevertexcdata',mesh.value, ...
        'facecolor', 'flat') ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    else
        m = mask.pyra5 ;
        drawpyra_5(mesh.point.coord(:,1:3), ...
                   mesh.pyra5.index(m,1:5)) ;
        axis image off ; hold on;
        set(gcf,'color','w') ;
        set(gca,'clipping','off') ;
    end
    end

    otherwise
    error('DRAWMESH: unsupported inputs.');

    end

end



