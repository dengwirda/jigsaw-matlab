function savevtk(name,mesh)
%SAVEVTK save a *.VTK file for JIGSAW.
%
%   SAVEVTK(NAME,MESH);
%
%   The following entities are optionally saved to the file
%   "NAME.VTK":
%
%   .IF. MESH.MSHID == 'EUCLIDEAN-MESH':
%   .IF. MESH.MSHID == 'ELLIPSOID-MESH':
%   -----------------------------------
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
%   MESH.VALUE - [NPxNV] array of "values" associated with
%       the vertices of the mesh. NV values are associated
%       with each vertex.
%
%   MESH.SLOPE - [NPx 1] array of "slopes" associated with
%       the vertices of the mesh. Slope values define the
%       gradient-limits ||dh/dx|| used by the Eikonal solver
%       MARCHE.
%
%   .IF. MESH.MSHID == 'EUCLIDEAN-GRID':
%   .OR. MESH.MSHID == 'ELLIPSOID-GRID':
%   -----------------------------------
%
%   MESH.POINT.COORD - [NDx1] cell array of grid coordinates
%       where ND is the number of spatial dimenions. Each
%       array COORD{ID} should be a vector of grid coord.'s,
%       increasing or decreasing monotonically.
%
%   MESH.VALUE - [NMxNV] array of "values" associated with
%       the vertices of the grid, where NM is the product of
%       the dimensions of the grid. NV values are associated
%       with each vertex.
%
%   MESH.SLOPE - [NMx 1] array of "slopes" associated with
%       the vertices of the grid, where NM is the product of
%       the dimensions of the grid. Slope values define the
%       gradient-limits ||dh/dx|| used by the Eikonal solver
%       MARCHE.
%
%   See also SAVEMSH, LOADMSH
%

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   21-Sep-2020
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

   [ok] = certify(mesh);

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

    if (isfield(mesh,'mshID'))
        mshID =  mesh.mshID ;
    else
        mshID = 'EUCLIDEAN-MESH';
    end

    switch (upper(mshID))

    case 'EUCLIDEAN-MESH'
        save_mesh_format( ...
            ffid,file,mesh,'EUCLIDEAN-MESH') ;
    case 'EUCLIDEAN-GRID'
        save_grid_format( ...
            ffid,file,mesh,'EUCLIDEAN-GRID') ;
    case 'EUCLIDEAN-DUAL'
       %save_dual_format( ...
       %    ffid,file,mesh,'EUCLIDEAN-DUAL') ;

    case 'ELLIPSOID-MESH'
        save_mesh_format( ...
            ffid,file,mesh,'ELLIPSOID-MESH') ;
    case 'ELLIPSOID-GRID'
        save_grid_format( ...
            ffid,file,mesh,'ELLIPSOID-GRID') ;
    case 'ELLIPSOID-DUAL'
       %save_dual_format( ...
       %    ffid,file,mesh,'ELLIPSOID-DUAL') ;

    otherwise
        error('Invalid mshID!') ;

    end

    fclose(ffid) ;

    catch err

%-- ensure that we close the file regardless!
    if (ffid>-1)
    fclose(ffid) ;
    end
    rethrow(err) ;

    end

end

function save_mesh_format(ffid,file,mesh,kind)
%SAVE-MESH-FORMAT save mesh data in unstructured-mesh format

    npoint = 0; nedge2 = 0; ntria3 = 0; ntria4 = 0;
    nquad4 = 0; nhexa8 = 0; nwedg6 = 0; npyra5 = 0;

    if (inspect(mesh,'point'))
        npoint = size(mesh.point.coord,1);
    end
    if (inspect(mesh,'edge2'))
        nedge2 = size(mesh.edge2.index,1);
    end
    if (inspect(mesh,'tria3'))
        ntria3 = size(mesh.tria3.index,1);
    end
    if (inspect(mesh,'quad4'))
        nquad4 = size(mesh.quad4.index,1);
    end
    if (inspect(mesh,'tria4'))
        ntria4 = size(mesh.tria4.index,1);
    end
    if (inspect(mesh,'hexa8'))
        nhexa8 = size(mesh.hexa8.index,1);
    end
    if (inspect(mesh,'wedg6'))
        nwedg6 = size(mesh.wedg6.index,1);
    end
    if (inspect(mesh,'pyra5'))
        npyra5 = size(mesh.pyra5.index,1);
    end

    fprintf(ffid,['# vtk DataFile Version 3.0\n']);
    fprintf(ffid,[file,'\n']);
    fprintf(ffid,['ASCII','\n']);
    fprintf(ffid,['DATASET UNSTRUCTURED_GRID \n']);

    fprintf(ffid,['POINTS %u double','\n'],npoint);

    if (inspect(mesh,'point'))
