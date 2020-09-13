function [sign] = orient1(pa,pb,pp)
%ORIENT1 return the orientation of PP wrt the line [PA, PB].
%
%   See also ORIENT2

%   Darren Engwirda : 2018 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 25/07/2018

%---------------------------------------------- calc. det(S)
    smat = zeros (2,2,size(pp,1));
    smat(1,1,:) = pa(:,1)-pp(:,1);
    smat(1,2,:) = pa(:,2)-pp(:,2);
    smat(2,1,:) = pb(:,1)-pp(:,1);
    smat(2,2,:) = pb(:,2)-pp(:,2);

    sign = ...
    smat(1,1,:) .* smat(2,2,:) - ...
    smat(1,2,:) .* smat(2,1,:) ;

    sign = sign(:) ;

end



