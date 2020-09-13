function [XPOS,YPOS,SCAL] = ...
        stereo3(rrad,xpos,ypos,xmid,ymid,kind)
%STEREO3 three-dimensional stereographic projection.
%   [XNEW,YNEW] = STEREO3(RRAD,XPOS,YPOS,XMID,YMID) returns
%   the stereographic projection [XNEW,YNEW] of the lat-lon
%   points [RRAD,XPOS,YPOS], where RRAD is the radius of the
%   sphere, and [XPOS,YPOS] are arrays of longitude and
%   latitude, respectively. Angles are measured in radians.
%   [XMID,YMID] are the lon-lat coordinates that the mapping
%   is 'centred' about. The stereographic projection is a
%   conformal mapping; preserving angles.
%
%   [XNEW,YNEW] = STEREO3(..., KIND) specifies the direction
%   of the mapping. KIND = 'FWD' defines a forward mapping,
%   and KIND = 'INV' defines an inverse mapping. Here, the
%   role of [XNEW,YNEW] and [XPOS,YPOS] are exchanged, with
%   [XPOS,YPOS] the stereographic coordinates, and
%   [XNEW,YNEW] the resulting lon-lat spherical angles.
%
%   [... ,SCAL] = STEREO3(...) also returns the scale-factor
%   associated with the forward mapping. This array stores
%   the relative length distortion induced by the projection
%   for all points in [XNEW,YNEW].

%-----------------------------------------------------------
%   Darren Engwirda : 2017 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 03/05/2018
%-----------------------------------------------------------

    if (nargin < +6), kind = 'fwd'; end

%---------------------------------------------- basic checks
    if ( ~isnumeric(rrad) || ...
         ~isnumeric(xpos) || ...
         ~isnumeric(ypos) || ...
         ~isnumeric(xmid) || ...
         ~isnumeric(ymid) || ...
         ~ischar   (kind) )
        error('stereo3:incorrectInputClass' , ...
            'Incorrect input class.');
    end

    if (any(size(xpos)~=size(ypos)))
        error('stereo3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

    if (numel(rrad) ~= +1 || ...
        numel(xmid) ~= +1 || ...
        numel(ymid) ~= +1 )
        error('stereo3:incorrectDimensions' , ...
            'Incorrect input dimensions.');
    end

    switch (lower(kind))
%---------------------------------------- do forward mapping
    case 'fwd'

    kden = +1. + sin(ymid)*sin(ypos) + ...
        cos(ymid)*cos(ypos).*cos(xpos-xmid) ;

    kval = +2. * rrad ./ kden .^1 ;

    dval = -2. * rrad ./ kden .^2 ;

    XPOS = kval.* cos(ypos).*sin(xpos-xmid) ;
    YPOS = kval.*(cos(ymid) *sin(ypos) - ...
        sin(ymid)*cos(ypos).*cos(xpos-xmid));

%---------------------------------------- compute indicatrix
    dkdy = dval.*(sin(ymid)* cos(ypos) - ...
        cos(ymid)*sin(ypos).*cos(xpos-xmid));

    dXdy = dkdy.* cos(ypos).*sin(xpos-xmid)  ...
         - kval.* sin(ypos).*sin(xpos-xmid) ;

    dYdy = dkdy.*(cos(ymid)* sin(ypos) - ...
        sin(ymid)*cos(ypos).*cos(xpos-xmid)) ...
         + kval.*(cos(ymid)* cos(ypos) + ...
        sin(ymid)*sin(ypos).*cos(xpos-xmid));

    SCAL = +1./rrad * sqrt(dXdy.^2+dYdy.^2) ;

%---------------------------------------- do inverse mapping
    case 'inv'

    rval = sqrt(xpos.^2 + ypos.^2);

    cval = +2. * atan2(rval, +2. * rrad) ;

    XPOS = xmid + atan2(xpos .*sin(cval) , ...
        rval .* cos(ymid) .* cos(cval) ...
      - ypos .* sin(ymid) .* sin(cval) ) ;

    YPOS = asin(cos(cval)*sin(ymid) + ...
       (ypos.*sin(cval).*cos(ymid)) ./ rval) ;

%---------------------------------------- compute indicatrix
    kden = +1. + sin(ymid)*sin(YPOS) + ...
        cos(ymid)*cos(YPOS).*cos(XPOS-xmid) ;

    dval = -2. * rrad ./ kden .^2 ;

    kval = +2. * rrad ./ kden .^1 ;

    dkdy = dval.*(sin(ymid)* cos(YPOS) - ...
        cos(ymid)*sin(YPOS).*cos(XPOS-xmid));

    dXdy = dkdy.* cos(YPOS).*sin(XPOS-xmid)  ...
         - kval.* sin(YPOS).*sin(XPOS-xmid) ;

    dYdy = dkdy.*(cos(ymid)* sin(YPOS) - ...
        sin(ymid)*cos(YPOS).*cos(XPOS-xmid)) ...
         + kval.*(cos(ymid)* cos(YPOS) + ...
        sin(ymid)*sin(YPOS).*cos(XPOS-xmid));

    SCAL = rrad * +1./sqrt(dXdy.^2+dYdy.^2) ;

    end

end



