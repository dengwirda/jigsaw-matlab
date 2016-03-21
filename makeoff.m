function makeoff(name,mesh)
%MAKEOFF make a *.OFF file for JIGSAW.
%
%   MAKEOFF(NAME,MESH);
%
%   The following entities are optionally written to "NAME.OFF". Entities 
%   are written if they are present in the sructure MESH:
%
%   MESH.POINT.COORD - [NPxND] array of point coordinates, where ND is the
%       number of spatial dimenions.
%
%   MESH.TRIA3.INDEX - [N3x 4] array of indexing for tria-3 elements, whe-
%       re INDEX(K,1:3) is the array of "points" associated with the K-TH 
%       tria.
%
%   MESH.QUAD4.INDEX - [N4x 5] array of indexing for quad-4 elements, whe-
%       re INDEX(K,1:4) is the array of "points" associated with the K-TH 
%       quad.
%
%   See also READOFF, MAKEMSH, READMSH, MAKEMESH, READMESH, MAKEVTK, 
%            READVTK

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
   
    if(~strcmp(lower(fext),'.off'))
        name = [name,'.off'];
    end
 
    try
%-- try to write data to file
    
    ffid = fopen(name , 'w') ;
    
    npoint = 0; nedge2 = 0; ntria3 = 0; ntria4 = 0;
    nquad4 = 0; nhexa8 = 0; nwedg6 = 0; npyra5 = 0;
    nedges = 0;
    
    fprintf(ffid,['OFF','\n']);
    fprintf(ffid,['# %s.off file, created by JIGSAW','\n'],file);
    
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
    if (isfield(mesh,'quad4') && ...
        isfield(mesh.quad4,'index') && ...
       ~isempty(mesh.quad4.index) )
        nquad4 = size(mesh.quad4.index,1);
    end
    if (isfield(mesh,'tria4') && ...
        isfield(mesh.tria4,'index') && ...
       ~isempty(mesh.tria4.index) )
        ntria4 = size(mesh.tria4.index,1);
    end
    if (isfield(mesh,'hexa8') && ...
        isfield(mesh.hexa8,'index') && ...
       ~isempty(mesh.hexa8.index) )
        nhexa8 = size(mesh.hexa8.index,1);
    end
    if (isfield(mesh,'wedg6') && ...
        isfield(mesh.wedg6,'index') && ...
       ~isempty(mesh.wedg6.index) )
        nwedg6 = size(mesh.wedg6.index,1);
    end
    if (isfield(mesh,'pyra5') && ...
        isfield(mesh.pyra5,'index') && ...
       ~isempty(mesh.pyra5.index) )
        npyra5 = size(mesh.pyra5.index,1);
    end

    nfaces = ntria3 + nquad4;
    
    fprintf(ffid,'%u %u %u \n',[npoint,nfaces,nedges]) ;
    
    if (isfield(mesh,'point') && ...
        isfield(mesh.point,'coord') && ...
       ~isempty(mesh.point.coord) )
%-- write "POINT" data
    switch (size(mesh.point.coord,2))
        case +2
        coord = mesh.point.coord(:,1:1);
        coord = [coord,zeros(size(coord,1),2)];
        
        case +3
        coord = mesh.point.coord(:,1:2);
        coord = [coord,zeros(size(coord,1),1)];
            
        case +4
        coord = mesh.point.coord(:,1:3);
            
        otherwise
        error('Unsupported dimensionality!') ;
    end
    fprintf(ffid,['%1.16g %1.16g %1.16g','\n'],coord') ;
    end
    
    if (isfield(mesh,'edge2') && ...
        isfield(mesh.edge2,'index') && ...
       ~isempty(mesh.edge2.index) )
%-- write "EDGE2" data
    warning('EDGE2 elements not supported!') ;   
    end
    
    if (isfield(mesh,'tria3') && ...
        isfield(mesh.tria3,'index') && ...
       ~isempty(mesh.tria3.index) )
%-- write "TRIA3" data
    fprintf(ffid,['3',repmat(' %u',1,3),'\n'], ...
        mesh.tria3.index(:,1:3)') ;
    end
    
    if (isfield(mesh,'quad4') && ...
        isfield(mesh.quad4,'index') && ...
       ~isempty(mesh.quad4.index) )
%-- write "QUAD4" data
    fprintf(ffid,['4',repmat(' %u',1,4),'\n'], ...
        mesh.quad4.index(:,1:4)') ;
    end
    
    if (isfield(mesh,'tria4') && ...
        isfield(mesh.tria4,'index') && ...
       ~isempty(mesh.tria4.index) )
%-- write "TRIA4" data
    warning('TRIA4 elements not supported!') ;
    end
    if (isfield(mesh,'hexa8') && ...
        isfield(mesh.hexa8,'index') && ...
       ~isempty(mesh.hexa8.index) )
%-- write "HEXA8" data
    warning('HEXA8 elements not supported!') ;
    end
    if (isfield(mesh,'wedg6') && ...
        isfield(mesh.wedg6,'index') && ...
       ~isempty(mesh.wedg6.index) )
%-- write "WEDG6" data
    warning('WEDG6 elements not supported!') ;
    end
    if (isfield(mesh,'pyra5') && ...
        isfield(mesh.pyra5,'index') && ...
       ~isempty(mesh.pyra5.index) )
%-- write "PYRA5" data
    warning('PYRA5 elements not supported!') ;
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


