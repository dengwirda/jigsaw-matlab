function globals
%GLOBALS a helper function to load global const. for JIGSAW.
%
%   See also EXAMPLE, DETAILS

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   27-Nov-2019
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

%------------------------------------ define JIGSAW's const.

%-- return id for JIGSAW

    global JIGSAW_UNKNOWN_ERROR ;

    JIGSAW_UNKNOWN_ERROR    = -1 ;

    global JIGSAW_NO_ERROR ;

    JIGSAW_NO_ERROR         = +0 ;

    global JIGSAW_FILE_NOT_LOCATED ;
    global JIGSAW_FILE_NOT_CREATED ;
    global JIGSAW_INVALID_ARGUMENT ;

    JIGSAW_FILE_NOT_LOCATED = +2 ;
    JIGSAW_FILE_NOT_CREATED = +3 ;
    JIGSAW_INVALID_ARGUMENT = +4 ;

%-- constants for JIGSAW

    global JIGSAW_NULL_FLAG ;

    JIGSAW_NULL_FLAG        = -100 ;

    global JIGSAW_EUCLIDEAN_MESH ;
    global JIGSAW_EUCLIDEAN_GRID ;
    global JIGSAW_EUCLIDEAN_DUAL ;
    global JIGSAW_ELLIPSOID_MESH ;
    global JIGSAW_ELLIPSOID_GRID ;
    global JIGSAW_ELLIPSOID_DUAL ;

    JIGSAW_EUCLIDEAN_MESH   = +100 ;
    JIGSAW_EUCLIDEAN_GRID   = +101 ;
    JIGSAW_EUCLIDEAN_DUAL   = +102 ;

    JIGSAW_ELLIPSOID_MESH   = +200 ;
    JIGSAW_ELLIPSOID_GRID   = +201 ;
    JIGSAW_ELLIPSOID_DUAL   = +202 ;

    global JIGSAW_POINT_TAG ;
    global JIGSAW_EDGE2_TAG ;
    global JIGSAW_TRIA3_TAG ;
    global JIGSAW_QUAD4_TAG ;
    global JIGSAW_TRIA4_TAG ;
    global JIGSAW_HEXA8_TAG ;
    global JIGSAW_PYRA5_TAG ;
    global JIGSAW_WEDG6_TAG ;

    JIGSAW_POINT_TAG        = + 10 ;
    JIGSAW_EDGE2_TAG        = + 20 ;
    JIGSAW_TRIA3_TAG        = + 30 ;
    JIGSAW_QUAD4_TAG        = + 40 ;
    JIGSAW_TRIA4_TAG        = + 50 ;
    JIGSAW_HEXA8_TAG        = + 60 ;
    JIGSAW_PYRA5_TAG        = + 70 ;
    JIGSAW_WEDG6_TAG        = + 80 ;

    global JIGSAW_HFUN_RELATIVE ;
    global JIGSAW_HFUN_ABSOLUTE ;
    global JIGSAW_KERN_DELFRONT ;
    global JIGSAW_KERN_DELAUNAY ;
    global JIGSAW_KERN_BISECTOR ;
    global JIGSAW_BNDS_TRIACELL ;
    global JIGSAW_BNDS_DUALCELL ;

    JIGSAW_HFUN_RELATIVE    = +300 ;
    JIGSAW_HFUN_ABSOLUTE    = +301 ;

    JIGSAW_KERN_DELFRONT    = +400 ;
    JIGSAW_KERN_DELAUNAY    = +401 ;
    JIGSAW_KERN_BISECTOR    = +402 ;

    JIGSAW_BNDS_TRIACELL    = +402 ;
    JIGSAW_BNDS_DUALCELL    = +403 ;

    JIGSAW_KERN_ODT_DQDX    = +404 ;
    JIGSAW_KERN_CVT_DQDX    = +405 ;
    JIGSAW_KERN_H95_DQDX    = +406 ;

end



