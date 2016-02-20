function [mesh] = readmsh(name)
%READMSH read a *.MSH file for JIGSAW.
%
%   MESH = READMSH(NAME);
%
%   The following entities are optionally loaded from "NAME.MSH". Entities 
%   are loaded if they are present in the file:
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
%   An additional set of "values" may also be optionally loaded, such that:
%
%   MESH.(BASE).(NAME).VALUE - [NFxNV] array of "values".
%   MESH.(BASE).(NAME).INDEX - [NFx 1] array of indexing.
%
%   Here BASE is one of "POINT", "EDGE2", "TRIA3", "TRIA4" and NAME is the
%   name assigned to the data field. This mechanism can be used to associ-
%   ate arbitrary "named" data fields with the primary mesh entities, such 
%   that the data contained in MESH.(BASE).(NAME).VALUE(K,:) is associated 
%   with the MESH.(BASE).(NAME).INDEX(K)-TH element of MESH.(BASE).
%
%   See also MAKEMSH

%   Darren Engwirda
%   14-Jan-2016
%   d_engwirda@outlook.com


    try

    ffid = fopen(name,'r');
    
    real = '%f;';
    ints = '%i;';
    
    nver = +0;
    ndim = +0;
    
    while (true)
  
    %-- read next line from file
        lstr = fgetl(ffid);
        
        if (ischar(lstr) )
        
        if (length(lstr) > +0 && lstr(1) ~= '#')

        %-- tokenise line about '=' character
            tstr = regexp(lower(lstr),'=','split');
           
            switch (strtrim(tstr{1}))
            case 'mshid'

        %-- read "MSHID" data
        
                nver = str2double(tstr{2}) ;

            case 'ndims'

        %-- read "NDIMS" data
        
                ndim = str2double(tstr{2}) ;

            case 'point'

        %-- read "POINT" data

                nnum = str2double(tstr{2}) ;

                numr = nnum*(ndim+1);

                data = ...
            fscanf(ffid,[repmat(real,1,ndim),'%i'],numr);

                if (ndim == +2)
                mesh.point.coord = [ ...
                data(1:3:end), ...
                data(2:3:end), ...
                data(3:3:end)] ;
                end
                if (ndim == +3)
                mesh.point.coord = [ ...
                data(1:4:end), ...
                data(2:4:end), ...
                data(3:4:end), ...
                data(4:4:end)] ;
                end

            case 'edge2'

        %-- read "EDGE2" data

                nnum = str2double(tstr{2}) ;

                numr = nnum * 3;
                
                data = ...
            fscanf(ffid,[repmat(ints,1,2),'%i'],numr);
                
                mesh.edge2.index = [ ...
                data(1:3:end), ...
                data(2:3:end), ...
                data(3:3:end)] ;
            
                mesh.edge2.index(:,1:2) = ...
                mesh.edge2.index(:,1:2) + 1;
                
            case 'tria3'

        %-- read "TRIA3" data

                nnum = str2double(tstr{2}) ;

                numr = nnum * 4;
                
                data = ...
            fscanf(ffid,[repmat(ints,1,3),'%i'],numr);
                
                mesh.tria3.index = [ ...
                data(1:4:end), ...
                data(2:4:end), ...
                data(3:4:end), ...
                data(4:4:end)] ;
            
                mesh.tria3.index(:,1:3) = ...
                mesh.tria3.index(:,1:3) + 1;
        
            case 'tria4'

        %-- read "TRIA4" data

                nnum = str2double(tstr{2}) ;

                numr = nnum * 5;
                
                data = ...
            fscanf(ffid,[repmat(ints,1,4),'%i'],numr);
                
                mesh.tria4.index = [ ...
                data(1:5:end), ...
                data(2:5:end), ...
                data(3:5:end), ...
                data(4:5:end), ...
                data(5:5:end)] ;
            
                mesh.tria4.index(:,1:4) = ...
                mesh.tria4.index(:,1:4) + 1;
                
            case 'value'

        %-- read "VALUE" data

                stag = regexp(tstr{2},';','split');
                
                nnum = str2double(stag{1}) ;
                vnum = str2double(stag{2}) ;
                
                base = strtrim(stag{3}); 
                name = strtrim(stag{4});
                
                numr = nnum * (vnum+1) ;
                
                data = ...
            fscanf(ffid,[repmat(real,1,vnum),'%i'],numr);
                
                mesh.(base).(name).index = ...
                    data(vnum+1:vnum+1:end)+1;
                
                mesh.(base).(name).value = ...
                    zeros(nnum, vnum);
                
                for vpos = +1 : vnum
                
                mesh.(base).(name).value(:,vpos) = ...
                    data(vpos+0:vnum+1:end) ;

                end
                
            end
                       
        end
           
        else
    %-- if(~ischar(lstr)) // i.e. end-of-file
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


