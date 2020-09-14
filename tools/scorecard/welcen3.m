function [ok] = welcen3(pp,pw,tt)
%WELCEN3 'well-centred' status for elements of a 3-simplex
%triangulation embedded in euclidean space.
%   [WC] = WELCEN3(PP,PW,TT) returns TRUE for triangles that
%   contain their own 'dual' vertex in their interiors. PP
%   is a V-by-2 list of XYZ coordinates, TT is a T-by-4 list
%   of triangle indicies, and PW is a V-by-1 array of vertex
%   weights. When PW = 0, the dual mesh is a Voronoi diagram
%   and dual vertices are triangle circumcentres.

%   Darren Engwirda : 2018 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 10/07/2018

%---------------------------------------------- basic checks
    if ( ~isnumeric(pp) || ...
         ~isnumeric(pw) || ...
         ~isnumeric(t3) )
        error('welcen3:incorrectInputClass' , ...
            'Incorrect input class.');
    end

%---------------------------------------------- basic checks
    if (ndims(pp) ~= +2 || ...
        ndims(pw) ~= +2 || ...
        ndims(t3) ~= +2 )
        error('welcen3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

    if (size(pp,2) < +3 || ...
            size(pp,1)~= size(pw,1) || ...
                size(t3,2) < +4 )
        error('welcen3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

%------------------------------------- compute dual vertices
    cc = pwrbal3(pp,pw,t3);

%------------------------------------- signed vol.'s to dual
    v1 = orient2(pp(t3(:,1),:), ...
        pp(t3(:,2),:),pp(t3(:,3),:),cc(:,1:3));

    v2 = orient2(pp(t3(:,1),:), ...
        pp(t3(:,4),:),pp(t3(:,2),:),cc(:,1:3));

    v3 = orient2(pp(t3(:,2),:), ...
        pp(t3(:,4),:),pp(t3(:,3),:),cc(:,1:3));

    v4 = orient2(pp(t3(:,3),:), ...
        pp(t3(:,4),:),pp(t3(:,1),:),cc(:,1:3));

%------------------------------------- interior if same sign
    ok = v1 .* v2 >= +0.E+0 ...
       & v2 .* v3 >= +0.E+0 ...
       & v3 .* v4 >= +0.E+0 ;

end



