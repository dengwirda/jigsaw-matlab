function savevtk(name,mesh)
%SAVEVTK save a *.VTK file for JIGSAW.
%
%   SAVEVTK(NAME,MESH);
%
%   The following entities are optionally saved to the file
%   "NAME.VTK":
%
%   MESH.POINT.COORD - [NPxND+1] array of point coordinates, 
%       where ND is the number of spatial dimenions.
%
%   MESH.EDGE2.INDEX - [N2x 4] array of indexing for EDGE-2 
%       elements, where INDEX(K,1:2) is an array of "points" 
%       associated with the K-TH edge, and INDEX(K,3) is an 
%       associated ID tag.
%
%   MESH.TRIA3.INDEX - [N3x 4] array of indexing for TRIA-3 
%       elements, where INDEX(K,1:3) is an array of "points" 
%       associated with the K-TH tria, and INDEX(K,4) is an 
%       associated ID tag.
%
%   MESH.QUAD4.INDEX - [N3x 5] array of indexing for QUAD-4 
%       elements, where INDEX(K,1:4) is an array of "points" 
%       associated with the K-TH quad, and INDEX(K,5) is an 
%       associated ID tag.
%
%   MESH.TRIA4.INDEX - [N4x 5] array of indexing for TRIA-4 
%       elements, where INDEX(K,1:4) is an array of "points" 
%       associated with the K-TH tria, and INDEX(K,5) is an 
%       associated ID tag.
%
%   MESH.HEXA8.INDEX - [N8x 9] array of indexing for HEXA-8 
%       elements, where INDEX(K,1:8) is an array of "points" 
%       associated with the K-TH elem, and INDEX(K,9) is an 
%       associated ID tag.
%
%   MESH.WEDG6.INDEX - [N6x 7] array of indexing for WEDG-6 
%       elements, where INDEX(K,1:6) is an array of "points" 
%       associated with the K-TH elem, and INDEX(K,7) is an 
%       associated ID tag.
%
%   MESH.PYRA5.INDEX - [N5x 6] array of indexing for PYRA-5 
%       elements, where INDEX(K,1:6) is an array of "points" 
%       associated with the K-TH elem, and INDEX(K,6) is an 
%       associated ID tag.
%
%   See also SAVEMSH, LOADMSH, SAVEOFF, LOADOFF, LOADVTK, 
%            SAVESTL, LOADSTL, 
%            

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   15-Jul-2018
%   darren.engwirda@columbia.edu
%-----------------------------------------------------------
%

    if (~ischar  (name))
        error('NAME must be a valid file-name!') ;
    end
    if (~isstruct(mesh))
        error('MESH must be a valid structure!') ;
    end

    [path,file,fext] = fileparts(name);
   
    if(~strcmp(lower(fext),'.vtk'))
        name = [name,'.vtk'];
    end
 
    try
%-- try to write data to file
    
    ffid = fopen(name, 'w') ;
    
    npoint = 0; nedge2 = 0; ntria3 = 0; ntria4 = 0;
    nquad4 = 0; nhexa8 = 0; nwedg6 = 0; npyra5 = 0;
    
    if (meshhas(mesh,'point'))
        npoint = size(mesh.point.coord,1);
    end
    if (meshhas(mesh,'edge2'))
        nedge2 = size(mesh.edge2.index,1);
    end
    if (meshhas(mesh,'tria3'))
        ntria3 = size(mesh.tria3.index,1);
    end
    if (meshhas(mesh,'quad4'))
        nquad4 = size(mesh.quad4.index,1);
    end
    if (meshhas(mesh,'tria4'))
        ntria4 = size(mesh.tria4.index,1);
    end
    if (meshhas(mesh,'hexa8'))
        nhexa8 = size(mesh.hexa8.index,1);
    end
    if (meshhas(mesh,'wedg6'))
        nwedg6 = size(mesh.wedg6.index,1);
    end
    if (meshhas(mesh,'pyra5'))
        npyra5 = size(mesh.pyra5.index,1);
    end
    
    fprintf(ffid,['# vtk DataFile Version 3.0\n']);
    fprintf(ffid,[file,'\n']);
    fprintf(ffid,['ASCII','\n']);    
    fprintf(ffid,['DATASET UNSTRUCTURED_GRID \n']);
    
    fprintf(ffid,['POINTS %u double','\n'],npoint);
    
    if (meshhas(mesh,'point'))
