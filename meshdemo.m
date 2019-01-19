function meshdemo(varargin)
%MESHDEMO build example meshes for JIGSAW.
%
%   MESHDEMO(N) calls the N-TH demo problem. The following 
%   demo problems are currently available:
%
%   - DEMO-0: Simple 2-dimensional examples illustrating the 
%     construction of geometry + user-defined mesh-size con-
%     straints.
%
%   - DEMO-1: Simple 3-dimensional examples illustrating the 
%     construction of geometry + user-defined mesh-size con-
%     straints.
%
%   - DEMO-2: Build surface meshes for the "stanford-bunny" 
%     geometry. Compare the performance of the "delaunay" & 
%     "delfront" meshing kernals. Show mesh quality metrics.
%
%   - DEMO-3: Build _volume meshes for the "stanford-bunny" 
%     geometry. Compare the performance of the "delaunay" & 
%     "delfront" meshing kernals. Show mesh quality metrics.
%
%   - DEMO-4: Build surface meshes for the "fandisk" domain. 
%     Investigate options designed to detect and preserve 
%     "sharp-features" in the input geometry.
%
%   - DEMO-5: Build planar meshes for the "airfoil" problem. 
%     Investigate the use of user-defined mesh-spacing defi-
%     nitions.
%
%   - DEMO-6: Build planar meshes for the "lake" test-case. 
%     Investigate options designed to preserve "topological" 
%     consistency.
%
%   - DEMO-7: Build surface- and volume-meshes based on an 
%     analytic geometry definition. [iso-surface extraction 
%     (case 1)].
%
%   - DEMO-8: Build surface- and volume-meshes based on an 
%     analytic geometry definition. [iso-surface extraction 
%     (case 2)].
%
%   See also JIGSAW, TRIPOD

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   18-Jan-2019
%   darren.engwirda@columbia.edu
%-----------------------------------------------------------
%

    close all ; libpath ; libdata ;

    demo = 1;

    if (nargin >= 1), demo = varargin{1}; end
       
    switch (demo)
        case 0, demo0 ;
        case 1, demo1 ;
        case 2, demo2 ;
        case 3, demo3 ;
        case 4, demo4 ;
        case 5, demo5 ;
        case 6, demo6 ;
        case 7, demo7 ;
        case 8, demo8 ;
        
        otherwise
        error( ...
    'meshdemo:invalidSelection','Invalid selection!') ;
    end

end

function demo0
% DEMO-0 --- Simple 2-dimensional examples illustrating the 
%   construction of geometry + user-defined mesh-size const-
%   raints.

    demoA() ;
    demoB() ;
    demoC() ;
    
    drawnow ;        
    
    set(figure(1),'units','normalized', ...
        'position',[.05,.50,.25,.30]) ;
    set(figure(2),'units','normalized', ...
        'position',[.05,.15,.25,.25]) ;
    
    set(figure(3),'units','normalized', ...
        'position',[.30,.50,.25,.30]) ;
    set(figure(4),'units','normalized', ...
        'position',[.30,.15,.25,.25]) ;
    
    set(figure(5),'units','normalized', ...
        'position',[.55,.50,.25,.30]) ;    
    set(figure(6),'units','normalized', ...
        'position',[.55,.15,.25,.25]) ;

end

function demo1
% DEMO-1 --- Simple 3-dimensional examples illustrating the 
%   construction of geometry + user-defined mesh-size const-
%   raints.

    demoD() ;
    demoE() ;
    
    drawnow ;        
    
    set(figure(1),'units','normalized', ...
        'position',[.05,.50,.25,.30]) ;
    set(figure(2),'units','normalized', ...
        'position',[.05,.10,.25,.30]) ;
    
    set(figure(3),'units','normalized', ...
        'position',[.30,.50,.25,.30]) ;
    set(figure(4),'units','normalized', ...
        'position',[.30,.10,.25,.30]) ;    

end

function demoA
% DEMO-0 --- Simple 2-dimensional examples illustrating the 
%   construction of geometry + user-defined mesh-size const-
%   raints.

%------------------------------------ setup files for JIGSAW

    opts.geom_file = ...                % GEOM file
        ['jigsaw/geo/BOX2D-GEOM.msh'];
    
    opts.jcfg_file = ...                % JCFG file
        ['jigsaw/out/BOX2D.jig'] ;
    
    opts.mesh_file = ...                % MESH file
        ['jigsaw/out/BOX2D-MESH.msh'];
 
