function compile
%COMPILE compile JIGSAW's c++ backend using cmake.
%
%   COMPILE tries to compile JIGSAW from the c++ source code
%   available in ../external/jigsaw. The cmake utility and a
%   c++ compiler must be available on the system path.
%
%   On success, JIGSAW is installed in ../external/jigsaw.
%
%   The cmake workflow has been tested on various Linux, Mac
%   and Windows-based systems, using the gcc, clang and msvc
%   compilers.
%
%   See also EXAMPLE, DETAILS

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   26-Jul-2019
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

   [here] = fileparts( ...
            mfilename(  'fullpath'  ) ) ;

   [okay] = mkdir(here,'external/jigsaw/build');

    cd([here,'/external/jigsaw/build']) ;

    try

   [okay, cout] = system( ...
        'cmake .. -DCMAKE_BUILD_TYPE=Release', '-echo');

    if (exist('OCTAVE_VERSION', 'builtin') > 0)
        fprintf(+1, '%s', cout) ;
    end

   [okay, cout] = system( ...
        'cmake --build . --config Release --target install', ...
            '-echo') ;

    if (exist('OCTAVE_VERSION', 'builtin') > 0)
        fprintf(+1, '%s', cout) ;
    end

    cd(here) ;

   [okay] = rmdir([here,'/external/jigsaw/build'], 's');

    catch err

    cd(here) ;

   [okay] = rmdir([here,'/external/jigsaw/build'], 's');

    rethrow(err) ;

    end

end



