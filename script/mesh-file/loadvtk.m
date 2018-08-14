function [mesh] = readvtk(name)
%LOADVTK read an *.VTK file for JIGSAW.
%
%   MESH = LOADVTK(NAME);
%
%   The following entities are optionally read from the file
%   "NAME.VTK":
%
%   MESH.POINT.COORD - [NPxND+1] array of point coordinates, 
%       where ND is the number of spatial dimenions.
%
%   MESH.TRIA3.INDEX - [N3x 4] array of indexing for TRIA-3 
%       elements, where INDEX(K,1:3) is an array of "points" 
%       associated with the K-TH tria, and INDEX(K,4) is an 
%       associated ID tag.
%
%   See also SAVEMSH, LOADMSH, SAVESTL, LOADSTL, SAVEVTK, 
%            SAVEOFF, LOADOFF, 
%            

%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   14-Jul-2018
%   darren.engwirda@columbia.edu
%-----------------------------------------------------------
%


end