%------------------------------------ define JIGSAW geometry
    
    geom.mshID = 'EUCLIDEAN-MESH';

    geom.point.coord = [    % list of xy "node" coordinates
        0, 0, 0             % outer square
        9, 0, 0
        9, 9, 0
        0, 9, 0 
        4, 4, 0             % inner square
        5, 4, 0
        5, 5, 0
        4, 5, 0 ] ;
    
    geom.edge2.index = [    % list of "edges" between nodes
        1, 2, 0             % outer square 
        2, 3, 0
        3, 4, 0
        4, 1, 0 
        5, 6, 0             % inner square
        6, 7, 0
        7, 8, 0
        8, 5, 0 ] ;
        
    savemsh(opts.geom_file,geom) ;
    
%------------------------------------ make mesh using JIGSAW
  
    opts.hfun_hmax = 0.05 ;             % null HFUN limits
   
    opts.mesh_dims = +2 ;               % 2-dim. simplexes
    
    opts.optm_qlim = +.95 ;
   
    opts.mesh_top1 = true ;             % for sharp feat's
    opts.geom_feat = true ;
    
    mesh = jigsaw  (opts) ;
 
    figure('color','w');
    patch ('faces',mesh.tria3.index(:,1:3), ...
        'vertices',mesh.point.coord(:,1:2), ...
        'facecolor',[.7,.7,.9], ...
        'edgecolor',[.2,.2,.2]) ;
    hold on ; axis image off ;
    patch ('faces',mesh.edge2.index(:,1:2), ...
        'vertices',mesh.point.coord(:,1:2), ...
        'facecolor','w', ...
        'edgecolor',[.1,.1,.1], ...
        'linewidth',1.5) ;
    patch ('faces',geom.edge2.index(:,1:2), ...
        'vertices',geom.point.coord(:,1:2), ...
        'facecolor','w', ...
        'edgecolor',[.1,.1,.8], ...
        'linewidth',1.5) ;
        
    drawcost( meshcost(mesh) );
    
end

function demoB
% DEMO-0 --- Simple 2-dimensional examples illustrating the 
%   construction of geometry + user-defined mesh-size const-
%   raints.

%------------------------------------ setup files for JIGSAW

    opts.geom_file = ...                % GEOM file
        ['jigsaw/geo/BOX2D-GEOM.msh'];
    
    opts.jcfg_file = ...                % JCFG file
        ['jigsaw/out/BOX2D.jig'] ;
    
    opts.mesh_file = ...                % MESH file
        ['jigsaw/out/BOX2D-MESH.msh'];
 
%------------------------------------ define JIGSAW geometry
    
    global JIGSAW_EDGE2_TAG ;

    geom.mshID = 'EUCLIDEAN-MESH';

    geom.point.coord = [    % list of xy "node" coordinates
        0, 0, 0             % outer square
        9, 0, 0
        9, 9, 0
        0, 9, 0 
        2, 2, 0             % inner square
        7, 2, 0
        7, 7, 0
        2, 7, 0 
        3, 3, 0
        6, 6, 0 ] ;
    
    geom.edge2.index = [    % list of "edges" between nodes
        1, 2, 0             % outer square 
        2, 3, 0
        3, 4, 0
        4, 1, 0 
        5, 6, 0             % inner square
        6, 7, 0
        7, 8, 0
        8, 5, 0
        9,10, 0] ;          % inner const.
    
    geom.bound.index = [
        1, 1, JIGSAW_EDGE2_TAG
        1, 2, JIGSAW_EDGE2_TAG
        1, 3, JIGSAW_EDGE2_TAG
        1, 4, JIGSAW_EDGE2_TAG
        1, 5, JIGSAW_EDGE2_TAG
        1, 6, JIGSAW_EDGE2_TAG
        1, 7, JIGSAW_EDGE2_TAG
        1, 8, JIGSAW_EDGE2_TAG
        2, 5, JIGSAW_EDGE2_TAG
        2, 6, JIGSAW_EDGE2_TAG
        2, 7, JIGSAW_EDGE2_TAG
        2, 8, JIGSAW_EDGE2_TAG
            ] ;
        
    savemsh(opts.geom_file,geom) ;
    
