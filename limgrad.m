function [ffun] = limgrad(varargin)
%LIMGRAD apply gradient-limits to a mesh object.
%   FFUN = LIMGRAD(FFUN,DFDX) returns a modified mesh object
%   FFUN that satisfies 'gradient-limits', such that 
%   |GRAD(FFUN)| < DFDX for all mesh / grid elements. 
%
%   FFUN = LIMGRAD(... ,OPTS) specifies an additional set of
%   user-defined options via the struct OPTS, including:
%
% - OPTS.ITER = {+100} -- max. allowable global iterations.
%
% - OPTS.SLVR = {'CELL-LIMITER'}, 'EDGE-LIMITER' -- select
%   solver kind: 'CELL-LIMITER' implements a multi-dimensi-
%   onal, cell-based solver for the Eikonal equation. This
%   scheme typically generates smooth output, free of grid-
%   based artefacts. 'EDGE-LIMITER' is an alternative, low-
%   order method provided for backwards compatibility. 
%
% - OPTS.RTOL = {+1.0E-03} relative tolerance, controlling
%   algorithm convergence. Iteration is continued until 
%   ABS(dF)./MAX(ABS(FF),OPTS.ATOL) <= OPTS.RTOL, where dF
%   is the local delta in a given update.
%
% - OPTS.ATOL = {+1.0E-08} absolute tolerance, controlling
%   convergence norm scaling, as per the expressions above.  
%
%   See also LIMMESH, LIMEDGE

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   02-Aug-2018
%   de2363@columbia.edu
%-----------------------------------------------------------
%

    DFDX = +.25; opts = [] ;

    if (nargin>=+1), ffun = varargin{1}; end
    if (nargin>=+2), DFDX = varargin{2}; end
    if (nargin>=+3), opts = varargin{3}; end
    
   [opts] = setopts (opts) ;
   
    if (~isstruct (ffun) || ...
        ~isnumeric(DFDX) || ...
        ~isstruct (opts) )
    error('limmesh:incorrectInputClass', ...
        'Incorrect input class.') ;
    end
   
    if (~isfield(ffun,'mshID'))
    error('limmesh:incorrectMeshObject', ...
        'Incorrect mesh object.') ;
    end
    
   [flag] = certify (ffun) ;
   
    switch (upper(ffun.mshID) )
%--------------------------------- setup EUCLIDEAN-MESH obj.
    case 'EUCLIDEAN-MESH'

        pp = [] ; e2 = [] ; t3 = [] ;
        q4 = [] ; t4 = [] ; h8 = [] ;

    %--------------------------- build mesh topology
        if (meshhas(ffun,'point'))
            pp = ffun.point.coord(:,1:end-1);
        end
        if (meshhas(ffun,'edge2'))
            e2 = ffun.edge2.index(:,1:end-1);
        end
        if (meshhas(ffun,'tria3'))
            t3 = ffun.tria3.index(:,1:end-1);
        end
        if (meshhas(ffun,'quad4'))
            q4 = ffun.quad4.index(:,1:end-1);
        end
        if (meshhas(ffun,'tria4'))
            t4 = ffun.tria4.index(:,1:end-1);
        end
        if (meshhas(ffun,'hexa8'))
            h8 = ffun.hexa8.index(:,1:end-1);
        end

        if (strcmpi(...
            opts.slvr,'edge-limiter'))
        
        if (meshhas(ffun,'value'))
    %--------------------------- call eikonal solver
       [ffun.value] = reshape(setedge( ...
            pp,e2,t3,q4,t4,h8, ...
        ffun.value(:),DFDX,opts),size(ffun.value)) ;
        end
        
        else
        
        if (meshhas(ffun,'value'))
    %--------------------------- call eikonal solver
       [ffun.value] = reshape(limmesh( ...
            pp,e2,t3,q4,t4,h8, ...
        ffun.value(:),DFDX,opts),size(ffun.value)) ; 
        end
        
        end
 
