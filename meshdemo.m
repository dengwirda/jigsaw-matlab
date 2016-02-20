function meshdemo(varargin)
%MESHDEMO run demo problems for JIGSAW.
%
%   MESHDEMO(N) runs the N-TH demo problem. Five demo problems are avail-
%   able:
%
%   - DEMO-1: Build surface meshes for the "stanford-bunny" geometry. Co-
%     mpare the performance of the "delaunay" and "delfront" meshing ker-
%     nals. Generate mesh quality metrics.
%
%   - DEMO-2: Build _volume meshes for the "stanford-bunny" geometry. Co-
%     mpare the performance of the "delaunay" and "delfront" meshing ker-
%     nals. Generate mesh quality metrics.
%
%   - DEMO-3: Build surface meshes for the "fandisk" geometry. Investiga-
%     te the automatic detection and preservation of "sharp" features in 
%     the input geometry.
%
%   - DEMO-4: Build planar meshes for the "lake" geometry. Explore the e-
%     ffect of "topological" constraints.
%
%   - DEMO-5: Build planar meshes for the "airfoil" geometry. Explore the
%     use of non-uniform mesh-size functions.
%
%   See also JIGSAW

%   Darren Engwirda
%   16-Feb-2016
%   d_engwirda@outlook.com

    close all;

    n = 1;

    if (nargin >= 1), n = varargin{1}; end
       
    switch (n)
        case 1, demo1 ;
        case 2, demo2 ;
        case 3, demo3 ;
        case 4, demo4 ;
        case 5, demo5 ;
        
        otherwise
        error('Invalid demo selection!') ;
    end

end

function demo1
% DEMO-1: Build surface meshes for the "stanford-bunny" geometry. Co-
% mpare the performance of the "delaunay" and "delfront" meshing ker-
% nals. Generate mesh quality metrics.

    name = 'bunny' ;

%-- setup files for JIGSAW
    opts.geom_file = ...            % geom file
        ['jigsaw/geo/',name,'.msh'];
    
    opts.jcfg_file = ...            % config file
        ['jigsaw/out/',name,'.jig'];
    
    opts.mesh_file = ...            % output file
        ['jigsaw/out/',name,'.msh'];
  
%-- read GEOM file for display
    geom = readmsh (opts.geom_file);

%-- draw the output
    drawmesh(geom,...
        struct('title','Input geometry',...
            'flips',[3,1,2],'views',[50,10]));
    
%-- meshing options for JIGSAW
    opts.mesh_kern = 'delaunay';
    opts.mesh_dims = 2 ;
    
    opts.hfun_hmax = 0.03 ;
    
%-- build the mesh!
    mesh = jigsaw  (opts) ;
 
%-- draw the output
    drawmesh(mesh,...
        struct('title','JIGSAW output (delaunay)',...
            'flips',[3,1,2],'views',[50,10]));
        
    drawcost(meshcost(mesh)) ;
    
%-- meshing options for JIGSAW
    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;
    
    opts.hfun_hmax = 0.03 ;
    
%-- build the mesh!
    mesh = jigsaw  (opts) ;
 
%-- draw the output
    drawmesh(mesh,...
        struct('title','JIGSAW output (delfront)',...
            'flips',[3,1,2],'views',[50,10]));

    drawcost(meshcost(mesh)) ;
    
    drawnow;
    
    set(figure(1),'units','normalized',...
        'position',[.65,.50,.30,.35]) ;
    
    set(figure(2),'units','normalized',...
        'position',[.05,.50,.30,.35]) ;
    set(figure(4),'units','normalized',...
        'position',[.35,.50,.30,.35]) ;
    
    set(figure(3),'units','normalized',...
        'position',[.05,.05,.30,.35]) ;
    set(figure(5),'units','normalized',...
        'position',[.35,.05,.30,.35]) ;
    
end

function demo2
% DEMO-2: Build _volume meshes for the "stanford-bunny" geometry. Co-
% mpare the performance of the "delaunay" and "delfront" meshing ker-
% nals. Generate mesh quality metrics.

    name = 'bunny' ;

