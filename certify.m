function [flag] = certify(mesh)
%CERTIFY error checking for JIGSAW mesh objects.

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   31-Jul-2018
%   darren.engwirda@columbia.edu
%-----------------------------------------------------------
%
  
    np = +0 ; flag = -1;
    
    if (~isstruct(mesh))
        error('certify:incorrectInputClass', ...
            'Incorrect input class.') ;
    end 

    if (meshhas(mesh,'point'))
        if (~isempty (mesh.point.coord))
        if (isnumeric(mesh.point.coord))
%----------------------------------------- check MESH coords
        np = size(mesh.point.coord,1) ;

        if (ndims(mesh.point.coord) ~= 2)
        error('certify:incorrectDimensions', ...
            'Invalid POINT.COORD dimensions.') ;
        end
        if ( size(mesh.point.coord,2)< 3)
        error('certify:incorrectDimensions', ...
            'Invalid POINT.COORD dimensions.') ;
        end 
        
        if (any(isinf(mesh.point.coord)))
        error('certify:invalidMeshPosition', ...
            'Invalid POINT.COORD values.') ;
        end
        if (any(isnan(mesh.point.coord)))
        error('certify:invalidMeshPosition', ...
            'Invalid POINT.COORD values.') ;
        end
        
        if (isfield(mesh,'mshID'))
        if (strcmpi(mesh.mshID,'euclidean-grid'))
        error('certify:incompatiblemshID', ...
            'Incompatible msh-ID flag.') ;
        end
        if (strcmpi(mesh.mshID,'ellipsoid-grid'))
        error('certify:incompatiblemshID', ...
            'Incompatible msh-ID flag.') ;
        end
        end
        
        elseif(iscell(mesh.point.coord))
%----------------------------------------- check GRID coords
        if (~isvector(mesh.point.coord))
        error('certify:incorrectDimensions', ...
            'Invalid POINT.COORD dimensions.') ;
        end
        
        for ii = +1:length(mesh.point.coord)
        
        if (~isvector(mesh.point.coord{ii}))
        error('certify:incorrectDimensions', ...
            'Invalid POINT.COORD dimensions.') ;
        end
        if (any(isinf(mesh.point.coord{ii})))
        error('certify:invalidMeshPosition', ...
            'Invalid POINT.COORD values.') ;
        end
        if (any(isnan(mesh.point.coord{ii})))
        error('certify:invalidMeshPosition', ...
            'Invalid POINT.COORD values.') ;
        end
        
        end
        
        if (isfield(mesh,'mshID'))
        if (strcmpi(mesh.mshID,'euclidean-mesh'))
        error('certify:incompatiblemshID', ...
            'Incompatible msh-ID flag.') ;
        end
        if (strcmpi(mesh.mshID,'ellipsoid-mesh'))
        error('certify:incompatiblemshID', ...
            'Incompatible msh-ID flag.') ;
        end
        end
        
        else
%----------------------------------------- wrong POINT class
        error('certify:incorrectInputClass', ...
            'Invalid POINT.COORD type.') ;
        
        end
        end
    end
    
    if (meshhas(mesh,'radii'))
%----------------------------------------- check RADII value
        if (~isempty  (mesh.radii))
        if (~isnumeric(mesh.radii))
        error('certify:incorrectInputClass', ...
            'Invalid RADII class.') ;
        end
        if (~isvector(mesh.radii))
        error('certify:incorrectDimensions', ...
            'Invalid RADII dimensions.') ;
        end
        if (length(mesh.radii) ~= +1 && ...
            length(mesh.radii) ~= +3 )
        error('certify:incorrectDimensions', ...
            'Invalid RADII dimensions.') ;
        end
        if (any(isinf(mesh.radii)))
        error('certify:invalidRadiiEntries', ...
            'Invalid RADII entries.') ;
        end
        if (any(isnan(mesh.radii)))
        error('certify:invalidRadiiEntries', ...
            'Invalid RADII entries.') ;
        end 
        end    
    end
    
    if (meshhas(mesh,'value'))
%----------------------------------------- check VALUE value
        if (~isempty  (mesh.value))
        if (isnumeric(mesh.point.coord))
