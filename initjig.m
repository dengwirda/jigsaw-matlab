function initjig
%INITJIG a helper function to set-up MATLAB's path statement
%and load global constants for JIGSAW.
%
%   See also EXAMPLE, DETAILS

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   26-Jul-2019
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%

%------------------------------------ push path to utilities

    filename = mfilename('fullpath') ;
    filepath = fileparts( filename ) ;

    addpath( ...
    genpath( [filepath, '/tools'] )) ;

    addpath( ...
    genpath( [filepath, '/parse'] )) ;

%------------------------------------ define JIGSAW's const.

    globals  ;

end



