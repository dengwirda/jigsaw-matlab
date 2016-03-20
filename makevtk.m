function makevtk(name,mesh)
%MAKEVTK make a *.VTK file for JIGSAW.
%
%   MAKEVTK(NAME,MESH);
%
%   The following entities are optionally written to "NAME.VTK". Entities 
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
%   MESH.TRIA4.INDEX - [N4x 5] array of indexing for tria-4 elements, whe-
%       re INDEX(K,1:4) is the array of "points" associated with the K-TH 
%       tria, and INDEX(K,5) is an ID tag for the K-TH tria.
%
%   See also MAKEMSH, READMSH

%
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   20-Mar-2016
%   d_engwirda@outlook.com
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
    
    if (isfield(mesh,'point') && ...
        isfield(mesh.point,'coord') && ...
       ~isempty(mesh.point.coord) )
        npoint = size(mesh.point.coord,1);
    end
    if (isfield(mesh,'edge2') && ...
        isfield(mesh.edge2,'index') && ...
       ~isempty(mesh.edge2.index) )
        nedge2 = size(mesh.edge2.index,1);
    end
    if (isfield(mesh,'tria3') && ...
        isfield(mesh.tria3,'index') && ...
       ~isempty(mesh.tria3.index) )
        ntria3 = size(mesh.tria3.index,1);
    end
    if (isfield(mesh,'tria4') && ...
        isfield(mesh.tria4,'index') && ...
       ~isempty(mesh.tria4.index) )
        ntria4 = size(mesh.tria4.index,1);
    end
    
    fprintf(ffid,['# vtk DataFile Version 3.0','\n']);
    fprintf(ffid,[file,'\n']);
    fprintf(ffid,['ASCII','\n']);    
    fprintf(ffid,['DATASET UNSTRUCTURED_GRID ','\n']);
    
    fprintf(ffid,['POINTS %u double','\n'],npoint);
    
    if (isfield(mesh,'point') && ...
        isfield(mesh.point,'coord') && ...
       ~isempty(mesh.point.coord) )
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
    
    nline = nedge2 * 1 ...
          + ntria3 * 1 ...
          + ntria4 * 1 ;
    nints = nedge2 * 3 ...
          + ntria3 * 4 ... 
          + ntria4 * 5 ;
    
    fprintf(ffid,['CELLS %u %u','\n'],[nline,nints]);
    
    if (isfield(mesh,'edge2') && ...
        isfield(mesh.edge2,'index') && ...
       ~isempty(mesh.edge2.index) )
%-- write "EDGE2" data
    fprintf(ffid,['2 ',repmat('%u ',1,2),'\n'], ...
        mesh.edge2.index(:,1:2)'-1);
    end
    if (isfield(mesh,'tria3') && ...
        isfield(mesh.tria3,'index') && ...
       ~isempty(mesh.tria3.index) )
%-- write "TRIA3" data
    fprintf(ffid,['3 ',repmat('%u ',1,3),'\n'], ...
        mesh.tria3.index(:,1:3)'-1);
    end
    if (isfield(mesh,'tria4') && ...
        isfield(mesh.tria4,'index') && ...
       ~isempty(mesh.tria4.index) )
%-- write "TRIA4" data
    fprintf(ffid,['4 ',repmat('%u ',1,4),'\n'], ...
        mesh.tria4.index(:,1:4)'-1);
    end
    
    fprintf(ffid,['CELL_TYPES %u','\n'],nline);
    
    vtk_edge2 = + 3 ;
    vtk_tria3 = + 5 ;
    vtk_tria4 = +10 ;
    
    if (isfield(mesh,'edge2') && ...
        isfield(mesh.edge2,'index') && ...
       ~isempty(mesh.edge2.index) )
%-- write "EDGE2" type
    fprintf(ffid,['%u','\n'],repmat(vtk_edge2,1,nedge2));
    end
    if (isfield(mesh,'tria3') && ...
        isfield(mesh.tria3,'index') && ...
       ~isempty(mesh.tria3.index) )
%-- write "TRIA3" type
    fprintf(ffid,['%u','\n'],repmat(vtk_tria3,1,ntria3));
    end
    if (isfield(mesh,'tria4') && ...
        isfield(mesh.tria4,'index') && ...
       ~isempty(mesh.tria4.index) )
%-- write "TRIA4" type
    fprintf(ffid,['%u','\n'],repmat(vtk_tria4,1,ntria4));
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


