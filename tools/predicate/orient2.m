function [sign] = orient2(pa,pb,pc,pp)
%ORIENT2 return the orientation of PP wrt the face PA,PB,PC.
%
%   See also ORIENT1

%   Darren Engwirda : 2018 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 25/07/2018

%---------------------------------------------- calc. det(S)
    smat = zeros (3,3,size(pp,1));
    smat(1,1,:) = pa(:,1)-pp(:,1);
    smat(1,2,:) = pa(:,2)-pp(:,2);
    smat(1,3,:) = pa(:,3)-pp(:,3);
    smat(2,1,:) = pb(:,1)-pp(:,1);
    smat(2,2,:) = pb(:,2)-pp(:,2);
    smat(2,3,:) = pb(:,3)-pp(:,3);
    smat(3,1,:) = pc(:,1)-pp(:,1);
    smat(3,2,:) = pc(:,2)-pp(:,2);
    smat(3,3,:) = pc(:,3)-pp(:,3);

    sign = ...
    smat(1,1,:) .* ( ...
    smat(2,2,:) .* smat(3,3,:) ...
  - smat(2,3,:) .* smat(3,2,:) ...
        ) - ...
    smat(1,2,:) .* ( ...
    smat(2,1,:) .* smat(3,3,:) ...
  - smat(2,3,:) .* smat(3,1,:) ...
        ) + ...
    smat(1,3,:) .* ( ...
    smat(2,1,:) .* smat(3,2,:) ...
  - smat(2,2,:) .* smat(3,1,:) ...
        ) ;

    sign = sign(:) ;

end



