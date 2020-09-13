function [mesh] = loadstl(name)
%LOADSTL read an *.STL file for JIGSAW.
%
%   MESH = LOADSTL(NAME);
%
%   The following entities are optionally read from the file
%   "NAME.STL":
%
%   MESH.POINT.COORD - [NPxND+1] array of point coordinates,
%       where ND is the number of spatial dimenions.
%
%   MESH.TRIA3.INDEX - [N3x 4] array of indexing for TRIA-3
%       elements, where INDEX(K,1:3) is an array of "points"
%       associated with the K-TH tria, and INDEX(K,4) is an
%       associated ID tag.
%
%   See also SAVEMSH, LOADMSH
%

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   14-Jul-2018
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    mesh = [] ;

    try

    mesh.mshID = 'EUCLIDEAN-MESH';

    ffid  = fopen(name, 'r');

    if (ffid < +0)
    error (['File not found: ', name]);
    end

    if (~isbinary(ffid,name))

    %-- read an 'ASCII' STL file

        title = fgetl(ffid) ;

        facet = textscan(ffid,'%s');

        n = floor(length(facet{1})/21);

        fmaps = 0 : 21 : 21*(n-1);
        fmaps = repmat(fmaps,[9,1]);

        index = [ 9;10;11; ...
                 13;14;15; ...
                 17;18;19; ...
                ] ;
        index = repmat(index,[1,n]);

        index = index(:)+fmaps(:);

        facet = facet{1}(index);
        facet = reshape(sscanf( ...
    sprintf('%s#',facet{:}), '%g#'),size(facet)) ;

        if (~isempty(facet) )

        %-- push 'POINT' data arrays

            nvert = size(facet, 1) ;
            nvert = nvert / +3 ;

            mesh.point.coord = [ ...
                facet(1:3:end) , ...
                facet(2:3:end) , ...
                facet(3:3:end) ] ;

        %-- push 'TRIA3' data arrays

            index = (1:nvert)' ;

            mesh.tria3.index = [ ...
                index(1:3:end) , ...
                index(2:3:end) , ...
                index(3:3:end) ] ;

        end

    else

    %-- read a 'BINARY' STL file

        title = fread(ffid, +80) ;

        nface = fread(...
            ffid, + 1,'uint32=>uint32') ;
        nvert = nface * 3 ;

        facet = fread(...
            ffid,+inf,'uint16=>uint16') ;

        facet = reshape(facet,[25,nface]) ;
        norms = facet(1: 6,:) ; % norms.
        coord = facet(7:24,:) ; % coord.

        norms = ...
            typecast(norms(:),'single') ;
        coord = ...
            typecast(coord(:),'single') ;

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

    if (~isempty(mesh))

    bbox = max(mesh.point.coord,[],1) ...
         - min(mesh.point.coord,[],1) ;
    bsiz = mean(bbox);

    ftol = +1.E-12 * bsiz;

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

end

function [fbin] = isbinary(ffid,name)
%ISBINARY returns TRUE if file is binary STL

    head = fread(ffid,+80);
    nfac = fread(...
        ffid,+ 1, 'uint32=>uint32') ;

    file = dir(name) ;

    fbin = file.bytes == nfac*50+84 ;

    fseek(ffid,0,-1) ;

end


