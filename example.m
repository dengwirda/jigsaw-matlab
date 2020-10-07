function example(varargin)
%EXAMPLE build example meshes for JIGSAW.
%
%   EXAMPLE(N) calls the N-TH example problem. The following
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
%   - DEMO-2: Build planar meshes for the "lakes" test-case.
%     Compare the performance of the "delaunay" &
%     "delfront" meshing kernals. Show mesh quality metrics.
%
%   - DEMO-3: Build surface meshes for the "stanford-bunny"
%     geometry. Compare the performance of the "delaunay" &
%     "delfront" meshing kernals. Show mesh quality metrics.
%
%   - DEMO-4: Build _volume meshes for the "stanford-bunny"
%     geometry. Compare the performance of the "delaunay" &
%     "delfront" meshing kernals. Show mesh quality metrics.
%
%   - DEMO-5: Build planar meshes for the "airfoil" problem.
%     Impose user-defined mesh-spacing constraints.
%
%   - DEMO-6: Build surface meshes for a mechanical bracket.
%     Configure to detect and preserve sharp-features in the
%     input geometry.
%
%   - DEMO-7: Build surface meshes for the "wheel" geometry;
%     defined as a collection of open surfaces.
%
%   - DEMO-8: remesh geometry generated using marching-cubes
%     approach.
%
%   - DEMO-9: extrude a surface mesh into a prismatic volume
%     representation.
%
%   See also DETAILS

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   05-Oct-2020
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    close all ;

    demo =  +1;
    show =  +1;

    if (nargin >= 1), demo = varargin{1}; end
    if (nargin >= 2), show = varargin{2}; end

    switch (demo)
        case-1
%------ run all of the examples sequentially, for ci testing
        for ex = 0 : 9
            example (ex, +0) ;
        end
        disp('Jigsaw tests completed successfully!') ;

%------ run "regular" examples, via e.g. the MATLAB cmd-line
        case 0, demo_0(show) ;
        case 1, demo_1(show) ;
        case 2, demo_2(show) ;
        case 3, demo_3(show) ;
        case 4, demo_4(show) ;
        case 5, demo_5(show) ;
        case 6, demo_6(show) ;
        case 7, demo_7(show) ;
        case 8, demo_8(show) ;
        case 9, demo_9(show) ;

        otherwise
        error( ...
    'example:invalidSelection','Invalid selection!') ;
    end

end

function demo_0(show)
% DEMO-0 --- Simple 2-dimensional examples illustrating the
%   construction of geometry + user-defined mesh-size const-
%   raints.

    demo_A(show);
    demo_B(show);
    demo_C(show);

    if (show > 0)
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

end

function demo_A(show)
% DEMO-0 --- Simple 2-dimensional examples illustrating the
%   construction of geometry + user-defined mesh-size const-
%   raints.

%------------------------------------ setup files for JIGSAW

    rootpath = fileparts( ...
        mfilename( 'fullpath' ) ) ;

    opts.geom_file = ...                % domian file
        fullfile(rootpath,...
        'cache','box2d-geom.msh') ;

    opts.jcfg_file = ...                % config file
        fullfile(rootpath,...
        'cache','box2d.jig') ;

    opts.mesh_file = ...                % output file
        fullfile(rootpath,...
        'cache','box2d-mesh.msh') ;

    initjig ;                           % init jigsaw

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

    opts.hfun_hmax = 0.05 ;             % push HFUN limits

    opts.mesh_dims = +2 ;               % 2-dim. simplexes

    opts.optm_qlim = +.95 ;

    opts.mesh_top1 = true ;             % for sharp feat's
    opts.geom_feat = true ;

    mesh = jigsaw  (opts) ;

    if (show > +0)
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

    drawcost(mesh) ;
    end

end

function demo_B(show)
% DEMO-0 --- Simple 2-dimensional examples illustrating the
%   construction of geometry + user-defined mesh-size const-
%   raints.