%----------------------------------------- for MESH obj kind
       
        if (ndims(mesh.value) ~= 2)
        error('certify:incorrectDimensions', ...
            'Invalid VALUE dimensions.') ;
        end
        if ( size(mesh.value,1) ~= np)
        error('certify:incorrectDimensions', ...
            'Invalid VALUE dimensions.') ;
        end
       
        if (any(isinf(mesh.value)))
        error('certify:invalidValueEntries', ...
            'Invalid VALUE entries.') ;
        end
        if (any(isnan(mesh.value)))
        error('certify:invalidValueEntries', ...
            'Invalid VALUE entries.') ;
        end
        
        elseif(iscell(mesh.point.coord))
%----------------------------------------- for GRID obj kind
        
        if (length(mesh.point.coord) ~= ...
            ndims (mesh.value))
        error('certify:incorrectDimensions', ...
            'Invalid VALUE dimensions.') ;    
        end
        
        if (length(mesh.point.coord) == 2)
        
        if (length(mesh.point.coord{2}) ...
            ~= size(mesh.value,1) || ...
            length(mesh.point.coord{1}) ...
            ~= size(mesh.value,2) )
        error('certify:incorrectDimensions', ...
            'Invalid VALUE dimensions.') ;
        end

        end
        
        if (length(mesh.point.coord) == 3)
        
        if (length(mesh.point.coord{2}) ...
            ~= size(mesh.value,1) || ...
            length(mesh.point.coord{1}) ...
            ~= size(mesh.value,2) || ...
            length(mesh.point.coord{3}) ...
            ~= size(mesh.value,3) )
        error('certify:incorrectDimensions', ...
            'Invalid VALUE dimensions.') ;
        end

        end
        
        if (any(isinf(mesh.value)))
        error('certify:invalidValueEntries', ...
            'Invalid VALUE entries.') ;
        end
        if (any(isnan(mesh.value)))
        error('certify:invalidValueEntries', ...
            'Invalid VALUE entries.') ;
        end
        
        else
%----------------------------------------- wrong VALUE class
        error('certify:incorrectInputClass', ...
            'Invalid VALUE class.') ;
        
        end
        end
    end
     
    if (meshhas(mesh,'edge2'))
%----------------------------------------- check EDGE2 index
        if (~isempty  (mesh.edge2.index))
        if (~isnumeric(mesh.edge2.index))
        error('certify:incorrectInputClass', ...
            'Invalid EDGE2.INDEX type.') ;
        end
        if (ndims(mesh.edge2.index) ~= 2)
        error('certify:incorrectDimensions', ...
            'Invalid EDGE2.INDEX dimensions.') ;
        end
        if (size(mesh.edge2.index,2)~= 3)
        error('certify:incorrectDimensions', ...
            'Invalid EDGE2.INDEX dimensions.') ;
        end
        if (any(isinf(mesh.edge2.index)))
        error('certify:invalidMeshIndexing', ...
            'Invalid EDGE2.INDEX indexing.') ;
        end
        if (any(isnan(mesh.edge2.index)))
        error('certify:invalidMeshIndexing', ...
            'Invalid EDGE2.INDEX indexing.') ;
        end
        if (min(min( ...
        mesh.edge2.index(:,1:2))) < +1 || ...
            max(max( ...
        mesh.edge2.index(:,1:2))) > np  )
        error('certify:invalidMeshIndexing', ...
            'Invalid EDGE2.INDEX indexing.') ;
        end
        end
    end
    
    if (meshhas(mesh,'tria3'))
%----------------------------------------- check TRIA3 index
        if (~isempty  (mesh.tria3.index))
        if (~isnumeric(mesh.tria3.index))
        error('certify:incorrectInputClass', ...
            'Invalid TRIA3.INDEX type.') ;
        end
        if (ndims(mesh.tria3.index) ~= 2)
        error('certify:incorrectDimensions', ...
            'Invalid TRIA3.INDEX dimensions.') ;
        end
        if (size(mesh.tria3.index,2)~= 4)
        error('certify:incorrectDimensions', ...
            'Invalid TRIA3.INDEX dimensions.') ;
        end
        if (any(isinf(mesh.tria3.index)))
        error('certify:invalidMeshIndexing', ...
            'Invalid TRIA3.INDEX indexing.') ;
        end
        if (any(isnan(mesh.tria3.index)))
        error('certify:invalidMeshIndexing', ...
            'Invalid TRIA3.INDEX indexing.') ;
        end
        if (min(min( ...
        mesh.tria3.index(:,1:3))) < +1 || ...
            max(max( ...
        mesh.tria3.index(:,1:3))) > np  )
        error('certify:invalidMeshIndexing', ...
            'Invalid TRIA3.INDEX indexing.') ;
        end
        end
    end
    
    if (meshhas(mesh,'quad4'))
