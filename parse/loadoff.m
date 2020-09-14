function [mesh] = loadoff(name)
%LOADOFF read an *.OFF file for JIGSAW.
%
%   MESH = LOADOFF(NAME);
%
%   The following entities are optionally read from the file
%   "NAME.OFF":
%
%   MESH.POINT.COORD - [NPxND+1] array of point coordinates,
%       where ND is the number of spatial dimenions.
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

    mesh.mshID = 'EUCLIDEAN-MESH' ;

    ffid = fopen(name,'r');

    if (ffid < +0)
    error(['File not found: ', name]) ;
    end

    mode = +0 ; npts = +0 ;
    nfac = +0 ; nedg = +0 ;

    while (true)

    %-- read next line from file
        lstr = fgetl(ffid);

        if (ischar(lstr) )

        if (length(lstr) > +0 && lstr(1) ~= '#')

            lstr = lower(strtrim(lstr));

            switch (mode)
                case +0

            %-- read OFF header

                if (strcmp(lstr,'off'))

                    mode = mode + 1 ;

                end

                case +1

            %-- read NPTS, NFAC

                data = sscanf(lstr,repmat('%u',1,3),3) ;

                if (numel(data) == +3)

                    npts = data(1);
                    nfac = data(2);
                    nedg = data(3);

                    mode = mode + 1 ;

                end

            %-- read POINT data

                data = fscanf(ffid,'%f',3*npts) ;

                mesh.point.coord = [
                    data(1:3:end), ...
                    data(2:3:end), ...
                    data(3:3:end), ...
                    zeros(npts,1)] ;

            %-- read FACES data

                data = fscanf(ffid,'%u', +inf ) ;

                head = zeros(nfac,1);
                tail = zeros(nfac,1);
                mask = zeros(size(data)) ;

                next   = +1 ;
                for ii = +1 : nfac

                    head(ii) = next + 1;

                    next = next + data(next) + 1;

                    tail(ii) = next - 1;

                end
                nsiz =  tail - head + 1;

                for ii = +1 : nfac
                    for jj = head(ii) : tail(ii)
                       mask(jj) = nsiz(ii);
                    end
                end

                dat2 = data(mask == +2) + 1;
                dat3 = data(mask == +3) + 1;
                dat4 = data(mask == +4) + 1;
                poly = data(mask >= +5) + 1;

                if ( ~isempty(dat2) )
                %-- read EDGE2 data
                    mesh.edge2.index = [
                        dat2(1:2:end), ...
                        dat2(2:2:end), ...
                    zeros(numel(dat2)/2,1) ] ;
                end

                if ( ~isempty(dat3) )
                %-- read TRIA3 data
                    mesh.tria3.index = [
                        dat3(1:3:end), ...
                        dat3(2:3:end), ...
                        dat3(3:3:end), ...
                    zeros(numel(dat3)/3,1) ] ;
                end

                if ( ~isempty(dat4) )
                %-- read QUAD4 data
                    mesh.quad4.index = [
                        dat4(1:4:end), ...
                        dat4(2:4:end), ...
                        dat4(3:4:end), ...
                        dat4(4:4:end), ...
                    zeros(numel(dat4)/4,1) ] ;
                end

                if ( ~isempty(poly) )

                    warning ( ...
                'arbitrary FACE sizes not supported' ) ;

                end

            end

        end

        else
    %-- if(~ischar(lstr)) //i.e. end-of-file
            break ;
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

end


