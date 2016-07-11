function drawmesh(mesh,varargin)
%DRAWMESH draw mesh data for JIGSAW.

%---------------------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   06-Jul-2016
%   d_engwirda@outlook.com
%---------------------------------------------------------------------
%

    opts = [] ;

    if (nargin >= +2), opts = varargin{1}; end
    
    if (nargin <= +0 || nargin >= +3)
        error('Incorrect number of arguments!');
    end
    
    if (~meshhas(mesh,'point')) , return ; end
    
    ndim = size(mesh.point.coord,2)-1 ;
 
    if (~isempty(opts) && isfield(opts,'flips'))
        mesh.point.coord = ...
            mesh.point.coord(:,opts.flips) ;
    end
   
    fig1 = [] ; fig2 = [] ; fig3 = [] ;
    
    switch (ndim)
        case +2
    %-- draw mesh obj. in R^2
    
        if (meshhas(mesh,'edge2'))
        %-- draw EDGE2 mesh obj.
            if (isempty(fig1))
                fig1 = figure; 
            else
                figure (fig1);
            end
            drawedge2(mesh.point.coord(:,1:2), ...
                      mesh.edge2.index(:,1:2)) ;
            axis image off ;
            if (~isempty(opts) && ...
                    isfield(opts,'title'))
                title([opts.title,' (TOPO.-1)']);
            end
            set(gcf,'color','w');
            set(gca,'units', ...
                'normalized','position',[.05,.05,.90,.90]);
        end
            
        if (meshhas(mesh,'tria3'))
        %-- draw TRIA3 mesh obj.
            if (isempty(fig2))
                fig2 = figure; 
            else
                figure (fig2);
            end
            drawtria3(mesh.point.coord(:,1:2), ...
                      mesh.tria3.index(:,1:3)) ;
            axis image off ;
            if (~isempty(opts) && ...
                    isfield(opts,'title'))
                title([opts.title,' (TOPO.-2)']);
            end
            set(gcf,'color','w');
            set(gca,'units', ...
                'normalized','position',[.05,.05,.90,.90]);
        end
        
        if (meshhas(mesh,'quad4'))
        %-- draw QUAD4 mesh obj.
            if (isempty(fig2))
                fig2 = figure; 
            else
                figure (fig2);
            end
            drawquad4(mesh.point.coord(:,1:2), ...
                      mesh.quad4.index(:,1:4)) ;
            axis image off ;
            if (~isempty(opts) && ...
                    isfield(opts,'title'))
                title([opts.title,' (TOPO.-2)']);
            end
            set(gcf,'color','w');
            set(gca,'units', ...
                'normalized','position',[.05,.05,.90,.90]);
        
        end
            
        case +3
    %-- draw mesh obj. in R^3
    
        if (meshhas(mesh,'edge2'))
        %-- draw EDGE2 mesh obj.
            if (isempty(fig1))
                fig1 = figure; 
            else
                figure (fig1);
            end
            drawedge2(mesh.point.coord(:,1:3), ...
                      mesh.edge2.index(:,1:2)) ;
            axis image off ;
            if (~isempty(opts) && ...
                    isfield(opts,'views'))
                view(opts.views) ;
            end
            if (~isempty(opts) && ...
                    isfield(opts,'title'))
                title([opts.title,' (TOPO.-1)']);
            end
            if (~isempty(opts) && ...
                    isfield(opts,'light'))
                if (opts.light && ...
                        exist('camlight') ~= 0) % octave!
                    camlight headlight ;
                    lighting flat ;
                    cameramenu ;
                end
            end
            set(gcf,'color','w');
            set(gca,'units', ...
                'normalized','position',[.05,.05,.90,.90]);
        end
            
        if (meshhas(mesh,'tria3'))
        %-- draw TRIA3 mesh obj.
            if (isempty(fig2))
                fig2 = figure; 
            else
                figure (fig2);
            end
            drawtria3(mesh.point.coord(:,1:3), ...
                      mesh.tria3.index(:,1:3)) ;
            axis image off ;
            if (~isempty(opts) && ...
                    isfield(opts,'views'))
                view(opts.views) ;
            end
            if (~isempty(opts) && ...
                    isfield(opts,'title'))
                title([opts.title,' (TOPO.-2)']);
            end
            if (~isempty(opts) && ...
                    isfield(opts,'light'))
                if (opts.light && ...
                        exist('camlight') ~= 0) % octave!
                    camlight headlight ;
                    lighting flat ;
                    cameramenu ;
                end
            end
            set(gcf,'color','w');
            set(gca,'units', ...
                'normalized','position',[.05,.05,.90,.90]);      
        end
        
        if (meshhas(mesh,'quad4'))
        %-- draw QUAD4 mesh obj.
            if (isempty(fig2))
                fig2 = figure; 
            else
                figure (fig2);
            end
            drawquad4(mesh.point.coord(:,1:3), ...
                      mesh.quad4.index(:,1:4)) ;
            axis image off ;
            if (~isempty(opts) && ...
                    isfield(opts,'views'))
                view(opts.views) ;
            end
            if (~isempty(opts) && ...
                    isfield(opts,'title'))
                title([opts.title,' (TOPO.-2)']);
            end
            if (~isempty(opts) && ...
                    isfield(opts,'light'))
                if (opts.light && ...
                        exist('camlight') ~= 0) % octave!
                    camlight headlight ;
                    lighting flat ;
                    cameramenu ;
                end
            end
            set(gcf,'color','w');
            set(gca,'units', ...
                'normalized','position',[.05,.05,.90,.90]);
        end
        
        if (meshhas(mesh,'tria4'))
        %-- draw TRIA4 mesh obj.
            if (isempty(fig3))
                fig3 = figure; 
            else
                figure (fig3);
            end
            drawtria4(mesh.point.coord(:,1:3), ...
                      mesh.tria4.index(:,1:4)) ;
            axis image off ;
            if (~isempty(opts) && ...
                    isfield(opts,'views'))
                view(opts.views) ;
            end
            if (~isempty(opts) && ...
                    isfield(opts,'title'))
                title([opts.title,' (TOPO.-3)']);
            end
            if (~isempty(opts) && ...
                    isfield(opts,'light'))
                if (opts.light && ...
                        exist('camlight') ~= 0) % octave!
                    camlight headlight ;
                    lighting flat ;
                    cameramenu ;
                end
            end
            set(gcf,'color','w');
            set(gca,'units', ...
                'normalized','position',[.05,.05,.90,.90]);
        end
        
        otherwise
        error('DRAWMESH: unsupported inputs.');
        
    end
    
