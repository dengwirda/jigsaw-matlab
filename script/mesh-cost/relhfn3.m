function [hrel] = relhfn3(vert,tria,hvrt)
%RELHFN3 calc. relative edge-length for a 3-simplex triangu-
%lation embedded in euclidean space.
%   [HREL] = RELHFN3(VERT,TRIA,HVRT) returns the relative 
%   edge-length, indicating conformance to the imposed mesh-
%   spacing constraints, where HREL is a E-by-1 vector, VERT 
%   is a V-by-D array of XY coordinates, TRIA is a T-by-4 
%   array of vertex indexing, and HVRT is a V-by-1 array of
%   mesh-spacing values associated with the mesh vertices.  
%
%   See also TRISCR3, TRIVOL3, TRIANG3, TRIBAL3

%   Darren Engwirda : 2017 --
%   Email           : de2363@columbia.edu
%   Last updated    : 10/08/2018

%---------------------------------------------- basic checks    
    if (~isnumeric(vert) || ~isnumeric(tria) ||   ...
        ~isnumeric(hvrt) )
        error('relhfn3:incorrectInputClass' , ...
            'Incorrect input class.') ;
    end
    
%---------------------------------------------- basic checks
    if (ndims(vert) ~= +2 || ndims(tria) ~= +2)
        error('relhfn3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end
    if (size(vert,2) < +3 || size(tria,2) < +4)
        error('relhfn3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end
    if (size(hvrt,2)~= +1 || size(hvrt,1) ~= size(vert,1) )
        error('relhfn3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

    nnod = size(vert,1) ;

%---------------------------------------------- basic checks
    if (min(min(tria(:,1:4))) < +1 || ...
            max(max(tria(:,1:4))) > nnod )
        error('relhfn3:invalidInputs', ...
            'Invalid TRIA input array.') ;
    end

%----------------------------------- compute rel. mesh-sizes
    eset = unique2 ([ ...
        tria(:,[1,2]) ; 
        tria(:,[2,3]) ; 
        tria(:,[3,1]) ; 
        tria(:,[1,4]) ; 
        tria(:,[2,4]) ; 
        tria(:,[3,4]) ;
            ] ) ;
   
    evec = vert(eset(:,2),:)-vert(eset(:,1),:) ;
         
    elen = sqrt(sum(evec.^2,+2));

    hmid = hvrt(eset(:,2),:)+hvrt(eset(:,1),:) ;
    hmid = hmid * +0.50 ;
    hrel = elen ./ hmid ;

end



