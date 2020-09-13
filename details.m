%-----------------------------------------------------------
%
%     ,o, ,o,       /
%      `   `  e88~88e  d88~\   /~~~8e Y88b    e    /
%     888 888 88   88 C888         88b Y88b  d8b  /
%     888 888 "8b_d8"  Y88b   e88~-888  Y888/Y88b/
%     888 888  /        888D C88   888   Y8/  Y8/
%     88P 888 Cb      \_88P   "8b_-888    Y    Y
%   \_8"       Y8""8D
%
%-----------------------------------------------------------
%   JIGSAW: an unstructured mesh generation library.
%-----------------------------------------------------------
%
%   JIGSAW is an unstructured mesh generator and tessellat-
%   ion library; designed to generate high-quality triangu-
%   lations and polyhedral decompositions of general planar
%   surface and volumetric domains. JIGSAW incorporates
%   refinement-based algorithms for the construction of new
%   meshes, optimisation driven techniques for the improve-
%   ment of existing grids, as well as routines to assemble
%   (restricted) Delaunay tessellations, Voronoi complexes
%   and Power diagrams.
%
% * INSTALLATION + SETUP
%
%   compile.m   - compile and install JIGSAW's c++ backend
%                 using cmake.
%
%   example.m   - a list of demo programs.
%
%   initjig.m   - config. path and init. global constants.
%
% * CORE FUNCTIONALITY
%
%   jigsaw.m    - an interface to JIGSAW's mesh generation
%                 + optimisation workflow.
%
%   tripod.m    - an interface to JIGSAW's "restricted"
%                 Delaunay triangulation framework.
%
%   marche.m    - an interface to JIGSAW's "fast-marching"
%                 Eikonal-type "gradient-limiters".
%
%   loadmsh.m   - load *.msh files.
%   savemsh.m   - save *.msh files.
%   loadjig.m   - load *.jig files.
%   savejig.m   - save *.jig files.
%
%   bisect.m    - refine a mesh obj. via bisection.
%   extrude.m   - create a mesh obj. via extrusion.
%
%   drawmesh.m  - draw mesh as 2- or 3-dim. "patch" object.
%
%   drawcost.m  - draw cost metrics associated with a mesh.
%
% * ADDITIONAL UTILITIES
%
%   Routines to pass data to/from various mesh file formats
%   can be found in ../parse.
%
%   Routines to compute mesh quality metrics, cell geometry
%   queries, map projections, etc can be found in ../tools.
%
%-----------------------------------------------------------
%   Darren Engwirda
%   github.com/dengwirda/jigsaw-matlab
%   26-Jul-2019
%   d.engwirda@gmail.com
%-----------------------------------------------------------
%