%--------------------------------- setup ELLIPSOID-MESH obj.
    case 'ELLIPSOID-MESH'
    
        pp = [] ; e2 = [] ; t3 = [] ;
        q4 = [] ; t4 = [] ; h8 = [] ;

    %--------------------------- build mesh geometry
        if (meshhas(ffun,'point'))
            pa = ffun.point.coord(:,1:end-1);
        
            ax = pa(:,1); ay = pa(:,2);
        
            if (length(ffun.radii) == +3)
                    
            rx = ffun.radii (1);
            ry = ffun.radii (2);
            rz = ffun.radii (3);

            else
            
            rx = ffun.radii (1);
            ry = ffun.radii (1);
            rz = ffun.radii (1);
            
            end
            
            xx = rx*cos(ax).*cos(ay) ;
            yy = ry*sin(ax).*cos(ay) ;
            zz = rz*sin(ay);
            
            pp = [xx(:),yy(:),zz(:)] ;
        end  
        
    %--------------------------- build mesh topology
        if (meshhas(ffun,'edge2'))
            e2 = ffun.edge2.index(:,1:end-1);
        end
        if (meshhas(ffun,'tria3'))
            t3 = ffun.tria3.index(:,1:end-1);
        end
        if (meshhas(ffun,'quad4'))
            e2 = ffun.quad4.index(:,1:end-1);
        end  
           
        if (strcmpi(...
            opts.slvr,'edge-limiter'))
        
        if (meshhas(ffun,'value'))
    %--------------------------- call eikonal solver
       [ffun.value] = reshape(setedge( ...
            pp,e2,t3,q4,t4,h8, ...
        ffun.value(:),DFDX,opts),size(ffun.value)) ;
        end
        
        else
        
        if (meshhas(ffun,'value'))
    %--------------------------- call eikonal solver
       [ffun.value] = reshape(limmesh( ...
            pp,e2,t3,q4,t4,h8, ...
        ffun.value(:),DFDX,opts),size(ffun.value)) ; 
        end
        
        end     
    
