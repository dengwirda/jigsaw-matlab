function [mesh] = cubedsphere(geom)

    aa = 0.19592;

    apos = [
       +.25*pi, -aa*pi
       +.75*pi, -aa*pi
       -.75*pi, -aa*pi
       -.25*pi, -aa*pi
       +.25*pi, +aa*pi
       +.75*pi, +aa*pi
       -.75*pi, +aa*pi
       -.25*pi, +aa*pi
        ] ;

    mesh.point.coord = ...
        S2toR3(geom.radii,apos);
    mesh.point.coord(:,4) = +0 ;
    
    mesh.quad4.index = [
        1, 2, 3, 4, 0
        1, 2, 6, 5, 0
        2, 3, 7, 6, 0
        3, 4, 8, 7, 0
        4, 1, 5, 8, 0
        5, 6, 7, 8, 0
        ] ;

end



