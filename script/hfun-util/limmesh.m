function [ff,ok] = limmesh( ...
        pp,e2,t3,q4,t4,h8,ff,varargin)
%LIMMESH gradient-limiting of a discrete function defined on 
%an unstructured mesh embedded in R^d.
%   [FL] = LIMMESH(PP,E2,T3,Q4,T4,H8,FF) returns the limited
%   function FL, stored at the vertices of the mesh defined
%   by the NP-by-ND vertex array PP and the topology arrays
%   {E2,T3,Q4,T4,H8}, where each represents the indexing as-
%   sociated with the various EDGE-2, TRIA-3, QUAD-4, TRIA-4
%   and HEXA-8 cells in the mesh. The indexing arrays can be
%   empty if no cells of given type exist.
%   [FL] = LIMMESH(..., DFDX) defines the gradient limiting 
%   value DFDX, leading to |GRAD(FL)| <= DFDX for all cells 
%   in the mesh. DFDX = 0.25 is set as the default limit.
%
%   See also LIMGRAD, LIMEDGE

%   This routine implements a quasi-fast-marching method for
%   solutions to the Eikonal equation in R^d. Calls to each 
%   cell 'limiter' bound local vertex values based on local
%   gradient-limited semi-lagrangian trajectories. All cells 
%   adjacent to 'active' vertices are iteratively reexamined
%   and updated until gradient constraints are satisfied.

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   02-Aug-2018
%   de2363@columbia.edu
%-----------------------------------------------------------
%

    DFDX = +0.25; opts = [] ; 
    bfun =   [] ; args = {} ;
    
%---------------------------------------------- extract args
    if (nargin>=+8), DFDX = varargin{1}; end
    if (nargin>=+9), opts = varargin{2}; end
    if (nargin>=10), bfun = varargin{3}; end
    if (nargin>=11), args = varargin(4:end); end

   [opts] =  setopts (opts) ;

%---------------------------------------------- basic checks
    if (~isnumeric(pp) || ...
        ~isnumeric(e2) || ...
        ~isnumeric(t3) || ...
        ~isnumeric(q4) || ...
        ~isnumeric(t4) || ...
        ~isnumeric(h8) || ...
        ~isnumeric(ff) )
    error('limmesh:incorrectInputClass', ...
        'Incorrect input class.') ;
    end
    
    if (ndims(pp) ~= 2 || ...
        ndims(ff) ~= 2 )
    error('limmesh:incorrectDimensions', ...
        'Incorrect input dimensions.') ;    
    end
    if (size(pp,2) < 2 || ...
        size(ff,2)~= 1 )
    error('limmesh:incorrectDimensions', ...
        'Incorrect input dimensions.') ;
    end
    
%---------------------------------------------- test indices
    np = size(pp,1) ;
    
    if ( ~isempty(e2) )
    if (ndims(e2) ~= 2)
    error('limmesh:incorrectDimensions', ...
        'Incorrect input dimensions.') ;
    end
    if (size(e2,2) < 2)
    error('limmesh:incorrectDimensions', ...
        'Incorrect input dimensions.') ;
    end
    if (min(min(e2(:,1:2))) < +1 || ...
            max(max(e2(:,1:2))) > np )
    error('limmesh:invalidMeshIndexing', ...
        'Invalid mesh indexing data.') ;
    end
    end
    
    if ( ~isempty(t3) )
    if (ndims(t3) ~= 2)
    error('limmesh:incorrectDimensions', ...
        'Incorrect input dimensions.') ;
    end
    if (size(t3,2) < 3)
    error('limmesh:incorrectDimensions', ...
        'Incorrect input dimensions.') ;
    end
    if (min(min(t3(:,1:3))) < +1 || ...
            max(max(t3(:,1:3))) > np )
    error('limmesh:invalidMeshIndexing', ...
        'Invalid mesh indexing data.') ;
    end
    end

    if ( ~isempty(q4) )
    if (ndims(q4) ~= 2)
    error('limmesh:incorrectDimensions', ...
        'Incorrect input dimensions.') ;
    end
    if (size(q4,2) < 4)
    error('limmesh:incorrectDimensions', ...
        'Incorrect input dimensions.') ;
    end    
    if (min(min(q4(:,1:4))) < +1 || ...
            max(max(q4(:,1:4))) > np )
    error('limmesh:invalidMeshIndexing', ...
        'Invalid mesh indexing data.') ;
    end
    end
    
    if ( ~isempty(t4) )
    if (ndims(t4) ~= 2)
    error('limmesh:incorrectDimensions', ...
        'Incorrect input dimensions.') ;
    end
    if (size(t4,2) < 4)
    error('limmesh:incorrectDimensions', ...
        'Incorrect input dimensions.') ;
    end
    if (min(min(t4(:,1:4))) < +1 || ...
            max(max(t4(:,1:4))) > np )
    error('limmesh:invalidMeshIndexing', ...
        'Invalid mesh indexing data.') ;
    end
    end
 
    if ( ~isempty(h8) )
    if (ndims(h8) ~= 2)
    error('limmesh:incorrectDimensions', ...
        'Incorrect input dimensions.') ;
    end
    if (size(h8,2) < 8)
    error('limmesh:incorrectDimensions', ...
        'Incorrect input dimensions.') ;
    end   
    if (min(min(h8(:,1:8))) < +1 || ...
            max(max(h8(:,1:8))) > np )
    error('limmesh:invalidMeshIndexing', ...
        'Invalid mesh indexing data.') ;
    end
    end