%--------------------------------- setup EUCLIDEAN-GRID obj.
    case 'EUCLIDEAN-GRID'
    
        pp = [] ; e2 = [] ; t3 = [] ;
        q4 = [] ; t4 = [] ; h8 = [] ;

        if (meshhas(ffun,'point'))
            switch (length(ffun.point.coord))
            case +2
    %--------------------------- build mesh geometry
               [xx,yy] = meshgrid  ( ...
                ffun.point.coord{1}, ...
                ffun.point.coord{2}) ;
                
                pp = [xx(:),yy(:)] ;
                
    %--------------------------- build mesh topology
                n1 = size(xx,1);
                n2 = size(xx,2);
                nt = (n1-1)*(n2-1) ;
                q4 = ones(nt,4);
                
                for jj = +1:n2-1
       
                nn = (jj-1)*(n1-1) ;

                q4(nn+1:nn+n1-1,:)=[ ...
                (1:n1-1)'+(jj-1)*n1, ...
                (2:n1-0)'+(jj-1)*n1, ...
                (2:n1-0)'+(jj-0)*n1, ...
                (1:n1-1)'+(jj-0)*n1] ;    
                    
                end
                
                case +3
    %--------------------------- build mesh geometry
               [xx,yy,zz] = ndgrid ( ...
                ffun.point.coord{1}, ...
                ffun.point.coord{2}, ...
                ffun.point.coord{3}) ;
                
                pp = [xx(:),yy(:),zz(:)] ;
 
    %--------------------------- build mesh topology               
                n1 = size(xx,1);
                n2 = size(xx,2);
                n3 = size(xx,3);
                nt = (n1-1)*(n2-1)*(n3-1);
               %h8 = ones(nt,8);
                
            end          
        end
    
        if (strcmpi(...
            opts.slvr,'edge-limiter'))
        
        if (meshhas(ffun,'value'))
    %--------------------------- call eikonal solver
       [ffun.value] = reshape(setedge( ...
            pp,e2,t3,q4,t4,h8, ...
        ffun.value(:),DFDX,opts),size(ffun.value)) ;
        end
        
        else
        
        if (meshhas(ffun,'value'))
    %--------------------------- call eikonal solver
       [ffun.value] = reshape(limmesh( ...
            pp,e2,t3,q4,t4,h8, ...
        ffun.value(:),DFDX,opts),size(ffun.value)) ; 
        end
        
        end
    
%--------------------------------- setup ELLIPSOID-GRID obj.
    case 'ELLIPSOID-GRID'
    
        pp = [] ; e2 = [] ; t3 = [] ;
        q4 = [] ; t4 = [] ; h8 = [] ;

        if (meshhas(ffun,'point'))
            switch (length(ffun.point.coord))
            case +2
    %--------------------------- build mesh geometry
               [ax,ay] = meshgrid  ( ...
                ffun.point.coord{1}, ...
                ffun.point.coord{2}) ;
                
                if (length(ffun.radii) == +3)
                
                rx = ffun.radii (1);
                ry = ffun.radii (2);
                rz = ffun.radii (3);

                else
                
                rx = ffun.radii (1);
                ry = ffun.radii (1);
                rz = ffun.radii (1);
                
                end
                
                xx = rx*cos(ax).*cos(ay) ;
                yy = ry*sin(ax).*cos(ay) ;
                zz = rz*sin(ay);
                
                pp = [xx(:),yy(:),zz(:)] ;
                
    %--------------------------- build mesh topology
                n1 = size(xx,1);
                n2 = size(xx,2);
                nt = (n1-1)*(n2-0) ;
                q4 = ones(nt,4);
                
                for jj = +1:n2-1
       
                nn = (jj-1)*(n1-1) ;

                q4(nn+1:nn+n1-1,:)=[ ...
                (1:n1-1)'+(jj-1)*n1, ...
                (2:n1-0)'+(jj-1)*n1, ...
                (2:n1-0)'+(jj-0)*n1, ...
                (1:n1-1)'+(jj-0)*n1] ;    
                    
                end
                
                nn = (n2-1)*(n1-1) ;

                q4(nn+1:nn+n1-1,:)=[ ...
                (1:n1-1)'+(n2-1)*n1, ...
                (2:n1-0)'+(n2-1)*n1, ...
                (2:n1-0)'+(   0)*n1, ...
                (1:n1-1)'+(   0)*n1] ;
                
            end          
        end
    
        if (ay(n1,1) > ay(+1,1))
    %--------------------------- setup caps at poles
        DY = ay(2:n1-0,1)-ay(1:n1-1,1) ;
        
        Z0 = rz*sin(-.5*pi+2.5*DY(  +1)) ;
        Z1 = rz*sin(+.5*pi-2.5*DY(n1-1)) ;
        
        link{ 1} = find(pp(:,3) <= Z0) ;
        link{ 2} = find(pp(:,3) >= Z1) ;
        
        else
    %--------------------------- setup caps at poles
        DY = ay(1:n1-1,1)-ay(2:n1-0,1) ;
        
        Z0 = rz*sin(-.5*pi+2.5*DY(n1-1)) ;
        Z1 = rz*sin(+.5*pi-2.5*DY(  +1)) ;
        
        link{ 1} = find(pp(:,3) <= Z0) ;
        link{ 2} = find(pp(:,3) >= Z1) ;
        
        end
    
        if (strcmpi(...
            opts.slvr,'edge-limiter'))
        
        if (meshhas(ffun,'value'))
    %--------------------------- call eikonal solver
       [ffun.value] = reshape(setedge( ...
            pp,e2,t3,q4,t4,h8, ...
        ffun.value(:),DFDX,opts),size(ffun.value)) ;
        end
        
        else
        
        if (meshhas(ffun,'value'))
    %--------------------------- call eikonal solver
       [ffun.value] = reshape(limmesh( ...
            pp,e2,t3,q4,t4,h8,ffun.value(:), ...
        DFDX,opts,@setbnds,link),size(ffun.value)) ; 
        end
        
        end
    
    end

end

function [ff] = setbnds(ff,li)
%SETBNDS implement a very low-order patch-based BC at linked
%sets of vertices. 

    for il = 1 : length(li)
    
    ff(li{il}) = min(ff(li{il})) ;
    
    end

end

function [ff] =  ...
    setedge(pp,e2,t3,q4,t4,h8,ff,DF,OP)
%SETEDGE build the mesh adj.-graph for the edge-based solver

    IT = OP.iter;

%------------------------------- build the edge list
    if (~isempty(t3))
        e2 = [e2; ...
        t3(:,[1,2]); t3(:,[2,3]);...
        t3(:,[3,1]); ...
             ];
        t3 = [] ;
    end
    if (~isempty(q4))
        e2 = [e2; ...
        q4(:,[1,2]); q4(:,[2,3]);...
        q4(:,[3,4]); q4(:,[4,1]);...
             ];
        q4 = [] ;
    end   
    if (~isempty(t4))
        e2 = [e2; ...
        t4(:,[1,2]); t4(:,[2,3]);...
        t4(:,[3,1]); t4(:,[1,4]);...
        t4(:,[2,4]); t4(:,[3,4]);...
             ];
        t4 = [] ;
    end
    
    e2 = unique2(e2) ;
    
%------------------------------- call eikonal solver
    el = sqrt(sum((pp(e2(:,2),:) ...
                 - pp(e2(:,1),:) ...
         ) .^ 2, 2)) ;
    
    ff = limedge(e2,el,ff,DF,IT) ;

end

function [op] = setopts(op)
%SETOPTS setup default user-defined options in the OP struct

    if (~isfield(op,'slvr'))
        op.slvr = 'cell-limiter' ;
    else
    if (~strcmpi(op.slvr,'edge-limiter') && ...
        ~strcmpi(op.slvr,'cell-limiter') )
        error( ...
    'limgrad:invalidOption','Invalid SLVR.') ; 
    end
    end
    
    if (~isfield(op,'iter'))
        op.iter = +250;
    else
    if (~isnumeric(op.iter))
        error('limgrad:incorrectInputClass', ...
            'Incorrect input class.');
    end
    if (numel(op.iter)~= +1)
        error('limgrad:incorrectDimensions', ...
            'Incorrect input dimensions.') ;    
    end
    if (op.iter <= +0)
        error('limgrad:invalidOptionValues', ...
            'Invalid OPT.ITER selection.') ;
    end
    end
    
    if (~isfield(op,'rtol'))
        op.rtol  = +1.0E-03;
    else
    if (~isnumeric(op.rtol))
        error('limgrad:incorrectInputClass', ...
            'Incorrect input class.');
    end
    if (numel(op.rtol)~= +1)
        error('limgrad:incorrectDimensions', ...
            'Incorrect input dimensions.') ;    
    end
    if (op.rtol <= +0.0E+00)
        error('limgrad:invalidOptionValues', ...
            'Invalid OPT.RTOL selection.') ;
    end
    end
    
    if (~isfield(op,'atol'))
        op.atol  = +1.0E-08;
    else
    if (~isnumeric(op.atol))
        error('limgrad:incorrectInputClass', ...
            'Incorrect input class.');
    end
    if (numel(op.atol)~= +1)
        error('limgrad:incorrectDimensions', ...
            'Incorrect input dimensions.') ;    
    end
    if (op.atol <= +0.0E+00)
        error('limgrad:invalidOptionValues', ...
            'Invalid OPT.ATOL selection.') ;
    end
    end
   
end