%------------------------------------ setup files for JIGSAW

    rootpath = fileparts( ...
        mfilename( 'fullpath' ) ) ;

    opts.geom_file = ...                % domian file
        fullfile(rootpath,...
        'cache','box2d-geom.msh') ;

    opts.jcfg_file = ...                % config file
        fullfile(rootpath,...
        'cache','box2d.jig') ;

    opts.mesh_file = ...                % output file
        fullfile(rootpath,...
        'cache','box2d-mesh.msh') ;

    initjig ;                           % init jigsaw

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

    opts.hfun_hmax = 0.05 ;             % push HFUN limits

    opts.mesh_dims = +2 ;               % 2-dim. simplexes

    opts.optm_qlim = +.95 ;

    opts.mesh_top1 = true ;             % for sharp feat's
    opts.geom_feat = true ;

    mesh = jigsaw  (opts) ;

    if (show > +0)
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

    drawcost(mesh) ;
    end

end

function demo_C(show)
% DEMO-0 --- Simple 2-dimensional examples illustrating the
%   construction of geometry + user-defined mesh-size const-
%   raints.

%------------------------------------ setup files for JIGSAW

    rootpath = fileparts( ...
        mfilename( 'fullpath' ) ) ;

    opts.geom_file = ...                % domain file
        fullfile(rootpath,...
        'cache','box2d-geom.msh') ;

    opts.jcfg_file = ...                % config file
        fullfile(rootpath,...
        'cache','box2d.jig') ;

    opts.mesh_file = ...                % output file
        fullfile(rootpath,...
        'cache','box2d-mesh.msh') ;

    opts.hfun_file = ...                % sizing file
        fullfile(rootpath,...
        'cache','box2d-hfun.msh') ;

    initjig ;                           % init jigsaw

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
                32 ) ;

    ypos = linspace( ...
        min(geom.point.coord(:,2)), ...
        max(geom.point.coord(:,2)), ...
                16 ) ;

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

    if (show > +0)
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

    drawcost(mesh) ;
    end

end

function demo_1(show)
% DEMO-1 --- Simple 3-dimensional examples illustrating the
%   construction of geometry + user-defined mesh-size const-
%   raints.

    demo_D(show);
    demo_E(show);
    demo_F(show);

    if (show > 0)
    set(figure(1),'units','normalized', ...
        'position',[.05,.50,.25,.30]) ;
    set(figure(2),'units','normalized', ...
        'position',[.05,.10,.25,.30]) ;

    set(figure(3),'units','normalized', ...
        'position',[.30,.50,.25,.30]) ;
    set(figure(4),'units','normalized', ...
        'position',[.30,.10,.25,.30]) ;

    set(figure(5),'units','normalized', ...
        'position',[.55,.50,.25,.30]) ;
    set(figure(6),'units','normalized', ...
        'position',[.55,.10,.25,.30]) ;
    end

end

function demo_D(show)
% DEMO-1 --- Simple 3-dimensional examples illustrating the
%   construction of geometry + user-defined mesh-size const-
%   raints.

%------------------------------------ setup files for JIGSAW

    rootpath = fileparts( ...
        mfilename( 'fullpath' ) ) ;

    opts.geom_file = ...                % domain file
        fullfile(rootpath,...
        'cache','box3d-geom.msh') ;

    opts.jcfg_file = ...                % config file
        fullfile(rootpath,...
        'cache','box3d.jig') ;

    opts.mesh_file = ...                % output file
        fullfile(rootpath,...
        'cache','box3d-mesh.msh') ;

    initjig ;                           % init jigsaw

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

    opts.hfun_hmax = 0.08 ;             % push HFUN limits

    opts.mesh_dims = +3 ;               % 3-dim. simplexes

    opts.mesh_top1 = true ;             % for sharp feat's
    opts.geom_feat = true ;

    mesh = jigsaw  (opts) ;

    if (show > +0)
    mask = [];
    mask.tria3 = true(size( ...         % just draw TRIA-3
    mesh.tria3.index,1),1);

    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;

    mask = [];
    mask.tria4 = true(size( ...         % just draw TRIA-4
    mesh.tria4.index,1),1);

    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;
    end

end

function demo_E(show)
% DEMO-1 --- Simple 3-dimensional examples illustrating the
%   construction of geometry + user-defined mesh-size const-
%   raints.