%-- setup files for JIGSAW
    opts.geom_file = ...            % geom file
        ['jigsaw/geo/',name,'.msh'];
    
    opts.jcfg_file = ...            % config file
        ['jigsaw/out/',name,'.jig'];
    
    opts.mesh_file = ...            % output file
        ['jigsaw/out/',name,'.msh'];
  
%-- read GEOM file for display
    geom = readmsh (opts.geom_file);

%-- draw the output
    drawmesh(geom,...
        struct('title','Input geometry',...
            'flips',[3,1,2],'views',[50,10]));
    
%-- meshing options for JIGSAW
    opts.mesh_kern = 'delaunay';
    opts.mesh_dims = 3 ;
    opts.mesh_vol3 = 0.05 ;
    
    opts.hfun_hmax = 0.03 ;
    
%-- build the mesh!
    mesh = jigsaw  (opts) ;
 
%-- draw the output
    drawmesh(mesh,...
        struct('title','JIGSAW output (delaunay)',...
            'flips',[3,1,2],'views',[50,10]));
    
    drawcost(meshcost(mesh)) ;
    
%-- meshing options for JIGSAW
    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 3 ;
    opts.mesh_vol3 = 0.05 ;
    
    opts.hfun_hmax = 0.03 ;
    
%-- build the mesh!
    mesh = jigsaw  (opts) ;
 
%-- draw the output
    drawmesh(mesh,...
        struct('title','JIGSAW output (delfront)',...
            'flips',[3,1,2],'views',[50,10]));

    drawcost(meshcost(mesh)) ;
    
    drawnow;
    
    set(figure(1),'units','normalized',...
        'position',[.65,.50,.30,.35]) ;
    
    set(figure(2),'units','normalized',...
        'position',[.05,.50,.30,.35]) ;
    set(figure(3),'units','normalized',...
        'position',[.05,.50,.30,.35]) ;
    set(figure(6),'units','normalized',...
        'position',[.35,.50,.30,.35]) ;
    set(figure(7),'units','normalized',...
        'position',[.35,.50,.30,.35]) ;
    
    set(figure(4),'units','normalized',...
        'position',[.05,.05,.30,.35]) ;
    set(figure(5),'units','normalized',...
        'position',[.05,.05,.30,.35]) ;
    set(figure(8),'units','normalized',...
        'position',[.35,.05,.30,.35]) ;
    set(figure(9),'units','normalized',...
        'position',[.35,.05,.30,.35]) ;

end

function demo3
% DEMO-3: Build surface meshes for the "fandisk" geometry. Investiga-
% te the automatic detection and preservation of "sharp" features in 
% the input geometry.

    name = 'fandisk' ;

%-- setup files for JIGSAW
    opts.geom_file = ...            % geom file
        ['jigsaw/geo/',name,'.msh'];
    
    opts.jcfg_file = ...            % config file
        ['jigsaw/out/',name,'.jig'];
    
    opts.mesh_file = ...            % output file
        ['jigsaw/out/',name,'.msh'];
  
%-- read GEOM file for display
    geom = readmsh (opts.geom_file);

%-- draw the output
    drawmesh(geom,...
        struct('title','Input geometry',...
            'flips',[3,2,1],'views',[-40,20]));
    
%-- meshing options for JIGSAW
    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;
    
    opts.geom_feat =false ;
    
    opts.hfun_hmax = 0.03 ;
    
%-- build the mesh!
    mesh = jigsaw  (opts) ;
 
%-- draw the output
    drawmesh(mesh,...
        struct('title','JIGSAW output (FEAT.=false)',...
            'flips',[3,2,1],'views',[-40,20]));
    
%-- meshing options for JIGSAW
    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;
    
    opts.geom_feat = true ;
    
    opts.hfun_hmax = 0.03 ;
    
%-- build the mesh!
    mesh = jigsaw  (opts) ;
 
%-- draw the output
    drawmesh(mesh,...
        struct('title','JIGSAW output (FEAT.=true)',...
            'flips',[3,2,1],'views',[-40,20]));
    
    drawnow;
    
    set(figure(1),'units','normalized',...
        'position',[.65,.50,.30,.35]) ;
    
    set(figure(2),'units','normalized',...
        'position',[.05,.50,.30,.35]) ;
    
    set(figure(3),'units','normalized',...
        'position',[.35,.05,.30,.35]) ;
    set(figure(4),'units','normalized',...
        'position',[.35,.50,.30,.35]) ;
    
