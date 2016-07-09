function [mesh] = readmesh(name)
%READMESH read a *.MESH file for JIGSAW.
%
%   MESH = READMESH(NAME);
%
%   The following entities are optionally read from "NAME.MESH". En-
%   tities are loaded if they are present in the file:
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
%   See also MAKEMSH, READMSH, MAKEVTK, READVTK, MAKEMESH, MAKEOFF, 
%            READOFF, MAKESTL, READSTL
%

%---------------------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   02-Jul-2016
%   d_engwirda@outlook.com
%---------------------------------------------------------------------
%

    mesh = [] ;

    try

    ffid = fopen(name,'r');
    
    nver = +1 ;
    ndim = +3 ;
    
    while (true)
  
    %-- read next line from file
        lstr = fgetl(ffid);
        
        if (ischar(lstr) )
            
        if (length(lstr) > +0 && lstr(1) ~= '#')
            
            lstr = strtrim(lower(lstr));
            
            switch (lstr)    
            case 'meshversionformatted'

        %-- don't do anything
                
            case 'dimensions'

        %-- don't do anything
                
            case 'vertices'

        %-- read "POINT" data
                
                lstr = fgetl(ffid);
                npts = str2double(lstr);

                numr = npts * (ndim+1);

                data = ...
            fscanf(ffid,[repmat('%f ',1,ndim),'%i'],numr);

                mesh.point.coord = [ ...
                    data(1:4:end), ...
                    data(2:4:end), ...
                    data(3:4:end), ...
                    data(4:4:end)] ;

            case 'edges'

        %-- read "EDGE2" data
                
                lstr = fgetl(ffid);
                nedg = str2double(lstr);

                numr = nedg * +3 ;

                data = ...
            fscanf(ffid,[repmat('%u ',1,2),'%i'],numr);
                
                mesh.edge2.index = [ ...
                    data(1:3:end), ...
                    data(2:3:end), ...
                    data(3:3:end)] ;
                
            case 'triangles'

        %-- read "TRIA3" data
                
                lstr = fgetl(ffid);
                ntri = str2double(lstr);

                numr = ntri * +4 ;

                data = ...
            fscanf(ffid,[repmat('%u ',1,3),'%i'],numr);
                
                mesh.tria3.index = [ ...
                    data(1:4:end), ...
                    data(2:4:end), ...
                    data(3:4:end), ...
                    data(4:4:end)] ;
                
            case 'tetrahedra'

        %-- read "TRIA4" data
                
                lstr = fgetl(ffid);
                ntri = str2double(lstr);

                numr = ntri * +5 ;

                data = ...
            fscanf(ffid,[repmat('%u ',1,4),'%i'],numr);
                
                mesh.tria4.index = [ ...
                    data(1:5:end), ...
                    data(2:5:end), ...
                    data(3:5:end), ...
                    data(4:5:end), ...
                    data(5:5:end)] ;
    
            case 'hexahedra'

        %-- read "HEXA8" data
                
                lstr = fgetl(ffid);
                nhex = str2double(lstr);

                numr = nhex * +9 ;

                data = ...
            fscanf(ffid,[repmat('%u ',1,8),'%i'],numr);
                
                mesh.hexa8.index = [ ...
                    data(1:9:end), ...
                    data(2:9:end), ...
                    data(3:9:end), ...
                    data(4:9:end), ...
                    data(5:9:end), ...
                    data(6:9:end), ...
                    data(7:9:end), ...
                    data(8:9:end), ...
                    data(9:9:end)] ;
    
            end
            
        end
        
        else
    %-- if(~ischar(lstr)) //i.e. end-of-file
            break ;
        end
        
    end
    
    fclose(ffid) ;
    
    catch err

%-- ensure that we close the file regardless
    if (ffid>-1)
    fclose(ffid) ;
    end
    
    rethrow(err) ;
    
    end
    
end


