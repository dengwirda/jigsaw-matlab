function [ok] = welcen2(pp,pw,t2)
%WELCEN2 'well-centred' status for elements of a 2-simplex
%triangulation embedded in euclidean space.
%   [WC] = WELCEN2(PP,PW,TT) returns TRUE for triangles that
%   contain their own 'dual' vertex in their interiors. PP
%   is a V-by-2 list of XY coordinates, TT is a T-by-3 list
%   of triangle indicies, and PW is a V-by-1 array of vertex
%   weights. When PW = 0, the dual mesh is a Voronoi diagram
%   and dual vertices are triangle circumcentres.

%   Darren Engwirda : 2017 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 19/03/2018

%---------------------------------------------- basic checks
    if ( ~isnumeric(pp) || ...
         ~isnumeric(pw) || ...
         ~isnumeric(t2) )
        error('welcen2:incorrectInputClass' , ...
            'Incorrect input class.');
    end

%---------------------------------------------- basic checks
    if (ndims(pp) ~= +2 || ...
        ndims(pw) ~= +2 || ...
        ndims(t2) ~= +2 )
        error('welcen2:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

    if (size(pp,2) < +2 || ...
            size(pp,1)~= size(pw,1) || ...
                size(t2,2) < +3 )
        error('welcen2:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

%------------------------------------- compute dual vertices
    cc = pwrbal2(pp,pw,t2);

%------------------------------------- signed areas to vert.
    a1 = orient1( ...
        pp(t2(:,1),:),pp(t2(:,2),:),cc(:,1:2));

    a2 = orient1( ...
        pp(t2(:,2),:),pp(t2(:,3),:),cc(:,1:2));

    a3 = orient1( ...
        pp(t2(:,3),:),pp(t2(:,1),:),cc(:,1:2));

%------------------------------------- interior if same sign
    ok = a1 .* a2 >= +0.E+0 ...
       & a2 .* a3 >= +0.E+0 ;

end



