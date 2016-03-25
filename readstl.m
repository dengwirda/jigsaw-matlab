function [mesh] = readstl(name)
%READSTL read an *.STL file for JIGSAW.
%
%   MESH = READSTL(NAME);
%
%   The following entities are optionally read from "NAME.STL". Ent-
%   ities are loaded if they are present in the file:
%
%   MESH.POINT.COORD - [NPxND] array of point coordinates, where ND 
%       is the number of spatial dimenions.
%
%   MESH.TRIA3.INDEX - [N3x 4] array of indexing for tria-3 elements, 
%       where INDEX(K,1:3) is an array of "points" associated with 
%       the K-TH tria, and INDEX(K,4) is an ID tag for the K-TH tria.
%
%   See also MAKESTL, MAKEVTK, READVTK, MAKEMESH, READMESH, MAKEOFF,
%            READOFF, MAKEMSH, READMSH
%

%---------------------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   24-Mar-2016
%   d_engwirda@outlook.com
%---------------------------------------------------------------------
%

    try

    ffid = fopen(name, 'r') ;
    
%-- read 1-st line from file
    
    chars = fread(ffid, + 5,'char=>char') ;
    title = chars' ;
    
    if (strcmpi(title,'solid'))
    
    %-- read an 'ASCII' STL file    
        
        chars = fgetl(ffid) ;
        title = [title,chars] ;
        
        facet = fscanf(ffid,[
            'facet normal ' , ...
                '%f %f %f\n', ...
             'outer loop\n' , ...
              'vertex %f %f %f\n', ...
              'vertex %f %f %f\n', ...
              'vertex %f %f %f\n', ...
             'endloop\n', ...
            'endfacet\n'] ) ;
            
        facet = reshape(facet, 12, []) ;
        
        if (~isempty(facet) )

        %-- push 'POINT' data arrays
 
            nvert = size(facet, 2) ;
            nvert = nvert * +3 ;
 
            coord = facet (4:12,:) ;
            coord = coord (:)  ;
            
            mesh.point.coord = [ ...
                coord(1:3:end) , ... 
                coord(2:3:end) , ...
                coord(3:3:end) ] ;
            
        %-- push 'TRIA3' data arrays
            
            index = (1:nvert)' ;
            
            mesh.tria3.index = [ ...
                index(1:3:end) , ...
                index(2:3:end) , ...
                index(3:3:end) ] ;
        
        end
        
    else
        
    %-- read a 'BINARY' STL file
        
        chars = fread(ffid, +75,'char=>char') ;
        title = [title, chars'] ;
        
        nface = ...
            fread(ffid, + 1,'uint32=>uint32') ;
        nvert = nface * 3 ;

        facet = ...
            fread(ffid,+inf,'uint16=>uint16') ;
        
        facet = reshape(facet,[25,nface]) ;
        norms = facet(1: 6,:) ; % norms.
        coord = facet(7:24,:) ; % coord.
        
        norms = typecast(norms(:),'single') ;
        coord = typecast(coord(:),'single') ;
      
        if (~isempty(coord) )
        
        %-- push 'POINT' data arrays
            
            mesh.point.coord = [ ...
                coord(1:3:end) , ... 
                coord(2:3:end) , ...
                coord(3:3:end) ] ;
            
        %-- push 'TRIA3' data arrays
            
            index = (1:nvert)' ;
            
            mesh.tria3.index = [ ...
                index(1:3:end) , ...
                index(2:3:end) , ...
                index(3:3:end) ] ;
                
        end
        
    end
    
    fclose(ffid) ;
    
    catch err

%-- ensure that we close the file regardless!
    if (ffid>-1)
    fclose(ffid) ;
    end
    
    rethrow(err) ;
    
    end

%-- STL creates many duplicate vertices: zip!
    
    bbox = max(mesh.point.coord,[],1) ...
         - min(mesh.point.coord,[],1) ;
    bsiz = mean(bbox);
    
    ftol = +1.e-13 * bsiz; 
        
    [junk,keep,imap] = ... % make box
        unique(round ( ...
            mesh.point.coord/ftol),'rows') ;
        
    mesh.point.coord = ...
        mesh.point.coord(keep,:) ;

    mesh.tria3.index = ...
        imap(mesh.tria3.index  ) ;
        
    mesh.point.coord = [
    mesh.point.coord, ...
        zeros(size(mesh.point.coord,1),1)] ;  
  
    mesh.tria3.index = [
    mesh.tria3.index, ...
        zeros(size(mesh.tria3.index,1),1)] ;
    
end


