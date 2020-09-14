function [nvec] = normal2(pp,t2)
%NORMAL2 compute the normal vectors for a 2-simplex triangu-
%lation embedded in euclidean space.
%   [VNRM] = NORMAL2(VERT,TRIA) return the T-by-3 array VRNM
%   describing the oriented normals associated with the
%   triangulation described by {VERT,TRIA}. Here, VERT is a
%   V-by-D array of XY coordinates, and TRIA is a T-by-3
%   array of triangle indicies, where each row defines a tr-
%   iangle, such that VERT(TRIA(II,1),:), VERT(TRIA(II,2),:)
%   and VERT(TRIA(II,3),:) are the coordinates of the II-TH
%   triangle.
%
%   See also TRIVOL2, TRIVOL3

%   Darren Engwirda : 2017 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 10/07/2018

%---------------------------------------------- basic checks
    if (~isnumeric(pp) || ~isnumeric(t2) )
        error('normal2:incorrectInputClass' , ...
            'Incorrect input class.') ;
    end

%---------------------------------------------- basic checks
    if (ndims(pp) ~= +2 || ndims(t2) ~= +2 )
        error('normal2:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end
    if (size(pp,2) < +2 || size(t2,2) < +3 )
        error('normal2:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

    nnod = size(pp,1) ;

%---------------------------------------------- basic checks
    if (min(min(t2(:,1:3))) < +1 || ...
            max(max(t2(:,1:3))) > nnod )
        error('normal2:invalidInputs', ...
            'Invalid TRIA input array.') ;
    end

%------------------------------------- compute tria. normals
    ee12 = pp(t2(:,2),:)-pp(t2(:,1),:) ;
    ee13 = pp(t2(:,3),:)-pp(t2(:,1),:) ;

    nvec = zeros(size(t2,1),3);
    nvec(:,1) = ee12(:,2).*ee13(:,3) - ...
                ee12(:,3).*ee13(:,2) ;
    nvec(:,2) = ee12(:,3).*ee13(:,1) - ...
                ee12(:,1).*ee13(:,3) ;
    nvec(:,3) = ee12(:,1).*ee13(:,2) - ...
                ee12(:,2).*ee13(:,1) ;

end