end

function drawedge2(pp,e2,varargin)
%DRAWEDGE2 draw EDGE2 elements.

    ec = [] ;
    
    if (nargin >= +3),ec = varargin{1}; end

    if isempty(ec), ec = [.20,.20,.20]; end

    switch (size(pp,2))
    %-- draw this way for OCTAVE - it doesn't
    %   enjoy alternate LINE() syntax, and/or
    %   degenerate polygons via PATCH()...
        
        case +2
    %-- draw lines in R^2
        xx = [pp(e2(:,1),1), ...
              pp(e2(:,2),1), ...
        NaN*ones(size(e2,1),1)]';
        yy = [pp(e2(:,1),2), ...
              pp(e2(:,2),2), ...
        NaN*ones(size(e2,1),1)]';
        
        line('xdata',xx(:), ...
             'ydata',yy(:), ...
             'color',ec, ...
             'linewidth',1.0);
    
        case +3
    %-- draw lines in R^3
        xx = [pp(e2(:,1),1), ...
              pp(e2(:,2),1), ...
        NaN*ones(size(e2,1),1)]';
        yy = [pp(e2(:,1),2), ...
              pp(e2(:,2),2), ...
        NaN*ones(size(e2,1),1)]';
        zz = [pp(e2(:,1),3), ...
              pp(e2(:,2),3), ...
        NaN*ones(size(e2,1),1)]';
        
        line('xdata',xx(:), ...
             'ydata',yy(:), ...
             'zdata',zz(:), ...
             'color',ec, ...
             'linewidth',1.0);
        
    end
    
end

