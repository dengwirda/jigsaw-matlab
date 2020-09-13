function drawedge_2(pp,e2,varargin)
%DRAWEDGE-2 draw EDGE-2 elements defined by [PP,E2].
%   DRAWEDGE_2(PP,E2) draws elements onto the current axes,
%   where PP is an NP-by-ND array of vertex positions and
%   E2 is an NE-by-2 array of edge-indexing. Additional
%   plotting arguments can be passed as name / value pairs.
%
%   See also DRAWMESH

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   13-Aug-2018
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    if (isempty(e2)), return; end

    if (nargin <= +2)
        args = {
            'color',[.2,.2,.2], ...
            'linewidth',1.E+00, ...
            } ;
    else
        args = {varargin{ :}} ;
    end

    switch (size(pp,2))
    %-- draw this way for OCTAVE - it doesn't
    %   enjoy alternate LINE() syntax, and/or
    %   degenerate polygons via PATCH()...

        case +2
    %-- draw lines in R^2
        xx = [pp(e2(:,1),1), ...
              pp(e2(:,2),1), ...
        NaN * ones(size(e2,1),1)]';
        yy = [pp(e2(:,1),2), ...
              pp(e2(:,2),2), ...
        NaN * ones(size(e2,1),1)]';

        line('xdata',xx( :), ...
             'ydata',yy( :), ...
             args{:}) ;

        case +3
    %-- draw lines in R^3
        xx = [pp(e2(:,1),1), ...
              pp(e2(:,2),1), ...
        NaN * ones(size(e2,1),1)]';
        yy = [pp(e2(:,1),2), ...
              pp(e2(:,2),2), ...
        NaN * ones(size(e2,1),1)]';
        zz = [pp(e2(:,1),3), ...
              pp(e2(:,2),3), ...
        NaN * ones(size(e2,1),1)]';

        line('xdata',xx( :), ...
             'ydata',yy( :), ...
             'zdata',zz( :), ...
             args{:}) ;

    end

end



