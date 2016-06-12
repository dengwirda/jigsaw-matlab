function meshdemo(varargin)
%MESHDEMO run demo problems for JIGSAW.
%
%   MESHDEMO(N) runs the N-TH demo problem. Seven demo problems are av-
%   ailable:
%
%   - DEMO-1: Build surface meshes for the "stanford-bunny" geometry. 
%     Compare the performance of the "delaunay" and "delfront" meshing 
%     kernals. Generate mesh quality metrics.
%
%   - DEMO-2: Build _volume meshes for the "stanford-bunny" geometry. 
%     Compare the performance of the "delaunay" and "delfront" meshing 
%     kernals. Generate mesh quality metrics.
%
%   - DEMO-3: Build surface meshes for the "fandisk" geometry. Investi-
%     gate the automatic detection and preservation of "sharp" features 
%     in the input geometry.
%
%   - DEMO-4: Build planar meshes for the "lake" geometry. Explore the 
%     effect of "topological" constraints.
%
%   - DEMO-5: Build planar meshes for the "airfoil" geometry. Explore 
%     the use of non-uniform mesh-size functions.
%
%   - DEMO-6: Build surface- and volume-meshes for an analytic geometry 
%     using iso-surface extraction (case 1).
%
%   - DEMO-7: Build surface- and volume-meshes for an analytic geometry 
%     using iso-surface extraction (case 2).
%
%   See also JIGSAW

%---------------------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   11-Jun-2016
%   d_engwirda@outlook.com
%---------------------------------------------------------------------
%

    close all;

    n = 1;

    if (nargin >= 1), n = varargin{1}; end
       
    switch (n)
        case 1, demo1 ;
        case 2, demo2 ;
        case 3, demo3 ;
        case 4, demo4 ;
        case 5, demo5 ;
        case 6, demo6 ;
        case 7, demo7 ;
        
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

function demo6
% DEMO-6: Build surface- and volume-meshes for an analytic geometry using
% iso-surface extraction (case 1).

    name = 'eight';

   [y,x,z] = ndgrid(linspace(-.75,+.75,2^7), ...
                    linspace(-.10,+2.1,2^7), ...
                    linspace(-.20,+.20,2^7)) ;
              
    F = (x.*(x-1.).^2.*(x-2.) + y.^2).^2 + z.^2 ;
    
   [f,v] = isosurface(x,y,z,F,.020);
   
    geom.point.coord = [v,zeros(size(v,1),1)];
    geom.tria3.index = [f,zeros(size(f,1),1)];
   
%-- setup files for JIGSAW
    opts.geom_file = ...            % geom file
        ['jigsaw/geo/',name,'.msh'];
    
    opts.jcfg_file = ...            % config file
        ['jigsaw/out/',name,'.jig'];
    
    opts.mesh_file = ...            % output file
        ['jigsaw/out/',name,'.msh'];
 
    
    makemsh(opts.geom_file,geom) ;
    
%-- draw the output
    drawmesh(geom,...
        struct('title','Input surface','views',[-30,+30]));
    
%-- meshing options for JIGSAW
    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 3 ;
    
    opts.mesh_top2 = true ;
    
    opts.hfun_hmax = 0.04 ;
    
%-- build the mesh!
    mesh = jigsaw  (opts) ;
 
%-- draw the output
    drawmesh(mesh,...
        struct('title','JIGSAW output','views',[-30,+30]));
    
    drawnow;
    
    set(figure(1),'units','normalized',...
        'position',[.05,.50,.30,.35]) ;
    set(figure(2),'units','normalized',...
        'position',[.35,.50,.30,.35]) ;
    set(figure(3),'units','normalized',...
        'position',[.65,.50,.30,.35]) ;
    
end

function demo7
% DEMO-7: Build surface- and volume-meshes for an analytic geometry using
% iso-surface extraction (case 2).

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
   
%-- setup files for JIGSAW
    opts.geom_file = ...            % geom file
        ['jigsaw/geo/',name,'.msh'];
    
    opts.jcfg_file = ...            % config file
        ['jigsaw/out/',name,'.jig'];
    
    opts.mesh_file = ...            % output file
        ['jigsaw/out/',name,'.msh'];
 
    
    makemsh(opts.geom_file,geom) ;
    
%-- draw the output
    drawmesh(geom,...
        struct('title','Input surface'));
    
%-- meshing options for JIGSAW
    opts.mesh_kern = 'delfront';
    opts.mesh_dims = 3 ;
    
    opts.mesh_top2 = true ;
    
    opts.hfun_hmax = 0.04 ;
    
%-- build the mesh!
    mesh = jigsaw  (opts) ;
 
%-- draw the output
    drawmesh(mesh,...
        struct('title','JIGSAW output'));
    
    drawnow;
    
    set(figure(1),'units','normalized',...
        'position',[.05,.50,.30,.35]) ;
    set(figure(2),'units','normalized',...
        'position',[.35,.50,.30,.35]) ;
    set(figure(3),'units','normalized',...
        'position',[.65,.50,.30,.35]) ;
    
end