%------------------------------------ make mesh using JIGSAW 
  
    opts.hfun_hmax = 0.05 ;             % null HFUN limits
    
    opts.mesh_dims = +2 ;               % 2-dim. simplexes
    
    opts.optm_qlim = +.95 ;
   
    opts.mesh_top1 = true ;             % for sharp feat's
    opts.geom_feat = true ;
    
    mesh = jigsaw  (opts) ;
 
    figure('color','w');
    I = mesh.tria3.index(:,4) == +1;
    patch ('faces',mesh.tria3.index(I,1:3), ...
        'vertices',mesh.point.coord(:,1:2), ...
        'facecolor',[.7,.9,.7], ...
        'edgecolor',[.2,.2,.2]) ;
    hold on ; axis image off ;
    I = mesh.tria3.index(:,4) == +2;
    patch ('faces',mesh.tria3.index(I,1:3), ...
        'vertices',mesh.point.coord(:,1:2), ...
        'facecolor',[.9,.7,.9], ...
        'edgecolor',[.2,.2,.2]) ;
    patch ('faces',mesh.edge2.index(:,1:2), ...
        'vertices',mesh.point.coord(:,1:2), ...
        'facecolor','w', ...
        'edgecolor',[.1,.1,.1], ...
        'linewidth',1.5) ;
    patch ('faces',geom.edge2.index(:,1:2), ...
        'vertices',geom.point.coord(:,1:2), ...
        'facecolor','w', ...
        'edgecolor',[.1,.1,.8], ...
        'linewidth',1.5) ;
        
    drawcost( meshcost(mesh) );

end

function demoC
% DEMO-0 --- Simple 2-dimensional examples illustrating the 
%   construction of geometry + user-defined mesh-size const-
%   raints.

%------------------------------------ setup files for JIGSAW

    opts.geom_file = ...                % GEOM file
        ['jigsaw/geo/BOX2D-GEOM.msh'];
    
    opts.jcfg_file = ...                % JCFG file
        ['jigsaw/out/BOX2D.jig'] ;
    
    opts.mesh_file = ...                % MESH file
        ['jigsaw/out/BOX2D-MESH.msh'];
    
    opts.hfun_file = ...                % HFUN file
        ['jigsaw/out/BOX2D-HFUN.msh'];
 
%------------------------------------ define JIGSAW geometry
    
    geom.mshID = 'EUCLIDEAN-MESH';

    geom.point.coord = [    % list of xy "node" coordinates
        0, 0, 0             % outer square
        9, 0, 0
        9, 9, 0
        0, 9, 0 
        4, 4, 0             % inner square
        5, 4, 0
        5, 5, 0
        4, 5, 0 ] ;
    
    geom.edge2.index = [    % list of "edges" between nodes
        1, 2, 0             % outer square 
        2, 3, 0
        3, 4, 0
        4, 1, 0 
        5, 6, 0             % inner square
        6, 7, 0
        7, 8, 0
        8, 5, 0 ] ;
        
    savemsh(opts.geom_file,geom) ;
    
%------------------------------------ compute HFUN over GEOM    
        
    xpos = linspace( ...
        min(geom.point.coord(:,1)), ...
        max(geom.point.coord(:,1)), ...
                64 ) ;
                    
    ypos = linspace( ...
        min(geom.point.coord(:,2)), ...
        max(geom.point.coord(:,2)), ...
                64 ) ;
    
   [XPOS,YPOS] = meshgrid(xpos,ypos) ;
    
    hfun =-.4*exp(-.1*(XPOS-4.5).^2 ...
                  -.1*(YPOS-4.5).^2 ...
            ) + .6 ;
    
    hmat.mshID = 'EUCLIDEAN-GRID';
    hmat.point.coord{1} = xpos ;
    hmat.point.coord{2} = ypos ;
    hmat.value = hfun ;
    
    savemsh(opts.hfun_file,hmat) ;
    
%------------------------------------ make mesh using JIGSAW 
  
    opts.hfun_scal = 'absolute';
    opts.hfun_hmax = +inf ;             % null HFUN limits
    opts.hfun_hmin = 0.00 ;
  
    opts.mesh_dims = +2 ;               % 2-dim. simplexes
    
    opts.optm_qlim = +.95 ;
   
    opts.mesh_top1 = true ;             % for sharp feat's
    opts.geom_feat = true ;
    
    mesh = jigsaw  (opts) ;
 
    figure('color','w');
    patch ('faces',mesh.tria3.index(:,1:3), ...
        'vertices',mesh.point.coord(:,1:2), ...
        'facecolor',[.9,.7,.7], ...
        'edgecolor',[.2,.2,.2]) ;
    hold on ; axis image off ;
    patch ('faces',mesh.edge2.index(:,1:2), ...
        'vertices',mesh.point.coord(:,1:2), ...
        'facecolor','w', ...
        'edgecolor',[.1,.1,.1], ...
        'linewidth',1.5) ;
    patch ('faces',geom.edge2.index(:,1:2), ...
        'vertices',geom.point.coord(:,1:2), ...
        'facecolor','w', ...
        'edgecolor',[.1,.1,.8], ...
        'linewidth',1.5) ;
        
    drawcost( meshcost(mesh) );
    
