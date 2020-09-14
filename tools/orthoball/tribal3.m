function [bb] = tribal3(pp,tt)
%TRIBAL3 compute the circumballs associated with a 3-simplex
%triangulation embedded in R^3.
%   [BB] = TRIBAL3(PP,TT) returns the circumscribing balls
%   associated with the triangles in [PP,TT], such that BB =
%   [XC,YC,ZC,RC.^2].

%   Darren Engwirda : 2017 --
%   Email           : d.engwirda@gmail.com
%   Last updated    : 20/06/2018

    bb = pwrbal3(pp,zeros(size(pp,1),1),tt) ;

end



