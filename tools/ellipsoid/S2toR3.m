function [E3] = S2toR3(radii,S2)
%S2toR3 convert from spheroidal into cartesian coordinates.

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   30-Jul-2019
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    if (~isnumeric(radii) || ~isnumeric(S2))
        error('S2toR3:incorrectInputClass' , ...
            'Incorrect input class.') ;
    end

    if (numel(radii) ~= +3 )
        error('S2toR3:incorrectDimensions' , ...
            'Incorrect input dimensions.') ;
    end
    if (ndims(S2) ~= +2 )
        error('S2toR3:incorrectDimensions' , ...
            'Incorrect input dimensions.') ;
    end
    if (size(S2,2) < +2 )
        error('S2toR3:incorrectDimensions' , ...
            'Incorrect input dimensions.') ;
    end

%----------------------------------- spheroidal => cartesian

    E3 = zeros(size(S2,1),3);

    E3(:,1) = radii(1) * cos(S2(:,1)) ...
                      .* cos(S2(:,2)) ;

    E3(:,2) = radii(2) * sin(S2(:,1)) ...
                      .* cos(S2(:,2)) ;

    E3(:,3) = radii(3) * sin(S2(:,2)) ;

end