end

function demo4
% DEMO-4: Build planar meshes for the "lake" geometry. Explore the e-
% ffect of "topological" constraints.

    name = 'lake' ;

%-- setup files for JIGSAW
    opts.geom_file = ...            % geom file
        ['jigsaw/geo/',name,'.msh'];
    
    opts.jcfg_file = ...            % config file
        ['jigsaw/out/',name,'.jig'];
    
    opts.mesh_file = ...            % output file
        ['jigsaw/out/',name,'.msh'];
  
%-- read GEOM file for display
    geom = readmsh (opts.geom_file);

%-- draw the output
    drawmesh(geom,...
        struct('title','Input geometry'));
    
%-- meshing options for JIGSAW
    opts.mesh_kern = 'delaunay';
    opts.mesh_dims = 2 ;
    opts.mesh_top1 =false ;
    
    opts.geom_feat = true ;
    
    opts.hfun_hmax = 0.05 ;
    
%-- build the mesh!
    mesh = jigsaw  (opts) ;
 
%-- draw the output
    drawmesh(mesh,...
        struct('title','JIGSAW output (TOPO.=false)'));
    
%-- meshing options for JIGSAW
    opts.mesh_kern = 'delaunay';
    opts.mesh_dims = 2 ;
    opts.mesh_top1 = true ;
    
    opts.geom_feat = true ;
    
    opts.hfun_hmax = 0.05 ;
    
%-- build the mesh!
    mesh = jigsaw  (opts) ;
 
%-- draw the output
    drawmesh(mesh,...
        struct('title','JIGSAW output (TOPO.=true)'));
    
    drawnow;
    
    set(figure(1),'units','normalized',...
        'position',[.65,.50,.30,.35]) ;
    
    set(figure(2),'units','normalized',...
        'position',[.05,.05,.30,.35]) ;
    set(figure(3),'units','normalized',...
        'position',[.05,.50,.30,.35]) ;
    
    set(figure(4),'units','normalized',...
        'position',[.35,.05,.30,.35]) ;
    set(figure(5),'units','normalized',...
        'position',[.35,.50,.30,.35]) ;

end

function demo5
% DEMO-5: Build planar meshes for the "airfoil" geometry. Explore the
% use of non-uniform mesh-size functions.

    name = 'airfoil' ;

%-- setup files for JIGSAW
    opts.geom_file = ...            % geom file
        ['jigsaw/geo/',name,'.msh'];
    
    opts.jcfg_file = ...            % config file
        ['jigsaw/out/',name,'.jig'];
    
    opts.mesh_file = ...            % output file
        ['jigsaw/out/',name,'.msh'];
  
%-- read GEOM file for display
    geom = readmsh (opts.geom_file);

%-- draw the output
    drawmesh(geom,...
        struct('title','Input geometry'));
    
%-- meshing options for JIGSAW
    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;
    opts.mesh_top1 = true ;
    
    opts.geom_feat = true ;
    
    opts.hfun_hmax = 0.04 ;
    
%-- build the mesh!
    mesh = jigsaw  (opts) ;
 
%-- draw the output
    drawmesh(mesh,...
        struct('title','JIGSAW output'));
    
%-- meshing options for JIGSAW
    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 2 ;
    opts.mesh_top1 = true ;
    
    opts.geom_feat = true ;
    
    opts.hfun_kern = 'delaunay';
    opts.hfun_hmax = 0.04 ;
    opts.hfun_hmin = 0.002;
    opts.hfun_grad = 0.15 ;
    
%-- build the mesh!
    mesh = jigsaw  (opts) ;
 
%-- draw the output
    drawmesh(mesh,...
        struct('title','JIGSAW output'));
    
    drawnow;
    
    set(figure(1),'units','normalized',...
        'position',[.65,.50,.30,.35]) ;
    
    set(figure(2),'units','normalized',...
        'position',[.05,.50,.30,.35]) ;
    set(figure(3),'units','normalized',...
        'position',[.05,.50,.30,.35]) ;
    
    set(figure(4),'units','normalized',...
        'position',[.35,.50,.30,.35]) ;
    set(figure(5),'units','normalized',...
        'position',[.35,.50,.30,.35]) ;

end