%---------------------------------------------- update masks
    E2 = true(size(e2,1),1) ;
    T3 = true(size(t3,1),1) ;
    Q4 = true(size(q4,1),1) ;
    T4 = true(size(t4,1),1) ;
    H8 = true(size(h8,1),1) ;
    
%---------------------------------------------- a fast-march
    for iter = +1:opts.iter

        fi = ff ;

        if (any(E2))
    %-- limiter on EDGE-2 elements
            [ff] = ...
        limit_edge_2(pp,e2(E2,:),ff,DFDX,opts) ;
        end
        
        if (any(T3))
    %-- limiter on TRIA-3 elements
            [ff] = ...
        limit_tria_3(pp,t3(T3,:),ff,DFDX,opts) ;
        end
        
        if (any(Q4))
    %-- limiter on QUAD-4 elements
            [ff] = ...
        limit_quad_4(pp,q4(Q4,:),ff,DFDX,opts) ;
        end
        
        %{
        if (any(T4))
    %-- limiter on TRIA-4 elements
            [ff] = ...
        limit_tria_4(pp,t4(T4,:),ff,DFDX,opts) ;
        end
        
        if (any(H8))
    %-- limiter on HEXA-8 elements
            [ff] = ...
        limit_hexa_8(pp,h8(H8,:),ff,DFDX,opts) ;
        end
        %}

        if (~isempty(bfun))
    %-- apply user-defined BC fun.
           [ff] = feval(bfun,ff,args{:}) ;
        end

    %-- calc. relative change in F 
        df = abs(ff-fi);
        df = df./ max(abs(ff),opts.atol) ;
        
    %-- mark cells adj. to updates
        av = df > opts.rtol;
        
        if (~isempty(e2))
        E2 = any(av(e2),2) ;
        end
        
        if (~isempty(t3))
        T3 = any(av(t3),2) ;
        end
        
        if (~isempty(q4))
        Q4 = any(av(q4),2) ;
        end
        
        if (~isempty(t4))
        T4 = any(av(t4),2) ;
        end
        
        if (~isempty(h8))
        H8 = any(av(h8),2) ;
        end
  
        if (max(df) <= opts.rtol), break ; end
        
    end

    ok = (iter < opts.iter) ;

end

function [ff] = limit_edge_2(pp,e2,ff,DFDX,opts)
%LIMIT-EDGE-2 local Eikonal solver for EDGE-2 cells.

    f0 = min(ff(e2),[],2);
    
    up = f0<ff(e2(:,2),:);

    fb = local_edge_2( ...
        pp,e2(up,:),ff,  [1,2],DFDX) ;
        
    ff = limit_vals_k(ff,fb,e2(up,1));
    
    up = f0<ff(e2(:,1),:);
    
    fb = local_edge_2( ...
        pp,e2(up,:),ff,  [2,1],DFDX) ;
        
    ff = limit_vals_k(ff,fb,e2(up,1));

end

function [ff] = limit_tria_3(pp,t3,ff,DFDX,opts)
%LIMIT-TRIA-3 local Eikonal solver for TRIA-3 cells.
    
    f0 = min(ff(t3),[],2);
    
    up = f0<ff(t3(:,3),:); 

    fb = local_tria_3( ...
        pp,t3(up,:),ff,[1,2,3],DFDX) ;
      
    ff = limit_vals_k(ff,fb,t3(up,3));
                   
    up = f0<ff(t3(:,2),:);
                 
    fb = local_tria_3(  ...
        pp,t3(up,:),ff,[3,1,2],DFDX) ;
                 
    ff = limit_vals_k(ff,fb,t3(up,2));
           
    up = f0<ff(t3(:,1),:);
    
    fb = local_tria_3(  ...
        pp,t3(up,:),ff,[2,3,1],DFDX) ;
        
    ff = limit_vals_k(ff,fb,t3(up,1));
   
