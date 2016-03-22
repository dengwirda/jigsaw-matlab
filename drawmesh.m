function drawmesh(varargin)
%DRAWMESH draw mesh data for JIGSAW.

%
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   21-Mar-2016
%   d_engwirda@outlook.com
%

    mesh = []; opts = [];

    if (nargin >= +1), mesh = varargin{1}; end
    if (nargin >= +2), opts = varargin{2}; end
    
    if ( isempty(mesh))
        error('DRAWMESH: insufficient inputs.');
    end

    ndim = size(mesh.point.coord,2)-1 ;
 
    if (~isempty(opts) && isfield(opts,'flips'))
        mesh.point.coord = ...
            mesh.point.coord(:,opts.flips) ;
    end
    
    fig1 = []; fig2 = []; fig3 = [];
    
    switch (ndim)
        case +2
    %-- draw mesh obj. in R^2
    
        if (isfield(mesh,'edge2') && ~isempty(mesh.edge2))
            
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
                title([opts.title,' (EDGE-2)']);
            end
            set(gcf,'color','w');
            set(gca,'units','normalized','position',[.05,.05,.90,.90]);
        
        end
            
        if (isfield(mesh,'tria3') && ~isempty(mesh.tria3))
            
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
                title([opts.title,' (TRIA-3)']);
            end
            set(gcf,'color','w');
            set(gca,'units','normalized','position',[.05,.05,.90,.90]);
        
        end
            
        case +3
    %-- draw mesh obj. in R^3
    
        if (isfield(mesh,'edge2') && ~isempty(mesh.edge2))
            
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
                title([opts.title,' (EDGE-2)']);
            end
            if (~isempty(opts) && ...
                    isfield(opts,'light'))
                if (opts.light)
                    camlight headlight ; 
                    cameramenu;
                end
            end
            set(gcf,'color','w');
            set(gca,'units','normalized','position',[.05,.05,.90,.90]);
        
        end
            
        if (isfield(mesh,'tria3') && ~isempty(mesh.tria3))
            
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
                title([opts.title,' (TRIA-3)']);
            end
            if (~isempty(opts) && ...
                    isfield(opts,'light'))
                if (opts.light)
                    camlight headlight ; 
                    cameramenu;
                end
            end
            set(gcf,'color','w');
            set(gca,'units','normalized','position',[.05,.05,.90,.90]);
        
        end
        
        if (isfield(mesh,'quad4') && ~isempty(mesh.quad4))
            
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
                title([opts.title,' (QUAD-4)']);
            end
            if (~isempty(opts) && ...
                    isfield(opts,'light'))
                if (opts.light)
                    camlight headlight ; 
                    cameramenu;
                end
            end
            set(gcf,'color','w');
            set(gca,'units','normalized','position',[.05,.05,.90,.90]);
        
        end
        
        if (isfield(mesh,'tria4') && ~isempty(mesh.tria4))
        
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
                title([opts.title,' (TRIA-4)']);
            end
            if (~isempty(opts) && ...
                    isfield(opts,'light'))
                if (opts.light)
                    camlight headlight ; 
                    cameramenu;
                end
            end
            set(gcf,'color','w');
            set(gca,'units','normalized','position',[.05,.05,.90,.90]);
        
        end
        
        otherwise
        error('DRAWMESH: unsupported inputs.' );
        
    end
    
end

function drawedge2(pp,e2,varargin)
%DRAWEDGE2 draw EDGE2 elements.

    ec = [] ;
    
    if (nargin >= +3),ec = varargin{1}; end

    if isempty(ec), ec = [.20,.20,.20]; end
    
    patch('faces',e2,'vertices',pp, ...
        'facecolor','none',...
        'edgecolor',ec,...
        'facealpha',1.,...
        'linewidth',.40) ;
    
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
        'edgelighting','none',...
        'facelighting','flat',...
        'linewidth',.40);
    
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
        'edgelighting','none',...
        'facelighting','flat',...
        'linewidth',.40);
    
end

function fe = surftria3(t4)
%SURFTRIA3 return surface facets from TRIA4 mesh.

    ff = [t4(:,[1,2,3]);
          t4(:,[1,4,2]);
          t4(:,[2,4,3]);
          t4(:,[3,4,1])] ;
      
    [junk,ii,jj] = unique(sort(ff,2),'rows');
    
    ff = ff(ii,:);
    
    ss = zeros(max(jj),1);
    for ip = 1 : size(jj,1)
        ss(jj(ip)) = ss(jj(ip)) + 1;
    end
    fe = ff(ss==+1,:);  % external faces
   %fi = ff(ss~=+1,:);  % internal faces

end

function drawtria4(pp,t4,varargin)
%DRAWTRIA4 draw TRIA4 elements, split based on ti

    if (nargin >= 3)
    ti = varargin{1} ; 
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
   
    ff = surftria3(t4(: ,:));
    fs = surftria3(t4(ti,:));
     
    ee = ismember(fs,ff,'rows'); % common facets
    
    patch('faces',fs( ee,:),'vertices',pp,...
        'facecolor',fe,...
        'edgecolor',ec,...
        'linewidth',.40,...
        'facelighting','flat');
    patch('faces',fs(~ee,:),'vertices',pp,...
        'facecolor',fi,...
        'edgecolor',ei,...
        'linewidth',.40,...
        'edgelighting','none',...
        'facelighting','flat');
    
    fs = surftria3(t4(~ti,:));
    
    ee = ismember(fs,ff,'rows'); % common facets
    
    patch('faces',fs( ee,:),'vertices',pp,...
        'facecolor',fe,...
        'edgecolor','none',...
        'facelighting','flat',...
        'facealpha',+.200);
     
end


