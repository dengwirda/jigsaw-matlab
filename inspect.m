function [okay] = inspect(mesh,varargin)
%INSPECT helper routine to safely query a MESH structure.

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   30-May-2020
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    okay = false; base = ''; item = '';

    if (nargin >= +2), base = varargin{1}; end
    if (nargin >= +3), item = varargin{2}; end

    if (nargin <= +1 || nargin >= +4)
        error('inspect:incorrectNumbInputs' , ...
            'Incorrect number of arguments!') ;
    end

    if (~isstruct(mesh))
        error('inspect:incorrectInputClass' , ...
            'MESH must be a valid struct.') ;
    end
    if (~isempty(base) && ~ischar(base))
        error('inspect:incorrectInputClass' , ...
            'BASE must be a valid string!') ;
    end
    if (~isempty(item) && ~ischar(item))
        error('inspect:incorrectInputClass' , ...
            'ITEM must be a valid string!') ;
    end

    if (isempty(item))
%-- default ITEM kinds given BASE types
    switch (lower(base))
        case 'point', item = 'coord' ;
        case 'edge2', item = 'index' ;
        case 'tria3', item = 'index' ;
        case 'quad4', item = 'index' ;
        case 'tria4', item = 'index' ;
        case 'hexa8', item = 'index' ;
        case 'wedg6', item = 'index' ;
        case 'pyra5', item = 'index' ;
        case 'bound', item = 'index' ;
        case 'seeds', item = 'coord' ;
    end
    end

    if (isempty(item))
%-- check whether MESH.BASE exists
    okay = isfield(mesh, base) && ...
          ~isempty(mesh.(base)) ;
    else
%-- check whether MESH.BASE.ITEM exists
    okay = isfield(mesh, base) && ...
           isfield(mesh.(base), item) && ...
          ~isempty(mesh.(base).(item)) ;
    end

end



