function makemesh(name,mesh)
%MAKEMESH make a *.MESH file for JIGSAW.
%
%   MAKEMESH(NAME,MESH);
%
%   The following entities are optionally written to "NAME.MESH". Entities 
%   are written if they are present in the sructure MESH:
%
%   MESH.POINT.COORD - [NPxND] array of point coordinates, where ND is the
%       number of spatial dimenions.
%
%   MESH.EDGE2.INDEX - [N2x 3] array of indexing for edge-2 elements, whe-
%       re INDEX(K,1:2) is the array of "points" associated with the K-TH 
%       edge, and INDEX(K,3) is an ID tag for the K-TH edge.
%
%   MESH.TRIA3.INDEX - [N3x 4] array of indexing for tria-3 elements, whe-
%       re INDEX(K,1:3) is the array of "points" associated with the K-TH 
%       tria, and INDEX(K,4) is an ID tag for the K-TH tria.
%
%   MESH.QUAD4.INDEX - [N4x 5] array of indexing for quad-4 elements, whe-
%       re INDEX(K,1:4) is the array of "points" associated with the K-TH 
%       quad, and INDEX(K,5) is an ID tag for the K-TH quad.
%
%   MESH.TRIA4.INDEX - [M4x 5] array of indexing for tria-4 elements, whe-
%       re INDEX(K,1:4) is the array of "points" associated with the K-TH 
%       tria, and INDEX(K,5) is an ID tag for the K-TH tria.
%
%   MESH.HEXA8.INDEX - [M8x 9] array of indexing for hexa-8 elements, whe-
%       re INDEX(K,1:8) is the array of "points" associated with the K-TH 
%       hexa, and INDEX(K,9) is an ID tag for the K-TH hexa.
%
%   MESH.WEDG6.INDEX - [M6x 7] array of indexing for wedg-6 elements, whe-
%       re INDEX(K,1:6) is the array of "points" associated with the K-TH 
%       wedg, and INDEX(K,7) is an ID tag for the K-TH wedg.
%
%   MESH.PYRA5.INDEX - [M5x 6] array of indexing for pyra-5 elements, whe-
%       re INDEX(K,1:5) is the array of "points" associated with the K-TH 
%       pyra, and INDEX(K,6) is an ID tag for the K-TH pyra.
%
%   Note that (due to a lack of native support), WEDG6 and PYRA5 elements
%   are decomposed into TRIA4 elements.
%
%   See also MAKEMSH, READMSH, MAKEVTK, READVTK, READMESH, MAKEOFF, 
%            READOFF

%
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   21-Mar-2016
%   d_engwirda@outlook.com
%

    if (~ischar  (name))
        error('NAME must be a valid file-name!') ;
    end
    if (~isstruct(mesh))
        error('MESH must be a valid structure!') ;
    end

   [path,file,fext] = fileparts(name);
   
    if(~strcmp(lower(fext),'.mesh'))
        name = [name,'.mesh'];
    end
 
    try
%-- try to write data to file
    
    ffid = fopen(name , 'w') ;
    
    fprintf(ffid,['MeshVersionFormatted 1','\n']);
    fprintf(ffid,['# %s.mesh file, created by JIGSAW','\n'],file);
    fprintf(ffid,[' Dimension','\n']);
    fprintf(ffid,[' 3','\n']) ;
    
    if (isfield(mesh,'point') && ...
        isfield(mesh.point,'coord') && ...
       ~isempty(mesh.point.coord) )

