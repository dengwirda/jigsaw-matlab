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
%   15-Jan-2023
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

   [okay, cout] = system('cmake --version') ;

    vstr = find_ver_str(split(lower(cout))) ;
    
    if (any(str2double(vstr)-[3,12,0] < 0)) % cmake-3.12.0
    
   [okay, cout] = system( ...
        'cmake --build . --config Release --target install', ...
            '-echo') ;

    else

   [okay, cout] = system( ...
       ['cmake --build . --config Release --target install', ...
        ' --parallel 4'], '-echo') ;

    end

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

function [vstr] = find_ver_str(cstr)

    vstr = '' ;
    for ii = +1:length(cstr)
        tstr = regexp( cstr{ii},'\.','split') ;
        if (length(tstr) == 3 && ...
               ~any(isnan(str2double(tstr))))
            vstr = tstr; return;
        end
    end

end