%------------------------------------ setup files for JIGSAW

    rootpath = fileparts( ...
        mfilename( 'fullpath' ) ) ;

    opts.geom_file = ...                % domain file
        fullfile(rootpath,...
        'cache','box3d-geom.msh') ;

    opts.jcfg_file = ...                % config file
        fullfile(rootpath,...
        'cache','box3d.jig') ;

    opts.mesh_file = ...                % output file
        fullfile(rootpath,...
        'cache','box3d-mesh.msh') ;

    initjig ;                           % init jigsaw

%------------------------------------ define JIGSAW geometry

    global JIGSAW_TRIA3_TAG ;

    geom.mshID = 'EUCLIDEAN-MESH';

    geom.point.coord = [    % list of xyz "node" coordinates
        0, 0, 0, 0          % outer cube
        3, 0, 0, 0
        3, 3, 0, 0
        0, 3, 0, 0
        0, 0, 3, 0
        3, 0, 3, 0
        3, 3, 3, 0
        0, 3, 3, 0
        1, 1, 1, 0          % inner flat
        2, 1, 1, 0
        2, 2, 2, 0
        1, 2, 2, 0 ] ;

    geom.tria3.index = [    % list of "trias" between points
        1, 2, 3, 0          % outer cube
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
        4, 5, 1, 0
        9,10,11, 1          % inner flat
        9,11,12, 1 ] ;

    geom.bound.index = [
        1, 1, JIGSAW_TRIA3_TAG
        1, 2, JIGSAW_TRIA3_TAG
        1, 3, JIGSAW_TRIA3_TAG
        1, 4, JIGSAW_TRIA3_TAG
        1, 5, JIGSAW_TRIA3_TAG
        1, 6, JIGSAW_TRIA3_TAG
        1, 7, JIGSAW_TRIA3_TAG
        1, 8, JIGSAW_TRIA3_TAG
        1, 9, JIGSAW_TRIA3_TAG
        1,10, JIGSAW_TRIA3_TAG
        1,11, JIGSAW_TRIA3_TAG
        1,12, JIGSAW_TRIA3_TAG
            ] ;

    savemsh(opts.geom_file,geom);

%------------------------------------ make mesh using JIGSAW

    opts.hfun_hmax = 0.10 ;             % push HFUN limits

    opts.mesh_dims = +3 ;               % 3-dim. simplexes

    opts.mesh_top1 = true ;             % for sharp feat's
    opts.geom_feat = true ;

    mesh = jigsaw  (opts) ;

    if (show > +0)
    mask = [];
    mask.tria3 = true(size( ...         % just draw TRIA-3
    mesh.tria3.index,1),1);

    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;

    mask = [];
    mask.tria4 = true(size( ...         % just draw TRIA-4
    mesh.tria4.index,1),1);
    mask.tria3 = ...
    mesh.tria3.index(:,4)==+1 ;         % also "inner" tri

    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;
    end

end

function demo_F(show)
% DEMO-1 --- Simple 3-dimensional examples illustrating the
%   construction of geometry + user-defined mesh-size const-
%   raints.

%------------------------------------ setup files for JIGSAW

    rootpath = fileparts( ...
        mfilename( 'fullpath' ) ) ;

    opts.geom_file = ...                % domain file
        fullfile(rootpath,...
        'cache','box3d-geom.msh') ;

    opts.jcfg_file = ...                % config file
        fullfile(rootpath,...
        'cache','box3d.jig') ;

    opts.mesh_file = ...                % output file
        fullfile(rootpath,...
        'cache','box3d-mesh.msh') ;

    opts.hfun_file = ...                % sizing file
        fullfile(rootpath,...
        'cache','box3d-hfun.msh') ;

    initjig ;                           % init jigsaw

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
                32 ) ;

    ypos = linspace( ...
        min(geom.point.coord(:,2)), ...
        max(geom.point.coord(:,2)), ...
                16 ) ;

    zpos = linspace( ...
        min(geom.point.coord(:,3)), ...
        max(geom.point.coord(:,3)), ...
                64 ) ;

   [XPOS,YPOS,ZPOS] = ...
        meshgrid(xpos,ypos,zpos) ;

    hfun =-.3*exp(-2.*(XPOS-1.5).^2 ...
                  -2.*(YPOS-1.5).^2 ...
                  -2.*(ZPOS-1.5).^2 ...
            ) + .4 ;

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

    opts.mesh_dims = +3 ;               % 3-dim. simplexes

    opts.mesh_top1 = true ;             % for sharp feat's
    opts.geom_feat = true ;

    mesh = jigsaw  (opts) ;

    if (show > +0)
    mask = [];
    mask.tria3 = true(size( ...         % just draw TRIA-3
    mesh.tria3.index,1),1);

    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;

    mask = [];
    mask.tria4 = true(size( ...         % just draw TRIA-4
    mesh.tria4.index,1),1);

    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;
    end

