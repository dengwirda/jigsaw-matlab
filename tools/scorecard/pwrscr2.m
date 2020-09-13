function [sc] = pwrscr2(pp,pw,t2)
%PWRSCR2 calc. a dual grid quality metric for triangles in a
%2-simplex triangulation in R^2 or R^3.
%   [SCR2] = PWRSCR2(VERT,VPWR,TRIA) returns the dual metric
%   where SCR2 is a T-by-1 vector, VERT is a V-by-D array of
%   XY, or XYZ coordinates, VPWR is a V-by-1 array of vertex
%   weights associated with the dual power diagram and TRIA
%   is a T-by-3 array of vertex indexing, where each row de-
%   fines a triangle, such that VERT(TRIA(II,1),:),
%   VERT(TRIA(II,2),:) and VERT(TRIA(II,3),:) are the coord-
%   inates of the II-TH triangle.
%
%   See also TRISCR2, PWRBAL2

%   Darren Engwirda : 2017 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 03/05/2018

    nd = size(pp,2);

%--------------------------------------- compute ortho-balls
    of = pwrbal2(pp,pw,t2) ;            % and error checks!!

    o1 = pwrbal1(pp,pw,t2(:,[1, 2])) ;
    o2 = pwrbal1(pp,pw,t2(:,[2, 3])) ;
    o3 = pwrbal1(pp,pw,t2(:,[3, 1])) ;

%--------------------------------------- compute face mid.'s
    f0 = pp(t2(:,1),:)+pp(t2(:,2),:) ...
       + pp(t2(:,3),:);

    f0 = f0 / +3.0 ;

    e1 = pp(t2(:,1),:)+pp(t2(:,2),:) ;
    e2 = pp(t2(:,2),:)+pp(t2(:,3),:) ;
    e3 = pp(t2(:,3),:)+pp(t2(:,1),:) ;

    e1 = e1 / +2.0 ;
    e2 = e2 / +2.0 ;
    e3 = e3 / +2.0 ;

%--------------------------------------- compute face defect
    df = sum((of(:,1:nd) ...
             -f0(:,1:nd)).^2, 2) ;

    d1 = sum((o1(:,1:nd) ...
             -e1(:,1:nd)).^2, 2) ;
    d2 = sum((o2(:,1:nd) ...
             -e2(:,1:nd)).^2, 2) ;
    d3 = sum((o3(:,1:nd) ...
             -e3(:,1:nd)).^2, 2) ;

%--------------------------------------- characteristic len.
    r1 = sum(( ...
        pp(t2(:,2),1:nd)- ...
        pp(t2(:,1),1:nd)).^2, 2) ;
    r2 = sum(( ...
        pp(t2(:,3),1:nd)- ...
        pp(t2(:,2),1:nd)).^2, 2) ;
    r3 = sum(( ...
        pp(t2(:,1),1:nd)- ...
        pp(t2(:,3),1:nd)).^2, 2) ;

    r1 = r1 / +4.0 ;
    r2 = r2 / +4.0 ;
    r3 = r3 / +4.0 ;

    rb = (r1+r2+r3) / 3. ;

%--------------------------------------- form quality metric
    qf = +1.0 - df ./ rb ;

    q1 = +1.0 - d1 ./ r1 ;
    q2 = +1.0 - d2 ./ r2 ;
    q3 = +1.0 - d3 ./ r3 ;

    qe = (q1+q2+q3) / 3. ;

    sc = 0.50 * qf + 0.50 * qe ;

end