%-- write "POINT" data
        switch (size(mesh.point.coord,2))
            case +3
        fprintf(ffid,[repmat('%1.16g ',1,2),'\n'], ...
            mesh.point.coord(:,1:2)');

            case +4
        fprintf(ffid,[repmat('%1.16g ',1,3),'\n'], ...
            mesh.point.coord(:,1:3)');

            otherwise
            error('Unsupported dimensionality!') ;
        end
    end
    
    nline = nedge2 * 1 + ntria3 * 1 ...
          + ntria4 * 1 + nquad4 * 1 ...
          + nhexa8 * 1 + nwedg6 * 1 ...
          + npyra5 * 1 ;
    nints = nedge2 * 3 + ntria3 * 4 ... 
          + ntria4 * 5 + nquad4 * 5 ...
          + nhexa8 * 9 + nwedg6 * 7 ...
          + npyra5 * 6 ;
    
    fprintf(ffid,['CELLS %u %u\n'],[nline,nints]) ;
    
    if (meshhas(mesh,'edge2'))
%-- write "EDGE2" data
    fprintf(ffid,['2 ',repmat('%u ',1,2),'\n'], ...
        mesh.edge2.index(:,1:2)'-1);
    end
    if (meshhas(mesh,'tria3'))
%-- write "TRIA3" data
    fprintf(ffid,['3 ',repmat('%u ',1,3),'\n'], ...
        mesh.tria3.index(:,1:3)'-1);
    end
    if (meshhas(mesh,'quad4'))
%-- write "QUAD4" data
    fprintf(ffid,['4 ',repmat('%u ',1,4),'\n'], ...
        mesh.quad4.index(:,1:3)'-1);
    end
    if (meshhas(mesh,'tria4'))
%-- write "TRIA4" data
    fprintf(ffid,['4 ',repmat('%u ',1,4),'\n'], ...
        mesh.tria4.index(:,1:4)'-1);
    end
    if (meshhas(mesh,'hexa8'))
%-- write "HEXA8" data
    fprintf(ffid,['8 ',repmat('%u ',1,8),'\n'], ...
        mesh.hexa8.index(:,1:8)'-1);
    end
    if (meshhas(mesh,'wedg6'))
%-- write "WEDG6" data
    fprintf(ffid,['6 ',repmat('%u ',1,6),'\n'], ...
        mesh.wedg6.index(:,1:6)'-1);
    end
    if (meshhas(mesh,'pyra5'))
%-- write "PYRA5" data
    fprintf(ffid,['5 ',repmat('%u ',1,5),'\n'], ...
        mesh.pyra5.index(:,1:5)'-1);
    end
    
    fprintf(ffid,['CELL_TYPES %u','\n'],nline);
    
    vtk_edge2 = + 3 ;
    vtk_tria3 = + 5 ;
    vtk_quad4 = + 9 ;
    vtk_tria4 = +10 ;
    vtk_hexa8 = +12 ;
    vtk_wedg6 = +13 ;
    vtk_pyra5 = +14 ;
    
    if (meshhas(mesh,'edge2'))
%-- write "EDGE2" type
    fprintf(ffid,[ ...
        '%u','\n'],repmat(vtk_edge2,1,nedge2));
    end
    if (meshhas(mesh,'tria3'))
%-- write "TRIA3" type
    fprintf(ffid,[ ...
        '%u','\n'],repmat(vtk_tria3,1,ntria3));
    end
    if (meshhas(mesh,'quad4'))
%-- write "QUAD4" type
    fprintf(ffid,[ ...
        '%u','\n'],repmat(vtk_quad4,1,nquad4));
    end
    if (meshhas(mesh,'tria4'))
%-- write "TRIA4" type
    fprintf(ffid,[ ...
        '%u','\n'],repmat(vtk_tria4,1,ntria4));
    end
    if (meshhas(mesh,'hexa8'))
%-- write "HEXA8" type
    fprintf(ffid,[ ...
        '%u','\n'],repmat(vtk_hexa8,1,nhexa8));
    end
    if (meshhas(mesh,'wedg6'))
%-- write "WEDG6" type
    fprintf(ffid,[ ...
        '%u','\n'],repmat(vtk_wedg6,1,nwedg6));
    end
    if (meshhas(mesh,'pyra5'))
%-- write "PYRA5" type
    fprintf(ffid,[ ...
        '%u','\n'],repmat(vtk_pyra5,1,npyra5));
    end
    
    fclose(ffid);
    
    catch err
    
%-- ensure that we close the file regardless!
    if (ffid>-1)
    fclose(ffid) ;
    end
    rethrow(err) ;
        
    end

end