end

function demoD
% DEMO-1 --- Simple 3-dimensional examples illustrating the 
%   construction of geometry + user-defined mesh-size const-
%   raints.

%------------------------------------ setup files for JIGSAW

    opts.geom_file = ...                % GEOM file
        ['jigsaw/geo/BOX3D-GEOM.msh'];
    
    opts.jcfg_file = ...                % JCFG file
        ['jigsaw/out/BOX3D.jig'] ;
    
    opts.mesh_file = ...                % MESH file
        ['jigsaw/out/BOX3D-MESH.msh'];
    
%------------------------------------ define JIGSAW geometry
    
    geom.mshID = 'EUCLIDEAN-MESH';
    
    geom.point.coord = [    % list of xyz "node" coordinates
        0, 0, 0, 0
        3, 0, 0, 0
        3, 3, 0, 0
        0, 3, 0, 0
        0, 0, 3, 0
        3, 0, 3, 0
        3, 3, 3, 0
        0, 3, 3, 0 ] ;
        
    geom.tria3.index = [    % list of "trias" between points
        1, 2, 3, 0
        1, 3, 4, 0
        5, 6, 7, 0
        5, 7, 8, 0
        1, 2, 6, 0
        1, 6, 5, 0
        2, 3, 7, 0
        2, 7, 6, 0
        3, 4, 8, 0
        3, 8, 7, 0
        4, 8, 5, 0
        4, 5, 1, 0 ] ;
        
    savemsh(opts.geom_file,geom);

%------------------------------------ make mesh using JIGSAW 
  
    opts.hfun_hmax = 0.05 ;             % null HFUN limits
    
   %opts.mesh_kern = 'delaunay' ;
    
    opts.mesh_dims = +3 ;               % 3-dim. simplexes
   
    opts.mesh_top1 = true ;             % for sharp feat's
    opts.geom_feat = true ;
    
    mesh = jigsaw  (opts) ;
    
    mask = [];
    mask.tria3 = true(size( ...
    mesh.tria3.index,1),1);
    
    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;
    title('JIGSAW (DELFRONT)');
    
    mask = [];
    mask.tria4 = true(size( ...
    mesh.tria4.index,1),1);
    
    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;
    title('JIGSAW (DELFRONT)');
    
end

function demoE
% DEMO-1 --- Simple 3-dimensional examples illustrating the 
%   construction of geometry + user-defined mesh-size const-
%   raints.

%------------------------------------ setup files for JIGSAW

    opts.geom_file = ...                % GEOM file
        ['jigsaw/geo/BOX3D-GEOM.msh'];
    
    opts.jcfg_file = ...                % JCFG file
        ['jigsaw/out/BOX3D.jig'] ;
    
    opts.mesh_file = ...                % MESH file
        ['jigsaw/out/BOX3D-MESH.msh'];
        
    opts.hfun_file = ...                % HFUN file
        ['jigsaw/out/BOX3D-HFUN.msh'];
    
%------------------------------------ define JIGSAW geometry
    
    geom.mshID = 'EUCLIDEAN-MESH';
    
    geom.point.coord = [    % list of xyz "node" coordinates
        0, 0, 0, 0
        3, 0, 0, 0
        3, 3, 0, 0
        0, 3, 0, 0
        0, 0, 3, 0
        3, 0, 3, 0
        3, 3, 3, 0
        0, 3, 3, 0 ] ;
        
    geom.tria3.index = [    % list of "trias" between points
        1, 2, 3, 0
        1, 3, 4, 0
        5, 6, 7, 0
        5, 7, 8, 0
        1, 2, 6, 0
        1, 6, 5, 0
        2, 3, 7, 0
        2, 7, 6, 0
        3, 4, 8, 0
        3, 8, 7, 0
        4, 8, 5, 0
        4, 5, 1, 0 ] ;
        
    savemsh(opts.geom_file,geom);
    
%------------------------------------ compute HFUN over GEOM 

    xpos = linspace( ...
        min(geom.point.coord(:,1)), ...
        max(geom.point.coord(:,1)), ...
                64 ) ;
                    
    ypos = linspace( ...
        min(geom.point.coord(:,2)), ...
        max(geom.point.coord(:,2)), ...
                64 ) ;
                
    zpos = linspace( ...
        min(geom.point.coord(:,3)), ...
        max(geom.point.coord(:,3)), ...
                64 ) ;
    
   [XPOS,YPOS,ZPOS] = ...
        meshgrid(xpos,ypos,zpos) ;
    
    hfun =-.2*exp(-2.*(XPOS-1.5).^2 ...
                  -2.*(YPOS-1.5).^2 ...
                  -2.*(ZPOS-1.5).^2 ...
            ) + .3 ;
    
    hmat.mshID = 'EUCLIDEAN-GRID';
    hmat.point.coord{1} = xpos ;
    hmat.point.coord{2} = ypos ;
    hmat.point.coord{3} = zpos ;
    hmat.value = hfun ;
    
    savemsh(opts.hfun_file,hmat) ;