%-- write "POINT" data
   
    switch (size(mesh.point.coord,2))
        case +2
        coord = mesh.point.coord;
        coord = [coord(:,1:1), ...
            zeros(size(coord,1),2), coord(:,2)];
        
        case +3
        coord = mesh.point.coord;
        coord = [coord(:,1:2), ...
            zeros(size(coord,1),1), coord(:,3)];
            
        case +4
        coord = mesh.point.coord;
            
        otherwise
        error('Unsupported dimensionality!') ;
    end

    fprintf(ffid,[' Vertices' ,'\n']);
    fprintf(ffid,[' %u','\n'],size(coord,1));
    fprintf(ffid,[' %1.16g %1.16g %1.16g %i','\n'],coord');
    
    end
    
    if (isfield(mesh,'edge2') && ...
        isfield(mesh.edge2,'index') && ...
       ~isempty(mesh.edge2.index) )
       
%-- write "EDGE2" data
    
    index = mesh.edge2.index;
    index(:,1:2) = index(:,1:2)-1 ; % file is zero-indexed!
    
    fprintf(ffid,[' Edges','\n']);
    fprintf(ffid,[' %u','\n'],size(index,1));
    fprintf(ffid,[repmat(' %u',1,2),' %i','\n'],index');
    
    end
    
    if (isfield(mesh,'tria3') && ...
        isfield(mesh.tria3,'index') && ...
       ~isempty(mesh.tria3.index) )
       
%-- write "TRIA3" data
    
    index = mesh.tria3.index;
    index(:,1:3) = index(:,1:3)-1 ; % file is zero-indexed!
    
    fprintf(ffid,[' Triangles','\n']);
    fprintf(ffid,[' %u','\n'],size(index,1));
    fprintf(ffid,[repmat(' %u',1,3),' %i','\n'],index');
    
    end
    
    if (isfield(mesh,'quad4') && ...
        isfield(mesh.quad4,'index') && ...
       ~isempty(mesh.quad4.index) )
       
%-- write "QUAD4" data
    
    index = mesh.quad4.index;
    index(:,1:4) = index(:,1:4)-1 ; % file is zero-indexed!
    
    fprintf(ffid,[' Quadrilaterals','\n']);
    fprintf(ffid,[' %u','\n'],size(index,1));
    fprintf(ffid,[repmat(' %u',1,4),' %i','\n'],index');
    
    end
    
    if (isfield(mesh,'tria4') && ...
        isfield(mesh.tria4,'index') && ...
       ~isempty(mesh.tria4.index) )
       
%-- write "TRIA4" data
    
    index = mesh.tria4.index;
    index(:,1:4) = index(:,1:4)-1 ; % file is zero-indexed!
    
    fprintf(ffid,[' Tetrahedra','\n']);
    fprintf(ffid,[' %u','\n'],size(index,1));
    fprintf(ffid,[repmat(' %u',1,4),' %i','\n'],index');
   
    end
    
    if (isfield(mesh,'hexa8') && ...
        isfield(mesh.hexa8,'index') && ...
       ~isempty(mesh.hexa8.index) )
       
%-- write "HEXA8" data
    
    index = mesh.hexa8.index;
    index(:,1:8) = index(:,1:8)-1 ; % file is zero-indexed!
    
    fprintf(ffid,[' Hexahedra','\n']);
    fprintf(ffid,[' %u','\n'],size(index,1));
    fprintf(ffid,[repmat(' %u',1,8),' %i','\n'],index');
   
    end
    
    if (isfield(mesh,'wedg6') && ...
        isfield(mesh.wedg6,'index') && ...
       ~isempty(mesh.wedg6.index) )
       
%-- write "WEDG6" data
    
%   warning('WEDG6 elements written as TRIA4 elements');
% 
%   index = mesh.wedg6.index;
%   index(:,1:6) = index(:,1:6)-1 ; % file is zero-indexed!
%     
%   fprintf(ffid,[' Tetrahedra','\n']);
%   fprintf(ffid,[' %u','\n'],size(index,1) * 3) ;
%   fprintf(ffid,[repmat(' %u',1,4),' %i','\n'], ...
%       index(:,[1,2,3,4])') ;
%   fprintf(ffid,[repmat(' %u',1,4),' %i','\n'], ...
%       index(:,[1,2,3,4])') ;
%   fprintf(ffid,[repmat(' %u',1,4),' %i','\n'], ...
%       index(:,[1,2,3,4])') ;
   
    end
    
    if (isfield(mesh,'pyra5') && ...
        isfield(mesh.pyra5,'index') && ...
       ~isempty(mesh.pyra5.index) )
       
%-- write "PYRA5" data
    
    warning('PYRA5 elements written as TRIA4 elements');

    index = mesh.pyra5.index;
    index(:,1:5) = index(:,1:5)-1 ; % file is zero-indexed!
    
    fprintf(ffid,[' Tetrahedra','\n']);
    fprintf(ffid,[' %u','\n'],size(index,1) * 2) ;
    fprintf(ffid,[repmat(' %u',1,4),' %i','\n'], ...
        index(:,[1,2,3,5])') ;
    fprintf(ffid,[repmat(' %u',1,4),' %i','\n'], ...
        index(:,[1,3,4,5])') ;
   
    end
    
    fprintf(ffid,' End'); fclose(ffid);
    
    catch err
    
%-- ensure that we close the file regardless!
    if (ffid>-1)
    fclose(ffid) ;
    end
    rethrow(err) ;
        
    end

end


