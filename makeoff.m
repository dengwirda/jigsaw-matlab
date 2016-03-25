function makeoff(name,mesh)
%MAKEOFF make an *.OFF file for JIGSAW.
%
%   MAKEOFF(NAME,MESH);
%
%   The following entities are optionally written to "NAME.OFF". Ent-
%   ities are written if they are present in the sructure MESH:
%
%   MESH.POINT.COORD - [NPxND] array of point coordinates, where ND 
%       is the number of spatial dimenions.
%
%   MESH.TRIA3.INDEX - [N3x 4] array of indexing for tria-3 elements, 
%       where INDEX(K,1:3) is an array of "points" associated with 
%       the K-TH tria, and INDEX(K,4) is an ID tag for the K-TH tria.
%
%   MESH.QUAD4.INDEX - [N4x 5] array of indexing for quad-4 elements, 
%       where INDEX(K,1:4) is an array of "points" associated with 
%       the K-TH quad, and INDEX(K,5) is an ID tag for the K-TH quad.
%
%   See also READOFF, MAKEMSH, READMSH, MAKEMESH, READMESH, MAKEVTK, 
%            READVTK, MAKESTL, READSTL
%

%---------------------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   22-Mar-2016
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

    nfaces = ntria3 + nquad4;
    
    fprintf(ffid,'%u %u %u \n',[npoint,nfaces,nedges]) ;
    
    if (meshhas(mesh,'point'))
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
    
    if (meshhas(mesh,'edge2'))
%-- write "EDGE2" data
    warning('EDGE2 elements not supported!') ;   
    end
    
    if (meshhas(mesh,'tria3'))
%-- write "TRIA3" data
    fprintf(ffid,['3',repmat(' %u',1,3),'\n'], ...
        mesh.tria3.index(:,1:3)'-1) ;
    end
    
    if (meshhas(mesh,'quad4'))
%-- write "QUAD4" data
    fprintf(ffid,['4',repmat(' %u',1,4),'\n'], ...
        mesh.quad4.index(:,1:4)'-1) ;
    end
    
    if (meshhas(mesh,'tria4'))
%-- write "TRIA4" data
    warning('TRIA4 elements not supported!') ;
    end
    
    if (meshhas(mesh,'hexa8'))
%-- write "HEXA8" data
    warning('HEXA8 elements not supported!') ;
    end
    
    if (meshhas(mesh,'wedg6'))
%-- write "WEDG6" data
    warning('WEDG6 elements not supported!') ;
    end
    
    if (meshhas(mesh,'pyra5'))
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