%------------------------------------ make mesh using JIGSAW 
  
    opts.hfun_scal = 'absolute' ;
    opts.hfun_hmax = +inf ;             % null HFUN limits
    opts.hfun_hmin = 0.00 ;
    
   %opts.mesh_kern = 'delaunay' ;
    
    opts.mesh_dims = +3 ;               % 3-dim. simplexes
   
    opts.mesh_top1 = true ;             % for sharp feat's
    opts.geom_feat = true ;
    
    mesh = jigsaw  (opts) ;
    
    mask = [];
    mask.tria3 = true(size( ...
    mesh.tria3.index,1),1);
    
    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;
    title('JIGSAW (DELAUNAY)');
    
    mask = [];
    mask.tria4 = true(size( ...
    mesh.tria4.index,1),1);
    
    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;
    title('JIGSAW (DELAUNAY)');
    
end

function demo2
% DEMO-2 --- Build surface meshes for the "stanford-bunny" 
%   geometry. Compare the performance of the "delaunay" & 
%   "delfront" meshing kernals. Show mesh quality metrics.

    name = 'bunny' ;

%------------------------------------ setup files for JIGSAW

    opts.geom_file = ...            % domain file
        ['jigsaw/geo/',name,'.msh'];
    
    opts.jcfg_file = ...            % config file
        ['jigsaw/out/',name,'.jig'];
    
    opts.mesh_file = ...            % output file
        ['jigsaw/out/',name,'.msh'];
  
%------------------------------------ read GEOM. for display

    geom = loadmsh (opts.geom_file);

    figure ; drawmesh(geom);
    view(0,-110); axis image;
    title('INPUT GEOMETRY');
    
%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delaunay';
    opts.mesh_dims = 2 ;
    
    opts.hfun_hmax = 0.03 ;
    
    mesh = jigsaw  (opts) ;
 
    figure ; drawmesh(mesh);
    view(0,-110); axis image;
    title('JIGSAW (DELAUNAY)') ;
        
    drawcost( meshcost(mesh) ) ;
    
%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;
    
    opts.hfun_hmax = 0.03 ;
    
    mesh = jigsaw  (opts) ;
 
    figure ; drawmesh(mesh);
    view(0,-110); axis image;
    title('JIGSAW (DELFRONT)') ;

    drawcost( meshcost(mesh) ) ;
    
    drawnow ;
    
    set(figure(1),'units','normalized', ...
        'position',[.55,.50,.25,.30]) ;
    
    set(figure(2),'units','normalized', ...
        'position',[.05,.50,.25,.30]) ;
    set(figure(4),'units','normalized', ...
        'position',[.30,.50,.25,.30]) ;
    
    set(figure(3),'units','normalized', ...
        'position',[.05,.15,.25,.25]) ;
    set(figure(5),'units','normalized', ...
        'position',[.30,.15,.25,.25]) ;
    
end

function demo3
% DEMO-3 --- Build _volume meshes for the "stanford-bunny" 
%   geometry. Compare the performance of the "delaunay" & 
%   "delfront" meshing kernals. Show mesh quality metrics.

    name = 'bunny' ;

%------------------------------------ setup files for JIGSAW

    opts.geom_file = ...            % domain file
        ['jigsaw/geo/',name,'.msh'];
    
    opts.jcfg_file = ...            % config file
        ['jigsaw/out/',name,'.jig'];
    
    opts.mesh_file = ...            % output file
        ['jigsaw/out/',name,'.msh'];
  
%------------------------------------ read GEOM. for display

    geom = loadmsh (opts.geom_file);

    figure ; drawmesh(geom);
    view(-10,-110); axis image;
    title('INPUT GEOMETRY');
    
%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delaunay';
    opts.mesh_dims = 3 ;
    opts.mesh_vol3 = 0.05 ;
    
    opts.hfun_hmax = 0.03 ;
    
    mesh = jigsaw  (opts) ;
 
    mask = [];
    mask.tria3 = true(size( ...
    mesh.tria3.index,1),1);
    
    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;
    title('JIGSAW (DELAUNAY)');
    
    mask = [];
    mask.tria4 = true(size( ...
    mesh.tria4.index,1),1);
    
    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;
    title('JIGSAW (DELAUNAY)');
    
    drawcost( meshcost(mesh) );
    