%-- write "POINT" data
    switch (size(mesh.point.coord,2))
        case +3
        data = zeros(size( ...
            mesh.point.coord,1), 3) ;
        data(:,1:2) = ...
            mesh.point.coord(:,1:2) ;

        fprintf(ffid, ...
       [repmat('%1.17g ',1,3),'\n'],data') ;

        case +4
        data = zeros(size( ...
            mesh.point.coord,1), 3) ;
        data(:,1:3) = ...
            mesh.point.coord(:,1:3) ;

        fprintf(ffid, ...
       [repmat('%1.17g ',1,3),'\n'],data') ;

        otherwise
        error('Unsupported dimensions!') ;
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

    if (inspect(mesh,'edge2'))
%-- write "EDGE2" data
    fprintf(ffid,['2 ',repmat('%u ',1,2),'\n'], ...
        mesh.edge2.index(:,1:2)'-1);
    end
    if (inspect(mesh,'tria3'))
%-- write "TRIA3" data
    fprintf(ffid,['3 ',repmat('%u ',1,3),'\n'], ...
        mesh.tria3.index(:,1:3)'-1);
    end
    if (inspect(mesh,'quad4'))
%-- write "QUAD4" data
    fprintf(ffid,['4 ',repmat('%u ',1,4),'\n'], ...
        mesh.quad4.index(:,1:4)'-1);
    end
    if (inspect(mesh,'tria4'))
%-- write "TRIA4" data
    fprintf(ffid,['4 ',repmat('%u ',1,4),'\n'], ...
        mesh.tria4.index(:,1:4)'-1);
    end
    if (inspect(mesh,'hexa8'))
%-- write "HEXA8" data
    fprintf(ffid,['8 ',repmat('%u ',1,8),'\n'], ...
        mesh.hexa8.index(:,1:8)'-1);
    end
    if (inspect(mesh,'wedg6'))
%-- write "WEDG6" data
    fprintf(ffid,['6 ',repmat('%u ',1,6),'\n'], ...
        mesh.wedg6.index(:,1:6)'-1);
    end
    if (inspect(mesh,'pyra5'))
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

    if (inspect(mesh,'edge2'))
%-- write "EDGE2" type
    fprintf(ffid,[ ...
        '%u','\n'],repmat(vtk_edge2,1,nedge2));
    end
    if (inspect(mesh,'tria3'))
%-- write "TRIA3" type
    fprintf(ffid,[ ...
        '%u','\n'],repmat(vtk_tria3,1,ntria3));
    end
    if (inspect(mesh,'quad4'))
%-- write "QUAD4" type
    fprintf(ffid,[ ...
        '%u','\n'],repmat(vtk_quad4,1,nquad4));
    end
    if (inspect(mesh,'tria4'))
%-- write "TRIA4" type
    fprintf(ffid,[ ...
        '%u','\n'],repmat(vtk_tria4,1,ntria4));
    end
    if (inspect(mesh,'hexa8'))
%-- write "HEXA8" type
    fprintf(ffid,[ ...
        '%u','\n'],repmat(vtk_hexa8,1,nhexa8));
    end
    if (inspect(mesh,'wedg6'))
%-- write "WEDG6" type
    fprintf(ffid,[ ...
        '%u','\n'],repmat(vtk_wedg6,1,nwedg6));
    end
    if (inspect(mesh,'pyra5'))
%-- write "PYRA5" type
    fprintf(ffid,[ ...
        '%u','\n'],repmat(vtk_pyra5,1,npyra5));
    end

    if (inspect(mesh,'value') && ...
            isvector(mesh.value) )
%-- write "VALUE" data
    fprintf(ffid,['POINT_DATA %u','\n'], ...
        numel(mesh.value)) ;
    fprintf(ffid, ...
        ['SCALARS value float 1','\n']);
    fprintf(ffid, ...
        ['LOOKUP_TABLE default ','\n']);

    if (~isvector(mesh.value))
    error('VALUE must be a scalar function') ;
    end

    fprintf(ffid,['%1.9g','\n'],mesh.value') ;
    end

    if (inspect(mesh,'slope') && ...
            isvector(mesh.slope) )
%-- write "SLOPE" data
    fprintf(ffid,['POINT_DATA %u','\n'], ...
        numel(mesh.slope)) ;
    fprintf(ffid, ...
        ['SCALARS slope float 1','\n']);
    fprintf(ffid, ...
        ['LOOKUP_TABLE default ','\n']);

    fprintf(ffid,['%1.9g','\n'],mesh.slope') ;
    end

end

function save_grid_format(ffid,file,mesh,kind)
%SAVE-GRID-FORMAT save mesh class in rectilinear-grid format

    ncoord = ones(3,1);

    if (inspect(mesh,'point'))
        if (length(mesh.point.coord) >= 1)
            ncoord(1) = ...
            length(mesh.point.coord{1}) ;
        end
        if (length(mesh.point.coord) >= 2)
            ncoord(2) = ...
            length(mesh.point.coord{2}) ;
        end
        if (length(mesh.point.coord) >= 3)
            ncoord(3) = ...
            length(mesh.point.coord{3}) ;
        end
    end

    fprintf(ffid,['# vtk DataFile Version 3.0\n']);
    fprintf(ffid,[file,'\n']);
    fprintf(ffid,['ASCII','\n']);
    fprintf(ffid,['DATASET RECTILINEAR_GRID  \n']);
    fprintf(ffid,['DIMENSIONS %u %u %u\n'],ncoord);

    if (inspect(mesh,'point'))
%-- write COORD data
    if (length(mesh.point.coord) >= 1)
        fprintf(ffid, ...
   ['X_COORDINATE %u double\n'],ncoord(1)) ;
        fprintf(ffid, ...
   ['%1.17g','\n'],mesh.point.coord{1}) ;
    else
        fprintf(ffid, ...
   ['X_COORDINATE %u double\n'],ncoord(1)) ;
        fprintf(ffid,'%1.17g\n',0.) ;
    end

    if (length(mesh.point.coord) >= 2)
        fprintf(ffid, ...
   ['Y_COORDINATE %u double\n'],ncoord(2)) ;
        fprintf(ffid, ...
   ['%1.17g','\n'],mesh.point.coord{2}) ;
    else
        fprintf(ffid, ...
   ['Y_COORDINATE %u double\n'],ncoord(2)) ;
        fprintf(ffid,'%1.17g\n',0.) ;
    end

    if (length(mesh.point.coord) >= 3)
        fprintf(ffid, ...
   ['Z_COORDINATE %u double\n'],ncoord(3)) ;
        fprintf(ffid, ...
   ['%1.17g','\n'],mesh.point.coord{3}) ;
    else
        fprintf(ffid, ...
   ['Z_COORDINATE %u double\n'],ncoord(3)) ;
        fprintf(ffid,'%1.17g\n',0.) ;
    end

    end

    if (inspect(mesh,'value') && ...
        numel(mesh.value) == prod(ncoord))
%-- write "VALUE" data
    fprintf(ffid,['POINT_DATA %u','\n'], ...
        numel (mesh.value));
    fprintf(ffid, ...
        ['SCALARS value float 1','\n']);
    fprintf(ffid, ...
        ['LOOKUP_TABLE default ','\n']);

    dims = ncoord([2,1,3:end]);
    dims = num2cell(dims);
    data = reshape(mesh.value,dims{:},[]);

    perm = 1 : ndims (data);
    perm(1:2) = perm([2,1]); % [x,y,...]

    data = reshape( ...
      permute(data,perm),prod(ncoord),[]);

    fprintf(ffid,['%1.9g','\n'],data') ;
    end

    if (inspect(mesh,'slope') && ...
        numel(mesh.slope) == prod(ncoord))
%-- write "SLOPE" data
    fprintf(ffid,['POINT_DATA %u','\n'], ...
        numel (mesh.slope));
    fprintf(ffid, ...
        ['SCALARS slope float 1','\n']);
    fprintf(ffid, ...
        ['LOOKUP_TABLE default ','\n']);

    dims = ncoord([2,1,3:end]);
    dims = num2cell(dims);
    data = reshape(mesh.slope,dims{:},[]);

    perm = 1 : ndims (data);
    perm(1:2) = perm([2,1]); % [x,y,...]

    data = reshape( ...
      permute(data,perm),prod(ncoord),[]);

    fprintf(ffid,['%1.9g','\n'],data') ;
    end

end



