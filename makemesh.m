function makemesh(name,mesh)
%MAKEMESH make a *.MESH file for JIGSAW.
%
%   MAKEMESH(NAME,MESH);
%
%   The following entities are optionally written to "NAME.MESH". En-
%   tities are written if they are present in the sructure MESH:
%
%   MESH.POINT.COORD - [NPxND] array of point coordinates, where ND 
%       is the number of spatial dimenions.
%
%   MESH.EDGE2.INDEX - [N2x 3] array of indexing for edge-2 elements, 
%       where INDEX(K,1:2) is an array of "points" associated with 
%       the K-TH edge, and INDEX(K,3) is an ID tag for the K-TH edge.
%
%   MESH.TRIA3.INDEX - [N3x 4] array of indexing for tria-3 elements, 
%       where INDEX(K,1:3) is an array of "points" associated with 
%       the K-TH tria, and INDEX(K,4) is an ID tag for the K-TH tria.
%
%   MESH.QUAD4.INDEX - [N4x 5] array of indexing for quad-4 elements, 
%       where INDEX(K,1:4) is an array of "points" associated with 
%       the K-TH quad, and INDEX(K,5) is an ID tag for the K-TH quad.
%
%   MESH.TRIA4.INDEX - [M4x 5] array of indexing for tria-4 elements, 
%       where INDEX(K,1:4) is an array of "points" associated with 
%       the K-TH tria, and INDEX(K,5) is an ID tag for the K-TH tria.
%
%   MESH.HEXA8.INDEX - [M8x 9] array of indexing for hexa-8 elements, 
%       where INDEX(K,1:8) is an array of "points" associated with 
%       the K-TH hexa, and INDEX(K,9) is an ID tag for the K-TH hexa.
%
%   MESH.WEDG6.INDEX - [M6x 7] array of indexing for wedg-6 elements, 
%       where INDEX(K,1:6) is an array of "points" associated with 
%       the K-TH  wedg, and INDEX(K,7) is an ID tag for the K-TH wedg.
%
%   MESH.PYRA5.INDEX - [M5x 6] array of indexing for pyra-5 elements, 
%       where INDEX(K,1:5) is an array of "points" associated with 
%       the K-TH pyra, and INDEX(K,6) is an ID tag for the K-TH pyra.
%
%   Note that (due to a lack of native support) any WEDG-6 and PYRA-5 
%   elements are decomposed into TRIA-4 elements.
%
%   See also MAKEMSH, READMSH, MAKEVTK, READVTK, READMESH, MAKEOFF, 
%            READOFF
%

%---------------------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   09-Jul-2016
%   d_engwirda@outlook.com
%---------------------------------------------------------------------
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
    
    if (meshhas(mesh,'point'))

%-- write "POINT" data
   
    switch (size(mesh.point.coord,2))
        case +2
        coord = mesh.point.coord;
        coord = [coord(:,1:1), ...
            zeros(size(coord,1),2), coord(:,2)] ;
        
        case +3
        coord = mesh.point.coord;
        coord = [coord(:,1:2), ...
            zeros(size(coord,1),1), coord(:,3)] ;
            
        case +4
        coord = mesh.point.coord;
            
        otherwise
        error('Unsupported dimensionality!') ;
    end

    fprintf(ffid,[' Vertices' ,'\n']);
    fprintf(ffid,[' %u','\n'],size(coord,1)) ;
    fprintf(ffid,...
        ' %1.16g %1.16g %1.16g %i\n',coord') ;
    
    end
    
    if (meshhas(mesh,'edge2'))
       
%-- write "EDGE2" data
    
    index = mesh.edge2.index ;
    
    fprintf(ffid,[' Edges','\n']);
    fprintf(ffid,[' %u','\n'],size(index,1) * 1) ;
    fprintf(ffid,[repmat(' %u',1,2),' %i','\n'], ...
        index(:,1:3)') ;
    
    end
    
    if (meshhas(mesh,'tria3'))
       
%-- write "TRIA3" data
    
    index = mesh.tria3.index ;
    
    fprintf(ffid,[' Triangles','\n']);
    fprintf(ffid,[' %u','\n'],size(index,1) * 1) ;
    fprintf(ffid,[repmat(' %u',1,3),' %i','\n'], ...
        index(:,1:4)') ;
    
    end
    
    if (meshhas(mesh,'quad4'))
       
%-- write "QUAD4" data
    
    index = mesh.quad4.index ;
    
    fprintf(ffid,[' Quadrilaterals','\n']);
    fprintf(ffid,[' %u','\n'],size(index,1) * 1) ;
    fprintf(ffid,[repmat(' %u',1,4),' %i','\n'], ...
        index(:,1:5)') ;
    
    end
    
    if (meshhas(mesh,'tria4'))
       
%-- write "TRIA4" data
    
    index = mesh.tria4.index ; 
    
    fprintf(ffid,[' Tetrahedra','\n']);
    fprintf(ffid,[' %u','\n'],size(index,1) * 1) ;
    fprintf(ffid,[repmat(' %u',1,4),' %i','\n'], ...
        index(:,1:5)') ;
   
    end
    
    if (meshhas(mesh,'hexa8'))
       
%-- write "HEXA8" data
    
    index = mesh.hexa8.index ; 
    
    fprintf(ffid,[' Hexahedra','\n']);
    fprintf(ffid,[' %u','\n'],size(index,1) * 1) ;
    fprintf(ffid,[repmat(' %u',1,8),' %i','\n'], ...
        index(:,1:9)') ;
   
    end
    
    if (meshhas(mesh,'wedg6'))
       
%-- write "WEDG6" data
    
%   warning('WEDG6 elements written as TRIA4 elements');
% 
%   index = mesh.wedg6.index ;
%     
%   fprintf(ffid,[' Tetrahedra','\n']);
%   fprintf(ffid,[' %u','\n'],size(index,1) * 3) ;
%   fprintf(ffid,[repmat(' %u',1,4),' %i','\n'], ...
%       index(:,[1,2,3,4,7])') ;
%   fprintf(ffid,[repmat(' %u',1,4),' %i','\n'], ...
%       index(:,[1,2,3,4,7])') ;
%   fprintf(ffid,[repmat(' %u',1,4),' %i','\n'], ...
%       index(:,[1,2,3,4,7])') ;
   
    end
    
    if (meshhas(mesh,'pyra5'))
       
%-- write "PYRA5" data
    
    warning('PYRA5 elements written as TRIA4 elements');

    index = mesh.pyra5.index ;
    
    fprintf(ffid,[' Tetrahedra','\n']);
    fprintf(ffid,[' %u','\n'],size(index,1) * 2) ;
    fprintf(ffid,[repmat(' %u',1,4),' %i','\n'], ...
        index(:,[1,2,3,5,6])') ;
    fprintf(ffid,[repmat(' %u',1,4),' %i','\n'], ...
        index(:,[1,3,4,5,6])') ;
   
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