%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 3 ;
    opts.mesh_vol3 = 0.05 ;
    
    opts.hfun_hmax = 0.03 ;
    
    mesh = jigsaw  (opts) ;
 
    mask = [];
    mask.tria3 = true(size( ...
    mesh.tria3.index,1),1);
    
    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;
    title('JIGSAW (DELFRONT)');
    
    mask = [];
    mask.tria4 = true(size( ...
    mesh.tria4.index,1),1);
    
    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;
    title('JIGSAW (DELFRONT)');

    drawcost( meshcost(mesh) );
    
    drawnow ;
    
    set(figure(1),'units','normalized',...
        'position',[.55,.50,.25,.30]) ;
    
    set(figure(2),'units','normalized',...
        'position',[.05,.50,.25,.30]) ;
    set(figure(3),'units','normalized',...
        'position',[.05,.50,.25,.30]) ;
    set(figure(6),'units','normalized',...
        'position',[.30,.50,.25,.30]) ;
    set(figure(7),'units','normalized',...
        'position',[.30,.50,.25,.30]) ;
    
    set(figure(4),'units','normalized',...
        'position',[.05,.15,.25,.25]) ;
    set(figure(5),'units','normalized',...
        'position',[.05,.15,.25,.25]) ;
    set(figure(8),'units','normalized',...
        'position',[.30,.15,.25,.25]) ;
    set(figure(9),'units','normalized',...
        'position',[.30,.15,.25,.25]) ;

end

function demo4
% DEMO-4 --- Build surface meshes for the "fandisk" domain. 
%   Investigate options designed to detect and preserve 
%   "sharp-features" in the input geometry.

    name = 'fandisk' ;

%------------------------------------ setup files for JIGSAW

    opts.geom_file = ...            % domain file
        ['jigsaw/geo/',name,'.msh'];
    
    opts.jcfg_file = ...            % config file
        ['jigsaw/out/',name,'.jig'];
    
    opts.mesh_file = ...            % output file
        ['jigsaw/out/',name,'.msh'];
  
%------------------------------------ read GEOM. for display

    geom = loadmsh (opts.geom_file);

    figure ; drawmesh(geom);
    view(-30,+30); axis image;
    title('INPUT GEOMETRY');
    
%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;
    
    opts.geom_feat =false ;
    
    opts.hfun_hmax = 0.03 ;
    
    mesh = jigsaw  (opts) ;
 
    figure ; drawmesh(mesh);
    view(-30,+30); axis image;
    title('JIGSAW (FEAT=FALSE)');
    
%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;
    
    opts.geom_feat = true ;
    opts.mesh_top1 = true ;
    
    opts.hfun_hmax = 0.03 ;
    
    mesh = jigsaw  (opts) ;
 
    mask = [];
    mask.edge2 = true(size( ...
    mesh.edge2.index,1),1);
    
    figure ; drawmesh(mesh,mask);
    view(-30,+30); axis image;
    title('JIGSAW (FEAT=TRUE)');
    
    mask = [];
    mask.tria3 = true(size( ...
    mesh.tria3.index,1),1);
    
    figure ; drawmesh(mesh,mask);
    view(-30,+30); axis image;
    title('JIGSAW (FEAT=TRUE)');
    
    drawnow ;
    
    set(figure(1),'units','normalized',...
        'position',[.55,.50,.25,.30]) ;
    
    set(figure(2),'units','normalized',...
        'position',[.05,.50,.25,.30]) ;
    
    set(figure(3),'units','normalized',...
        'position',[.30,.10,.25,.30]) ;
    set(figure(4),'units','normalized',...
        'position',[.30,.50,.25,.30]) ;
    
end

function demo5
% DEMO-5 --- Build planar meshes for the "airfoil" problem. 
%   Investigate the use of user-defined mesh-spacing defi-
%   nitions.

    name = 'airfoil' ;

%------------------------------------ setup files for JIGSAW

    opts.geom_file = ...            % domain file
        ['jigsaw/geo/',name,'.msh'];
    
    opts.jcfg_file = ...            % config file
    ['jigsaw/out/',name,'-BACK.jig'] ;
    
    opts.mesh_file = ...            % output file
    ['jigsaw/out/',name,'-BACK.msh'] ;
  
