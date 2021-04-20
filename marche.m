function [varargout] = marche(opts)
%MARCHE an interface to JIGSAW's "gradient-limiting" solver.
%
%   HFUN = MARCHE(OPTS);
%
%   Call the "fast-marching" solver MARCHE using the config.
%   options specified in the OPTS structure. MARCHE solves
%   the Eikonal equations
%
%   MAX(|dh/dx|, g) = g,
%
%   where g = g(x) is a gradient threshold applied to h. See
%   the SAVEMSH/LOADMSH functions for a description of the
%   HFUN output structure.
%
%   OPTS is a user-defined set of meshing options:
%
%   REQUIRED fields:
%   ---------------
%
%   OPTS.HFUN_FILE - 'HFUNNAME.MSH', a string containing the
%       name of the file defining h(x). Data is overwritten
%       *in-place*. See SAVEMSH for additional details regar-
%       ding the creation of *.MSH files.
%
%   OPTS.JCFG_FILE - 'JCFGNAME.JIG', a string containing the
%       name of the cofig. file (will be created on output).
%
%   OPTIONAL fields (MISC):
%   ----------------------
%
%   OPTS.VERBOSITY - {default=0} verbosity of log-file gene-
%       rated by JIGSAW. Set VERBOSITY >= 1 for more output.
%
%   See also LOADMSH, SAVEMSH
%

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   18-Apr-2021
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

    jexename = '' ; status = -1 ;

    if ( isempty(opts))
        error('MARCHE: insufficient inputs!!') ;
    end

    if (~isempty(opts) && ~isstruct(opts))
        error('MARCHE: invalid input types!!') ;
    end

    savejig(opts.jcfg_file,opts);

%---------------------------- set-up path for "local" binary
    if (strcmp(jexename,''))

    filename = ...
            mfilename('fullpath') ;
    filepath = ...
            fileparts( filename ) ;

    if (ispc())
        jexename = [filepath, ...
    '\external\jigsaw\bin\marche.exe'];
    elseif (ismac ())
        jexename = [filepath, ...
    '/external/jigsaw/bin/marche'];
    elseif (isunix())
        jexename = [filepath, ...
    '/external/jigsaw/bin/marche'];
    end
    end

    if (exist(jexename,'file')~=2), jexename=''; end

%---------------------------- search machine path for binary
    if (strcmp(jexename,''))
    if (ispc())
        jexename =       'marche.exe' ;
    elseif (ismac ())
        jexename =       'marche' ;
    elseif (isunix())
        jexename =       'marche' ;
    end
    end

    if (exist(jexename,'file')~=2), jexename=''; end

%---------------------------- call MARCHE and capture stdout
    if (exist(jexename,'file')==2)

   [status, result] = system( ...
        ['"',jexename,'"',' ','"',opts.jcfg_file,'"'], ...
            '-echo') ;

%---------------------------- OCTAVE doesn't handle '-echo'!
    if (exist('OCTAVE_VERSION', 'builtin') > 0)
        fprintf(1, '%s', result) ;
    end

    else
%---------------------------- couldn't find JIGSAW's backend
        error([ ...
        'MARCHE''s executable not found -- ', ...
        'has JIGSAW been compiled from src?', ...
        'See COMPILE for additional detail.', ...
            ] ) ;
    end

    if (nargout == +1)
%---------------------------- read mesh if output requested!
    if (status  == +0)
    varargout{1} = loadmsh (opts.hfun_file) ;
    else
    varargout{1} = [];
    end

    end

end