end

function [ff] = limit_quad_4(pp,q4,ff,DFDX,opts)
%LIMIT-QUAD-4 local Eikonal solver for QUAD-4 cells. 

    ff = limit_tria_3(pp, ...
        q4(:,[1,2,3]),ff,DFDX,opts);
       
    ff = limit_tria_3(pp, ...
        q4(:,[1,3,4]),ff,DFDX,opts);
       
    ff = limit_tria_3(pp, ...
        q4(:,[1,2,4]),ff,DFDX,opts);
        
    ff = limit_tria_3(pp, ...
        q4(:,[2,3,4]),ff,DFDX,opts);
     
end

function [ff] = limit_vals_k(ff,fb,ip)
%LIMIT-VALS-K 'gather' gradient-limiter at vertices.
 
    if ( exist( ...
        'OCTAVE_VERSION','builtin') <= +0)
        
    %----------------- typically faster in MATLAB...
        for ii = +1:length(ip)
            if (fb(ii) < ff(ip(ii)))
                ff(ip(ii)) = fb(ii);
            end
        end
        
    else
 
    %----------------- typically faster in OCTAVE...
        Fb = accumarray(ip, ...
            fb,[size(ff,1),1],@min,+inf) ;
    
        ff = min(Fb, ff) ;
    
    end
    
end

function [fb] = local_edge_2(pp,e2,ff,ix,gmax)
%DFDXEDGE-2 single-element eikonal solver for EDGE-2 cells
%embedded in R^d. 

%---------------------- find 'limited' extrap. to f2
    p1 = pp(e2(:,ix(1)),:);
    p2 = pp(e2(:,ix(2)),:);

    f1 = ff(e2(:,ix(1)),:);

    fb = f1 + gmax .* ...
        sqrt( sum( (p2-p1).^2, +2) ) ;

end

function [fb] = local_tria_3(pp,t3,ff,ix,gmax)
%LOCAL-TRIA-3 single-element eikonal solver for TRIA-3 cells
%embedded in R^d. 

%---------------------- find 'limited' extrap. to f3
    p1 = pp(t3(:,ix(1)),:);
    p2 = pp(t3(:,ix(2)),:);
    p3 = pp(t3(:,ix(3)),:);

    f1 = ff(t3(:,ix(1)),:);
    f2 = ff(t3(:,ix(2)),:);

    pp21 = p2-p1;   
    pp13 = p1-p3;
    
    AA = sum(pp13.*pp21,2);
    BB = sum(pp21.^2,2);
    CC = sum(pp13.^2,2);
    
    ff21 = f2-f1;
    
    At = BB.^2-(ff21./gmax).^2 .* BB;
    Bt = 2.*AA.*(BB-(ff21./gmax).^2);
    Ct = AA.^2-(ff21./gmax).^2 .* CC;
    
    tp = ones (size(f1));
    tm = zeros(size(f1));
    
    sq = Bt.^2 - 4.*At.*Ct;
    ok = sq >= 0. ;

    tp(ok) = (-Bt(ok)+sqrt(sq(ok))) ...
        ./ (2. * At(ok));
    tm(ok) = (-Bt(ok)-sqrt(sq(ok))) ...
        ./ (2. * At(ok));
    
    tp = max(0.,min(1.,tp));
    tm = max(0.,min(1.,tm));
    
    Tp = tp(:,ones(1,size(p1,2))) ;
    Tm = tm(:,ones(1,size(p1,2))) ;
    
    dp = sqrt(sum( ...
        (pp13+Tp.*pp21).^2,2)) ;
    dm = sqrt(sum( ...
        (pp13+Tm.*pp21).^2,2)) ;
        
    fp = f1 + tp.*ff21 + gmax .* dp ;
    fm = f1 + tm.*ff21 + gmax .* dm ;
   
    fb = min(fp,fm) ;
    
end

function [fb] = local_tria_4(pp,t4,ff,ix,gmax)
%LOCAL-TRIA-4 single-element eikonal solver for TRIA-4 cells
%embedded in R^d. 

%---------------------- find 'limited' extrap. to f4

    %%!! TODO...


end

function [op] = setopts (op)
%SETOPTS setup a struct of default user-def. options 

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