end

function demo_2(show)
% DEMO-2 --- Build planar meshes for the "lakes" geometry.
%   Compare the performance of the "delaunay" &
%   "delfront" meshing kernals. Show mesh quality metrics.

    name = 'lakes' ;

%------------------------------------ setup files for JIGSAW

    rootpath = fileparts( ...
        mfilename( 'fullpath' )) ;

    opts.geom_file = ...                % domain file
        fullfile(rootpath,...
        'files',[name,'.msh']) ;

    opts.jcfg_file = ...                % config file
        fullfile(rootpath,...
        'cache',[name,'.jig']) ;

    opts.mesh_file = ...                % output file
        fullfile(rootpath,...
        'cache',[name,'.msh']) ;

    initjig ;                           % init jigsaw

%------------------------------------ read GEOM. for display

    geom = loadmsh (opts.geom_file);

    if (show > +0)
    figure ; drawmesh(geom);
    axis image;
    title('INPUT GEOMETRY');
    end

%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delaunay';
    opts.mesh_dims = 2 ;

    opts.mesh_top1 = true ;             % mesh sharp feat.
    opts.geom_feat = true ;

    opts.optm_iter = 0 ;

    opts.hfun_hmax = 0.02 ;

    mesh = jigsaw  (opts) ;

    if (show > +0)
    mask = [];
    mask.tria3 = true(size( ...         % just draw TRIA-3
    mesh.tria3.index,1),1);

    figure ; drawmesh(mesh,mask);
    axis image;
    title('JIGSAW (KERN=delaunay)');

    drawcost(mesh) ;
    end

%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;

    opts.mesh_top1 = true ;             % mesh sharp feat.
    opts.geom_feat = true ;

    opts.optm_iter = 0 ;

    opts.hfun_hmax = 0.02 ;

    mesh = jigsaw  (opts) ;

    if (show > +0)
    mask = [];
    mask.tria3 = true(size( ...         % just draw TRIA-3
    mesh.tria3.index,1),1);

    figure ; drawmesh(mesh,mask);
    axis image;
    title('JIGSAW (KERN=delfront)');

    drawcost(mesh) ;

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

end

function demo_3(show)
% DEMO-3 --- Build surface meshes for the "stanford-bunny"
%   geometry. Compare the performance of the "delaunay" &
%   "delfront" meshing kernals. Show mesh quality metrics.

    name = 'bunny' ;

%------------------------------------ setup files for JIGSAW

    rootpath = fileparts( ...
        mfilename( 'fullpath' )) ;

    opts.geom_file = ...                % domain file
        fullfile(rootpath,...
        'files',[name,'.msh']) ;

    opts.jcfg_file = ...                % config file
        fullfile(rootpath,...
        'cache',[name,'.jig']) ;

    opts.mesh_file = ...                % output file
        fullfile(rootpath,...
        'cache',[name,'.msh']) ;

    initjig ;                           % init jigsaw

%------------------------------------ read GEOM. for display

    geom = loadmsh (opts.geom_file);

    if (show > +0)
    figure ; drawmesh(geom);
    view(0,-110); axis image;
    title('INPUT GEOMETRY');
    end

%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delaunay';
    opts.mesh_dims = 2 ;

    opts.hfun_hmax = 0.03 ;

    mesh = jigsaw  (opts) ;

    if (show > +0)
    figure ; drawmesh(mesh);
    view(0,-110); axis image;
    title('JIGSAW (KERN=delaunay)') ;

    drawcost(mesh) ;
    end

%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;

    opts.hfun_hmax = 0.03 ;

    mesh = jigsaw  (opts) ;

    if (show > +0)
    figure ; drawmesh(mesh);
    view(0,-110); axis image;
    title('JIGSAW (KERN=delfront)') ;

    drawcost(mesh) ;

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

