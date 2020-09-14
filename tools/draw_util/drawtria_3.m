function drawtria_3(pp,t3,varargin)
%DRAWTRIA-3 draw TRIA-3 elements defined by [PP,T3].
%   DRAWTRIA_3(PP,T3) draws elements onto the current axes,
%   where PP is an NP-by-ND array of vertex positions and
%   T3 is an NT-by-3 array of cell-indexing. Additional
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

    if (isempty(t3)), return; end

    if (nargin <= +2)
        args = {
            'edgecolor',[.2,.2,.2], ...
            'facecolor',[.9,.9,.5], ...
            'linewidth',7.5E-01, ...
            } ;
    else
        args = {varargin{ :}} ;
    end

    patch('faces',t3,'vertices',pp, ...
        args{ :}) ;

end