function drawtria3(pp,t3,varargin)
%DRAWTRIA3 draw TRIA3 elements.

    fc = []; ec = [] ;
    
    if (nargin >= +3),fc = varargin{1}; end
    if (nargin >= +4),ec = varargin{2}; end

    if isempty(ec), ec = [.20,.20,.20]; end
    if isempty(fc), fc = [.95,.95,.50]; end
    
    patch('faces',t3,'vertices',pp, ...
        'facecolor',fc,...
        'edgecolor',ec,...
        'facealpha',1.,...
        'linewidth',0.67);
    
end

function drawquad4(pp,q4,varargin)
%DRAWQUAD4 draw QUAD4 elements.

    fc = []; ec = [] ;
    
    if (nargin >= +3),fc = varargin{1}; end
    if (nargin >= +4),ec = varargin{2}; end

    if isempty(ec), ec = [.20,.20,.20]; end
    if isempty(fc), fc = [.95,.95,.50]; end
    
    patch('faces',q4,'vertices',pp, ...
        'facecolor',fc,...
        'edgecolor',ec,...
        'facealpha',1.,...
        'linewidth',0.67);
    
end

function [fe] = surftria4(t4)
%SURFTRIA4 return surface facets from TRIA4 mesh.

    ff = [t4(:,[1,2,3]);
          t4(:,[1,4,2]);
          t4(:,[2,4,3]);
          t4(:,[3,4,1])] ;
      
   [fj,ii,jj] = unique (sort(ff,2),'rows');
    
    ff = ff(ii,:);
    
    ss = accumarray(jj, ...
        ones(size(jj)),[size(ff,1),1]) ;
    
    fe = ff(ss==+1,:);  % external faces
   %fi = ff(ss~=+1,:);  % internal faces

end

function [fe] = surfhexa8(q8)
%SURFHEXA8 return surface facets from HEXA8 mesh.

    ff = [q8(:,[1,2,3,4]);
          q8(:,[1,2,3,4]);
          q8(:,[1,2,3,4]);
          q8(:,[1,2,3,4]);
          q8(:,[1,2,3,4]);
          q8(:,[1,2,3,4])] ;

   [fj,ii,jj] = unique (sort(ff,2),'rows');
    
    ff = ff(ii,:);
    
    ss = accumarray(jj, ...
        ones(size(jj)),[size(ff,1),1]) ;
    
    fe = ff(ss==+1,:);  % external faces
   %fi = ff(ss~=+1,:);  % internal faces
      
end

function drawtria4(pp,t4,varargin)
%DRAWTRIA4 draw TRIA4 elements.

    if (nargin >= 3)
        ti = varargin{+1} ; 
    else
%-- calc. default R^3 splitting plane        
        ip = unique(t4(:));
        
        dc = max(pp(ip,:),[],1) - ...
             min(pp(ip,:),[],1) ;
       [dd,id] = min( dc) ;
         
        ok = false(size(pp,1),1);
        ok(ip) = pp(ip,id) < ...
            mean(pp(ip,id)) + .20*dd;
        
        ti = all(ok(t4),2);     
    end

    ec = [.20,.20,.20];
    ei = [.25,.25,.25];
    fe = [.95,.95,.50];
    fi = [.95,.95,.90];

    f1 = surftria4(t4( ti,:));
    f2 = surftria4(t4(~ti,:));
    
    c1 = ismember(sort(f1,2), ...
                  sort(f2,2),'rows'); % common facets
    c2 = ismember(sort(f2,2), ...
                  sort(f1,2),'rows');
    
%-- draw external surface
    patch('faces',f1(~c1,:),'vertices',pp,...
        'facecolor',fe,...
        'edgecolor',ec,...
        'linewidth',0.67,...
        'facealpha',1.0);
%-- draw internal surface
    patch('faces',f1( c1,:),'vertices',pp,...
        'facecolor',fi,...
        'edgecolor',ei,...
        'linewidth',0.67,...
        'facealpha',1.0);
%-- draw transparent part
    patch('faces',f2(~c2,:),'vertices',pp,...
        'facecolor',fe,...
        'edgecolor','none',...
        'linewidth',0.67,...
        'facealpha',0.2);

end