%----------------------------------------- check QUAD4 index
        if (~isempty  (mesh.quad4.index))
        if (~isnumeric(mesh.quad4.index))
        error('certify:incorrectInputClass', ...
            'Invalid QUAD4.INDEX type.') ;
        end
        if (ndims(mesh.quad4.index) ~= 2)
        error('certify:incorrectDimensions', ...
            'Invalid QUAD4.INDEX dimensions.') ;
        end
        if (size(mesh.quad4.index,2)~= 5)
        error('certify:incorrectDimensions', ...
            'Invalid QUAD4.INDEX dimensions.') ;
        end
        if (any(isinf(mesh.quad4.index)))
        error('certify:invalidMeshIndexing', ...
            'Invalid QUAD4.INDEX indexing.') ;
        end
        if (any(isnan(mesh.quad4.index)))
        error('certify:invalidMeshIndexing', ...
            'Invalid QUAD4.INDEX indexing.') ;
        end
        if (min(min( ...
        mesh.quad4.index(:,1:4))) < +1 || ...
            max(max( ...
        mesh.quad4.index(:,1:4))) > np  )
        error('certify:invalidMeshIndexing', ...
            'Invalid QUAD4.INDEX indexing.') ;
        end
        end
    end
    
    if (meshhas(mesh,'tria4'))
%----------------------------------------- check TRIA4 index
        if (~isempty  (mesh.tria4.index))
        if (~isnumeric(mesh.tria4.index))
        error('certify:incorrectInputClass', ...
            'Invalid TRIA4.INDEX type.') ;
        end
        if (ndims(mesh.tria4.index) ~= 2)
        error('certify:incorrectDimensions', ...
            'Invalid TRIA4.INDEX dimensions.') ;
        end
        if (size(mesh.tria4.index,2)~= 5)
        error('certify:incorrectDimensions', ...
            'Invalid TRIA4.INDEX dimensions.') ;
        end
        if (any(isinf(mesh.tria4.index)))
        error('certify:invalidMeshIndexing', ...
            'Invalid TRIA4.INDEX indexing.') ;
        end
        if (any(isnan(mesh.tria4.index)))
        error('certify:invalidMeshIndexing', ...
            'Invalid TRIA4.INDEX indexing.') ;
        end
        if (min(min( ...
        mesh.tria4.index(:,1:4))) < +1 || ...
            max(max( ...
        mesh.tria4.index(:,1:4))) > np  )
        error('certify:invalidMeshIndexing', ...
            'Invalid TRIA4.INDEX indexing.') ;
        end
        end
    end
    
    if (meshhas(mesh,'hexa8'))
%----------------------------------------- check HEXA8 index
        if (~isempty  (mesh.hexa8.index))
        if (~isnumeric(mesh.hexa8.index))
        error('certify:incorrectInputClass', ...
            'Invalid HEXA8.INDEX type.') ;
        end
        if (ndims(mesh.hexa8.index) ~= 2)
        error('certify:incorrectDimensions', ...
            'Invalid HEXA8.INDEX dimensions.') ;
        end
        if (size(mesh.hexa8.index,2)~= 9)
        error('certify:incorrectDimensions', ...
            'Invalid HEXA8.INDEX dimensions.') ;
        end
        if (any(isinf(mesh.hexa8.index)))
        error('certify:invalidMeshIndexing', ...
            'Invalid HEXA8.INDEX indexing.') ;
        end
        if (any(isnan(mesh.hexa8.index)))
        error('certify:invalidMeshIndexing', ...
            'Invalid HEXA8.INDEX indexing.') ;
        end
        if (min(min( ...
        mesh.hexa8.index(:,1:8))) < +1 || ...
            max(max( ...
        mesh.hexa8.index(:,1:8))) > np  )
        error('certify:invalidMeshIndexing', ...
            'Invalid HEXA8.INDEX indexing.') ;
        end
        end
    end

%----------------------------------------- ok if we get here
    flag = +1 ;

end