end

function demo_4(show)
% DEMO-4 --- Build _volume meshes for the "stanford-bunny"
%   geometry. Compare the performance of the "delaunay" &
%   "delfront" meshing kernals. Show mesh quality metrics.

    name = 'bunny' ;

%------------------------------------ setup files for JIGSAW

    rootpath = fileparts( ...
        mfilename( 'fullpath' )) ;

    opts.geom_file = ...                % domain file
        fullfile(rootpath,...
        'files',[name,'.msh']) ;

    opts.jcfg_file = ...                % config file
        fullfile(rootpath,...
        'cache',[name,'.jig']) ;

    opts.mesh_file = ...                % output file
        fullfile(rootpath,...
        'cache',[name,'.msh']) ;

    initjig ;                           % init jigsaw

%------------------------------------ read GEOM. for display

    geom = loadmsh (opts.geom_file);

    if (show > +0)
    figure ; drawmesh(geom);
    view(-10,-110); axis image;
    title('INPUT GEOMETRY');
    end

%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delaunay';
    opts.mesh_dims = 3 ;

    opts.hfun_hmax = 0.03 ;

    mesh = jigsaw  (opts) ;

    if (show > +0)
    mask = [];
    mask.tria3 = true(size( ...         % just draw TRIA-3
    mesh.tria3.index,1),1);

    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;
    title('JIGSAW (KERN=delaunay)');

    mask = [];
    mask.tria4 = true(size( ...         % just draw TRIA-4
    mesh.tria4.index,1),1);

    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;
    title('JIGSAW (KERN=delaunay)');

    drawcost(mesh);
    end

%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 3 ;

    opts.hfun_hmax = 0.03 ;

    mesh = jigsaw  (opts) ;

    if (show > +0)
    mask = [];
    mask.tria3 = true(size( ...         % just draw TRIA-3
    mesh.tria3.index,1),1);

    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;
    title('JIGSAW (KERN=delfront)');

    mask = [];
    mask.tria4 = true(size( ...         % just draw TRIA-4
    mesh.tria4.index,1),1);

    figure ; drawmesh(mesh,mask);
    view(-10,-110); axis image;
    title('JIGSAW (KERN=delfront)');

    drawcost(mesh);

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

end

function demo_5(show)
% DEMO-5 --- Build planar meshes for the "airfoil" problem.
%   Impose user-defined mesh-spacing constraints.

    name = 'airfoil' ;

%------------------------------------ setup files for JIGSAW

    rootpath = fileparts( ...
        mfilename( 'fullpath' )) ;

    opts.geom_file = ...                % domain file
        fullfile(rootpath,...
        'files',[name,'.msh']) ;

    opts.jcfg_file = ...                % config file
        fullfile(rootpath,...
        'cache',[name,'.jig']) ;

    opts.mesh_file = ...                % output file
        fullfile(rootpath,...
        'cache',[name,'.msh']) ;

    opts.hfun_file = ...                % sizing file
        fullfile(rootpath,...
        'cache',[name,'-hfun.msh']);

    initjig ;                           % init jigsaw

%------------------------------------ read GEOM. for display

    geom = loadmsh (opts.geom_file);

    if (show > +0)
    figure ; drawmesh(geom);
    axis image;
    title('INPUT GEOMETRY');
    end

%------------------------------------ compute HFUN over GEOM

    xpos = linspace( ...
        min(geom.point.coord(:,1)), ...
        max(geom.point.coord(:,1)), ...
                80 ) ;

    ypos = linspace( ...
        min(geom.point.coord(:,2)), ...
        max(geom.point.coord(:,2)), ...
                40 ) ;

   [XPOS,YPOS] = meshgrid(xpos,ypos) ;

    fun1 = +0.1*(XPOS-.40).^2 + ...
           +2.0*(YPOS-.55).^2 ;

    fun2 = +0.7*(XPOS-.75).^2 + ...
           +0.7*(YPOS-.45).^2 ;

    hfun = min (fun1,fun2) ;

    hmin = 0.01 ; hmax = 0.10 ;

    hmat.value = 0.4 * ...
    max (min (hfun,hmax),hmin) ;

    hmat.mshID = 'EUCLIDEAN-GRID';
    hmat.point.coord{1} = xpos ;
    hmat.point.coord{2} = ypos ;

    savemsh(opts.hfun_file,hmat) ;

