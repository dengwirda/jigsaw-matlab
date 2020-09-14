function [S2] = R3toS2(radii,E3)
%R3toS2 convert from cartesian into spheroidal coordinates.

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   30-Jul-2019
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    if (~isnumeric(radii) || ~isnumeric(E3))
        error('R3toS2:incorrectInputClass' , ...
            'Incorrect input class.') ;
    end

    if (numel(radii) ~= +3 )
        error('R3toS2:incorrectDimensions' , ...
            'Incorrect input dimensions.') ;
    end
    if (ndims(E3) ~= +2 )
        error('R3toS2:incorrectDimensions' , ...
            'Incorrect input dimensions.') ;
    end
    if (size(E3,2) < +3 )
        error('R3toS2:incorrectDimensions' , ...
            'Incorrect input dimensions.') ;
    end

%----------------------------------- spheroidal => cartesian

    S2 = zeros(size(E3,1), 2) ;

    xm = E3(:,1) * radii(2) ;
    ym = E3(:,2) * radii(1) ;
    zr = E3(:,3) / radii(3) ;

    zr = max(min(zr,+1.),-1.) ;

    S2(:,2) = asin (zr) ;
    S2(:,1) = atan2(ym, xm) ;

end