%------------------------------------ read GEOM. for display

    geom = loadmsh (opts.geom_file);

    figure ; drawmesh(geom);
    axis image;
    title('INPUT GEOMETRY');
    
%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;
    opts.mesh_top1 = true ;
    
    opts.optm_iter = 0 ;
    
    opts.geom_feat = true ;
    
    opts.hfun_hmax = 0.04 ;
    
    back = jigsaw  (opts) ;
     
    fun1 = ...
   +0.1*(back.point.coord(:,1)-.40).^2 + ...
   +2.0*(back.point.coord(:,2)-.55).^2 ;
   
    fun2 = ...
   +0.7*(back.point.coord(:,1)-.75).^2 + ...
   +0.7*(back.point.coord(:,2)-.45).^2 ;
    
    hmin = 0.01;
    hmax = 0.10;
    
    back.value = 0.4 * ...
    max(min(min(fun1,fun2),hmax),hmin) ;
    
    figure ; drawmesh(back);
    axis image;
    title('MESH-SIZE H(X)');

%------------------------------------ setup files for JIGSAW

    opts.geom_file = ...            % domain file
    ['jigsaw/geo/',name,'.msh'];
    
    opts.jcfg_file = ...            % config file
    ['jigsaw/out/',name,'-MESH.jig'] ;
    
    opts.mesh_file = ...            % output file
    ['jigsaw/out/',name,'-MESH.msh'] ;
    
    opts.hfun_file = ...            % sizing file
    ['jigsaw/out/',name,'-HFUN.msh'] ;
 
    savemsh(opts.hfun_file,back) ;
    
%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;
    opts.mesh_top1 = true ;
    
    opts.optm_iter = 8 ;
    
    opts.geom_feat = true ;
    
    opts.hfun_scal = 'absolute';
    opts.hfun_hmax = +inf ;
    opts.hfun_hmin = +0.0 ;
    
    mesh = jigsaw  (opts) ;
 
    figure ; drawmesh(mesh);
    axis image;
    title('JIGSAW OUTPUT');

    drawcost( meshcost(mesh) ) ;
    
    drawnow ;
    
    set(figure(1),'units','normalized', ...
        'position',[.55,.50,.25,.30]) ;
    
    set(figure(2),'units','normalized', ...
        'position',[.30,.50,.25,.30]) ;
    set(figure(3),'units','normalized', ...
        'position',[.05,.50,.25,.30]) ;
        
    set(figure(4),'units','normalized', ...
        'position',[.05,.15,.25,.25]) ;
        
end

function demo6
% DEMO-6 --- Build planar meshes for the "lake" test-case. 
%   Investigate options designed to preserve "topological" 
%   consistency.

    name = 'lake' ;

%------------------------------------ setup files for JIGSAW

    opts.geom_file = ...            % domain file
        ['jigsaw/geo/',name,'.msh'];
    
    opts.jcfg_file = ...            % config file
        ['jigsaw/out/',name,'.jig'];
    
    opts.mesh_file = ...            % output file
        ['jigsaw/out/',name,'.msh'];
  
%------------------------------------ read GEOM. for display

    geom = loadmsh (opts.geom_file);

    figure ; drawmesh(geom);
    axis image;
    title('INPUT GEOMETRY');
    
%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;
    opts.mesh_top1 =false ;
    
    opts.optm_iter = 0 ;
    
    opts.geom_feat = true ;
    
    opts.hfun_hmax = 0.20
    
    mesh = jigsaw  (opts) ;
 
    mask = [];
    mask.edge2 = true(size( ...
    mesh.edge2.index,1),1);
    
    figure ; drawmesh(mesh,mask);
    axis image;
    title('JIGSAW (TOPO=FALSE)');
    
    mask = [];
    mask.tria3 = true(size( ...
    mesh.tria3.index,1),1);
    
    figure ; drawmesh(mesh,mask);
    axis image;
    title('JIGSAW (TOPO=FALSE)');
    
%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;
    opts.mesh_top1 = true ;
    
    opts.optm_iter = 0 ;
    
    opts.geom_feat = true ;
    
    opts.hfun_hmax = 0.20 ;
    
    mesh = jigsaw  (opts) ;
 
    mask = [];
    mask.edge2 = true(size( ...
    mesh.edge2.index,1),1);
    
    figure ; drawmesh(mesh,mask);
    axis image;
    title('JIGSAW (TOPO=TRUE)');
    
    mask = [];
    mask.tria3 = true(size( ...
    mesh.tria3.index,1),1);
    
    figure ; drawmesh(mesh,mask);
    axis image;
    title('JIGSAW (TOPO=TRUE)');
    
    drawnow ;
    
    set(figure(1),'units','normalized',...
        'position',[.55,.50,.25,.30]) ;
    
    set(figure(2),'units','normalized',...
        'position',[.05,.10,.25,.30]) ;
    set(figure(3),'units','normalized',...
        'position',[.05,.50,.25,.30]) ;
    
    set(figure(4),'units','normalized',...
        'position',[.30,.10,.25,.30]) ;
    set(figure(5),'units','normalized',...
        'position',[.30,.50,.25,.30]) ;