%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;

    opts.mesh_top1 = true ;
    opts.geom_feat = true ;

    opts.hfun_scal = 'absolute';
    opts.hfun_hmax = +inf ;
    opts.hfun_hmin = +0.0 ;

   %opts.optm_kern = 'cvt+dqdx';

    mesh = jigsaw  (opts) ;

    if (show > +0)
    figure ; drawmesh(mesh) ;
    axis image;
    title('JIGSAW OUTPUT');

    drawcost(mesh) ;

    set(figure(1),'units','normalized', ...
        'position',[.55,.50,.25,.30]) ;

    set(figure(2),'units','normalized', ...
        'position',[.30,.50,.25,.30]) ;
    set(figure(3),'units','normalized', ...
        'position',[.30,.15,.25,.25]) ;
    end

end

function demo_6(show)
% DEMO-6 --- Build surface meshes for a mechanical bracket.
%   Configure to detect and preserve sharp-features in the
%   input geometry.

    name = 'piece' ;

%------------------------------------ setup files for JIGSAW

    rootpath = fileparts( ...
        mfilename( 'fullpath' )) ;

    opts.geom_file = ...                % domain file
        fullfile(rootpath,...
        'files',[name,'.msh']) ;

    opts.jcfg_file = ...                % config file
        fullfile(rootpath,...
        'cache',[name,'.jig']) ;

    opts.mesh_file = ...                % output file
        fullfile(rootpath,...
        'cache',[name,'.msh']) ;

    initjig ;                           % init jigsaw

%------------------------------------ read GEOM. for display

    geom = loadmsh (opts.geom_file);

    if (show > +0)
    figure ; drawmesh(geom);
    view(-30,+30); axis image;
    title('INPUT GEOMETRY');
    end

%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;

    opts.geom_feat =false ;             % no sharp feat.'s

    opts.hfun_hmax = 0.03 ;

    mesh = jigsaw  (opts) ;

    if (show > +0)
    figure ; drawmesh(mesh);
    view(-30,+30); axis image;
    title('JIGSAW (FEAT=false)');
    end

%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;

    opts.geom_feat = true ;             % do sharp feat.'s
    opts.mesh_top1 = true ;

    opts.hfun_hmax = 0.03 ;

    mesh = jigsaw  (opts) ;

    if (show > +0)
    mask = [];
    mask.edge2 = true(size( ...         % just draw EDGE-2
    mesh.edge2.index,1),1);

    figure ; drawmesh(mesh,mask);
    view(-30,+30); axis image;
    title('JIGSAW (FEAT=true)');

    mask = [];
    mask.tria3 = true(size( ...         % just draw TRIA-3
    mesh.tria3.index,1),1);

    figure ; drawmesh(mesh,mask);
    view(-30,+30); axis image;
    title('JIGSAW (FEAT=true)');

    set(figure(1),'units','normalized',...
        'position',[.55,.50,.25,.30]) ;

    set(figure(2),'units','normalized',...
        'position',[.05,.50,.25,.30]) ;

    set(figure(3),'units','normalized',...
        'position',[.30,.10,.25,.30]) ;
    set(figure(4),'units','normalized',...
        'position',[.30,.50,.25,.30]) ;
    end

end

function demo_7(show)
% DEMO-7 --- Build surface meshes for the "wheel" geometry;
%   defined as a collection of open surfaces.

    name = 'wheel' ;

%------------------------------------ setup files for JIGSAW

    rootpath = fileparts( ...
        mfilename( 'fullpath' )) ;

    opts.geom_file = ...                % domain file
        fullfile(rootpath,...
        'files',[name,'.msh']) ;

    opts.jcfg_file = ...                % config file
        fullfile(rootpath,...
        'cache',[name,'.jig']) ;

    opts.mesh_file = ...                % output file
        fullfile(rootpath,...
        'cache',[name,'.msh']) ;

    initjig ;                           % init jigsaw

%------------------------------------ read GEOM. for display

    geom = loadmsh (opts.geom_file);

    if (show)
    figure ; drawmesh(geom);
    view(+65,+20); axis image;
    title('INPUT GEOMETRY');
    end

