function [sc] = pwrscr3(pp,pw,t3)
%PWRSCR3 calc. a dual grid quality metric for triangles in a
%3-simplex triangulation in R^3.
%   [SCR3] = PWRSCR3(VERT,VPWR,TRIA) returns the dual metric
%   where SCR3 is a T-by-1 vector, VERT is a V-by-D array of
%   XY, or XYZ coordinates, VPWR is a V-by-1 array of vertex
%   weights associated with the dual power diagram and TRIA
%   is a T-by-4 array of vertex indexing, where each row de-
%   fines a triangle, such that VERT(TRIA(II,1),:), ... ,
%   VERT(TRIA(II,4),:), are the coordinates associated with
%   the II-TH simplex.
%
%   See also TRISCR3, PWRBAL3

%   Darren Engwirda : 2018 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 20/06/2018

    nd = size(pp,2);

%--------------------------------------- compute ortho-balls
    of = pwrbal3(pp,pw,t3) ;            % and error checks!!

    o1 = pwrbal1(pp,pw,t3(:,[1, 2])) ;
    o2 = pwrbal1(pp,pw,t3(:,[2, 3])) ;
    o3 = pwrbal1(pp,pw,t3(:,[3, 1])) ;
    o4 = pwrbal1(pp,pw,t3(:,[1, 4])) ;
    o5 = pwrbal1(pp,pw,t3(:,[2, 4])) ;
    o6 = pwrbal1(pp,pw,t3(:,[3, 4])) ;

%--------------------------------------- compute cell mid.'s
    f0 = pp(t3(:,1),:)+pp(t3(:,2),:) ...
       + pp(t3(:,3),:)+pp(t3(:,4),:) ;

    f0 = f0 / +4.0 ;

    e1 = pp(t3(:,1),:)+pp(t3(:,2),:) ;
    e2 = pp(t3(:,2),:)+pp(t3(:,3),:) ;
    e3 = pp(t3(:,3),:)+pp(t3(:,1),:) ;
    e4 = pp(t3(:,1),:)+pp(t3(:,4),:) ;
    e5 = pp(t3(:,2),:)+pp(t3(:,4),:) ;
    e6 = pp(t3(:,3),:)+pp(t3(:,4),:) ;

    e1 = e1 / +2.0 ;
    e2 = e2 / +2.0 ;
    e3 = e3 / +2.0 ;
    e4 = e4 / +2.0 ;
    e5 = e5 / +2.0 ;
    e6 = e6 / +2.0 ;

%--------------------------------------- compute face defect
    df = sum((of(:,1:nd) ...
             -f0(:,1:nd)).^2, 2) ;

    d1 = sum((o1(:,1:nd) ...
             -e1(:,1:nd)).^2, 2) ;
    d2 = sum((o2(:,1:nd) ...
             -e2(:,1:nd)).^2, 2) ;
    d3 = sum((o3(:,1:nd) ...
             -e3(:,1:nd)).^2, 2) ;
    d4 = sum((o4(:,1:nd) ...
             -e4(:,1:nd)).^2, 2) ;
    d5 = sum((o5(:,1:nd) ...
             -e5(:,1:nd)).^2, 2) ;
    d6 = sum((o6(:,1:nd) ...
             -e6(:,1:nd)).^2, 2) ;

%--------------------------------------- characteristic len.
    r1 = sum(( ...
        pp(t3(:,2),1:nd)- ...
        pp(t3(:,1),1:nd)).^2, 2) ;
    r2 = sum(( ...
        pp(t3(:,3),1:nd)- ...
        pp(t3(:,2),1:nd)).^2, 2) ;
    r3 = sum(( ...
        pp(t3(:,1),1:nd)- ...
        pp(t3(:,3),1:nd)).^2, 2) ;
    r4 = sum(( ...
        pp(t3(:,1),1:nd)- ...
        pp(t3(:,4),1:nd)).^2, 2) ;
    r5 = sum(( ...
        pp(t3(:,2),1:nd)- ...
        pp(t3(:,4),1:nd)).^2, 2) ;
    r6 = sum(( ...
        pp(t3(:,3),1:nd)- ...
        pp(t3(:,4),1:nd)).^2, 2) ;

    r1 = r1 / +4.0 ;
    r2 = r2 / +4.0 ;
    r3 = r3 / +4.0 ;
    r4 = r4 / +4.0 ;
    r5 = r5 / +4.0 ;
    r6 = r6 / +4.0 ;

    rb = (r1+r2+r3+r4+r5+r6) /6. ;

%--------------------------------------- form quality metric
    qf = +1.0 - df ./ rb ;

    q1 = +1.0 - d1 ./ r1 ;
    q2 = +1.0 - d2 ./ r2 ;
    q3 = +1.0 - d3 ./ r3 ;
    q4 = +1.0 - d4 ./ r4 ;
    q5 = +1.0 - d5 ./ r5 ;
    q6 = +1.0 - d6 ./ r6 ;

    qe = (q1+q2+q3+q4+q5+q6) /6. ;

    sc = 0.50 * qf + 0.50 * qe ;

end



