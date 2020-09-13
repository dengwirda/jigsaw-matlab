function drawquad_4(pp,q4,varargin)
%DRAWQUAD-4 draw QUAD-4 elements defined by [PP,Q4].
%   DRAWQUAD_4(PP,Q4) draws elements onto the current axes,
%   where PP is an NP-by-ND array of vertex positions and
%   Q4 is an NQ-by-4 array of cell-indexing. Additional
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

    if (isempty(q4)), return; end

    if (nargin <= +2)
        args = {
            'edgecolor',[.2,.2,.2], ...
            'facecolor',[.5,.8,.9], ...
            'linewidth',7.5E-01, ...
            } ;
    else
        args = {varargin{ :}} ;
    end

    patch('faces',q4,'vertices',pp, ...
        args{ :}) ;

end