%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;

    opts.geom_feat = true ;             % do sharp feat.'s
    opts.mesh_top1 = true ;
    opts.mesh_top2 = true ;

    opts.hfun_hmax = 0.03 ;

    mesh = jigsaw  (opts) ;

    if (show > +0)
    mask = [];
    mask.edge2 = true(size( ...         % just draw EDGE-2
    mesh.edge2.index,1),1);

    figure ; drawmesh(mesh,mask);
    view(+65,+20); axis image;
    title('JIGSAW (FEAT=true)');

    mask = [];
    mask.tria3 = true(size( ...         % just draw TRIA-3
    mesh.tria3.index,1),1);

    figure ; drawmesh(mesh,mask);
    view(+65,+20); axis image;
    title('JIGSAW (FEAT=true)');

    set(figure(1),'units','normalized',...
        'position',[.55,.50,.25,.30]) ;

    set(figure(2),'units','normalized',...
        'position',[.05,.50,.25,.30]) ;
    set(figure(3),'units','normalized',...
        'position',[.30,.50,.25,.30]) ;
    end

end

function demo_8(show)
% DEMO-8 --- re-mesh geometry generated using marching-cubes
%   approach.

    name = 'eight' ;

%------------------------------------ setup files for JIGSAW

    rootpath = fileparts( ...
        mfilename( 'fullpath' )) ;

    opts.geom_file = ...                % domain file
        fullfile(rootpath,...
        'files',[name,'.msh']) ;

    opts.jcfg_file = ...                % config file
        fullfile(rootpath,...
        'cache',[name,'.jig']) ;

    opts.mesh_file = ...                % output file
        fullfile(rootpath,...
        'cache',[name,'.msh']) ;

    initjig ;                           % init jigsaw

%------------------------------------ read GEOM. for display

    geom = loadmsh (opts.geom_file);

    if (show > +0)
    figure ; drawmesh(geom);
    view(+50,+25); axis image;
    title('INPUT (marching cubes)');

    drawcost(geom) ;
    end

%------------------------------------ make mesh using JIGSAW

    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;

    opts.hfun_hmax = 0.03 ;

    mesh = jigsaw  (opts) ;

    if (show > +0)
    mask = [];
    mask.tria3 = true(size( ...         % just draw TRIA-3
    mesh.tria3.index,1),1);

    figure ; drawmesh(mesh,mask);
    view(+50,+25); axis image;
    title('JIGSAW OUTPUT');

    drawcost(mesh);

    set(figure(1),'units','normalized',...
        'position',[.30,.50,.25,.30]) ;
    set(figure(2),'units','normalized',...
        'position',[.30,.10,.25,.30]) ;

    set(figure(3),'units','normalized',...
        'position',[.05,.50,.25,.30]) ;
    set(figure(4),'units','normalized',...
        'position',[.05,.10,.25,.30]) ;
    end

end

function demo_9(show)
% DEMO-9 --- extrude a surface mesh into a prismatic volume
%   representation.

%------------------------------------ setup files for JIGSAW

    rootpath = fileparts( ...
        mfilename( 'fullpath' ) ) ;

    opts.geom_file = ...                % domian file
        fullfile(rootpath,...
        'cache','box2d-geom.msh') ;

    opts.jcfg_file = ...                % config file
        fullfile(rootpath,...
        'cache','box2d.jig') ;

    opts.mesh_file = ...                % output file
        fullfile(rootpath,...
        'cache','box2d-mesh.msh') ;

    initjig ;                           % init jigsaw

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

    base = jigsaw  (opts) ;

%------------------------------------ extrude from 2-surface
    xpos = base.point.coord(:,1) ;
    ypos = base.point.coord(:,2) ;

    base.point.coord(:,4) = 0 ;
    base.point.coord(:,3) = 1. + ...
        .05*(xpos-4.).^2  + ...
        .05*(ypos-3.).^2  ;

    base = rmfield(base,'edge2') ;      % only from TRIA-3

    levs = [1.5; 0.5; 0.0];             % extrude position

    mesh = extrude( ...
        base,levs,-3,0.10);

    if (show > +0)
    figure; drawmesh(mesh);
    end

end