end

function demo7
% DEMO-7 --- Build surface- and volume-meshes based on an 
%   analytic geometry definition. [iso-surface extraction 
%   (case 1)].

    name = 'eight';

   [y,x,z] = ndgrid(linspace(-.75,+.75,2^7), ...
                    linspace(-.10,+2.1,2^7), ...
                    linspace(-.20,+.20,2^7)) ;
              
    F = (x.*(x-1.).^2.*(x-2.) + y.^2).^2 + z.^2 ;
    
   [f,v] = isosurface(x,y,z,F,.020);
   
    geom.point.coord = [v,zeros(size(v,1),1)];
    geom.tria3.index = [f,zeros(size(f,1),1)];
   
%------------------------------------ setup files for JIGSAW

    opts.geom_file = ...            % domain file
    ['jigsaw/geo/',name,'.msh'];
    
    opts.jcfg_file = ...            % config file
    ['jigsaw/out/',name,'.jig'];
    
    opts.mesh_file = ...            % output file
    ['jigsaw/out/',name,'.msh'];
 
    savemsh(opts.geom_file,geom) ;
    
    figure ; drawmesh(geom);
    view(-30,+20); 
    axis image;
    title('INPUT GEOMETRY');
    
%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 3 ;
    
    opts.hfun_hmax = 0.04 ;
    
    mesh = jigsaw  (opts) ;
 
    figure ; drawmesh(mesh);
    view(-30,+20); 
    axis image;
    title('JIGSAW OUTPUT');
    
    drawnow ;
    
    set(figure(1),'units','normalized',...
        'position',[.05,.50,.25,.30]) ;
        
    set(figure(2),'units','normalized',...
        'position',[.30,.50,.25,.30]) ;
    
end

function demo8
% DEMO-8 --- Build surface- and volume-meshes based on an 
%   analytic geometry definition. [iso-surface extraction 
%   (case 2)].

    name = 'orbis';

   [y,x,z] = ndgrid(linspace(-6,+6,2^7), ...
                    linspace(-6,+6,2^7), ...
                    linspace(-6,+6,2^7)) ;

    F = - (cos(x).*sin(y) + ...
           cos(y).*sin(z) + ...
           cos(z).*sin(x) ) ...
       .* (cos(x).*sin(y) + ...
           cos(y).*sin(z) + ...
           cos(z).*sin(x) ) ...
        + 0.02 ...
        + exp((x.*x+y.*y+z.*z)-32.0) ;
    
   [f,v] = isosurface(x,y,z,F,.001);
    
    geom.point.coord = [v,zeros(size(v,1),1)];
    geom.tria3.index = [f,zeros(size(f,1),1)];
   
%------------------------------------ setup files for JIGSAW

    opts.geom_file = ...            % domain file
    ['jigsaw/geo/',name,'.msh'];
    
    opts.jcfg_file = ...            % config file
    ['jigsaw/out/',name,'.jig'];
    
    opts.mesh_file = ...            % output file
    ['jigsaw/out/',name,'.msh'];
 
    savemsh(opts.geom_file,geom) ;
    
    figure ; drawmesh(geom);
    axis image;
    title('INPUT GEOMETRY');
    
%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 3 ;
    
    opts.mesh_top2 = true ;
    
    opts.hfun_hmax = 0.04 ;
    
    mesh = jigsaw  (opts) ;
 
    mask = [];
    mask.tria3 = true(size( ...
    mesh.tria3.index,1),1);
    
    figure ; drawmesh(mesh,mask);
    axis image;
    title('JIGSAW OUTPUT');
    
    mask = [];
    mask.tria4 = true(size( ...
    mesh.tria4.index,1),1);
    
    figure ; drawmesh(mesh,mask);
    axis image;
    title('JIGSAW OUTPUT');
    
    drawnow ;
    
    set(figure(1),'units','normalized',...
        'position',[.05,.50,.25,.30]) ;
        
    set(figure(2),'units','normalized',...
        'position',[.30,.50,.25,.30]) ;
    
    set(figure(3),'units','normalized',...
        'position',[.55,.50,.25,.30]) ;
    
end



