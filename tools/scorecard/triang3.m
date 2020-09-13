function [dcos] = triang3(pp,t3)
%TRIANG3 calc. enclosed angles for a 3-simplex triangulation
%embedded in euclidean space.
%   [ADEG] = TRIANG3(VERT,TRIA) returns the enclosed angles
%   associated with each simplex, where ADEG is a T-by-6
%   array of the angles subtended at each edge, VERT is a
%   V-by-D array of XY coordinates, and TRIA is a T-by-4 ar-
%   ray of vertex indexing, where each row defines a triang-
%   le, such that VERT(TRIA(II,1),:), VERT(TRIA(II,2),:),
%   VERT(TRIA(II,3),:) and VERT(TRIA(II,3),:) are the coord-
%   inates of the II-TH tetrahedron. Angles are returned in
%   degrees.
%
%   See also TRISCR3, TRIVOL3, TRIBAL3

%   Darren Engwirda : 2017 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 10/07/2018

%---------------------------------------------- basic checks
    if (~isnumeric(pp) || ~isnumeric(t3) )
        error('triang3:incorrectInputClass' , ...
            'Incorrect input class.') ;
    end

%---------------------------------------------- basic checks
    if (ndims(pp) ~= +2 || ndims(t3) ~= +2 )
        error('triang3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end
    if (size(pp,2) < +3 || size(t3,2) < +4 )
        error('triang3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

    nnod = size(pp,1) ;

%---------------------------------------------- basic checks
    if (min(min(t3(:,1:4))) < +1 || ...
            max(max(t3(:,1:4))) > nnod )
        error('triang3:invalidInputs', ...
            'Invalid TRIA input array.') ;
    end

%----------------------------------- compute enclosed angles
    dcos = zeros(size(t3,1),6) ;

    fv11 = normal2(pp,t3(:,[1,2,3])) ;
    fv22 = normal2(pp,t3(:,[1,2,4])) ;
    fv33 = normal2(pp,t3(:,[2,3,4])) ;
    fv44 = normal2(pp,t3(:,[3,1,4])) ;

    lv11 = sqrt(sum(fv11.^2,2));
    lv22 = sqrt(sum(fv22.^2,2));
    lv33 = sqrt(sum(fv33.^2,2));
    lv44 = sqrt(sum(fv44.^2,2));

    fv11 = fv11./[lv11,lv11,lv11] ;
    fv22 = fv22./[lv22,lv22,lv22] ;
    fv33 = fv33./[lv33,lv33,lv33] ;
    fv44 = fv44./[lv44,lv44,lv44] ;

    % across each of the six edges
    % 11,22 (1,2)
    % 11,33 (2,3)
    % 11,44 (3,1)
    % 44,22 (1,4)
    % 22,33 (2,4)
    % 33,44 (3,4)

    dcos(:,1) = sum(+fv11.*fv22,2);
    dcos(:,2) = sum(+fv11.*fv33,2);
    dcos(:,3) = sum(+fv11.*fv44,2);
    dcos(:,4) = sum(-fv44.*fv22,2);
    dcos(:,5) = sum(-fv22.*fv33,2);
    dcos(:,6) = sum(-fv33.*fv44,2);

    dcos(:,1) = max(-1.,dcos(:,1));
    dcos(:,1) = min(+1.,dcos(:,1));
    dcos(:,2) = max(-1.,dcos(:,2));
    dcos(:,2) = min(+1.,dcos(:,2));
    dcos(:,3) = max(-1.,dcos(:,3));
    dcos(:,3) = min(+1.,dcos(:,3));
    dcos(:,4) = max(-1.,dcos(:,4));
    dcos(:,4) = min(+1.,dcos(:,4));
    dcos(:,5) = max(-1.,dcos(:,5));
    dcos(:,5) = min(+1.,dcos(:,5));
    dcos(:,6) = max(-1.,dcos(:,6));
    dcos(:,6) = min(+1.,dcos(:,6));

    dcos = acos(dcos) * 180. / pi ;

end



