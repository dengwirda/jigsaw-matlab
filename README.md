# `JIGSAW: An unstrutured mesh generator`

<p align="center">
  <img src = "../master/jigsaw/img/bunny-TRIA3-1.png"> &nbsp
  <img src = "../master/jigsaw/img/bunny-TRIA3-2.png"> &nbsp
  <img src = "../master/jigsaw/img/bunny-TRIA3-3.png"> &nbsp
  <img src = "../master/jigsaw/img/bunny-TRIA4-3.png">
</p>

<a href="https://sites.google.com/site/dengwirda/jigsaw">`JIGSAW`</a> is a Delaunay-based unstructured mesh generator for two- and three-dimensional geometries. It is designed to generate high-quality triangular and tetrahedral meshes for planar, surface and volumetric problems. `JIGSAW` is based on a recently developed "restricted" Frontal-Delaunay algorithm -- a hybrid technique combining many of the best features of advancing-front and Delaunay-refinement type approaches.

`JIGSAW` is a stand-alone mesh generator written in `C++`. This toolbox provides a <a href="http://www.mathworks.com">`MATLAB`</a> / <a href="https://www.gnu.org/software/octave">`OCTAVE`</a> based scripting interface, including file I/O, mesh visualisation and post-processing facilities. In addition to mesh generation, a set of file conversion utilities are also provided, allowing `JIGSAW` to read and write meshes using a number of popular geometry dialects, including the `VTK`, `OFF`, `STL` and `MESH` formats.

`JIGSAW` is currently available for `64-bit` `Windows` and `Linux` platforms.

[![DOI](https://zenodo.org/badge/doi/10.5281/zenodo.56400.svg)](http://dx.doi.org/10.5281/zenodo.56400)

# `Installation`

`JIGSAW` itself is a fully self-contained executable, without dependencies on third-party libraries or run-time packages. To make use of `JIGSAW`'s  scripting interface, users are required to have access to a working <a href="http://www.mathworks.com">`MATLAB`</a> and/or <a href="https://www.gnu.org/software/octave">`OCTAVE`</a> installation.

# `Starting Out`

After downloading and unzipping the current <a href="https://github.com/dengwirda/jigsaw-matlab/archive/master.zip">repository</a>, navigate to the installation directory within <a href="http://www.mathworks.com">`MATLAB`</a> / <a href="https://www.gnu.org/software/octave">`OCTAVE`</a> and run the set of examples contained in `meshdemo.m`:
````
meshdemo(1); % build surface-meshes
meshdemo(2); % build volume-meshes
meshdemo(3); % preserve "sharp-features" in piecewise smooth domains
meshdemo(4); % build planar-meshes -- impose topological constraints
meshdemo(5); % build planar-meshes -- explore mesh-size controls
meshdemo(6); % mesh iso-surface geometry -- case 1
meshdemo(7); % mesh iso-surface geometry -- case 2
````
Additional information, documentation, online tutorials and references are available <a href="https://sites.google.com/site/dengwirda/jigsaw">here</a>. A repository of 3D surface models generated using `JIGSAW` can be found <a href="https://github.com/dengwirda/jigsaw-models">here</a>.

# `Attribution!`

If you make use of `JIGSAW` please reference appropriately. The algorithmic developments behind `JIGSAW` have been the subject of a number of publications, beginning with my PhD research at the University of Sydney:

`[1]` - Darren Engwirda, Locally-optimal Delaunay-refinement and optimisation-based mesh generation, Ph.D. Thesis, School of Mathematics and Statistics, The University of Sydney, September 2014, http://hdl.handle.net/2123/13148.

`[2]` - Darren Engwirda, David Ivers, Off-centre Steiner points for Delaunay-refinement on curved surfaces, Computer-Aided Design, Volume 72, March 2016, Pages 157-171, ISSN 0010-4485, http://dx.doi.org/10.1016/j.cad.2015.10.007.

`[3]` - Darren Engwirda, Voronoi-based Point-placement for Three-dimensional Delaunay-refinement, Procedia Engineering, Volume 124, 2015, Pages 330-342, ISSN 1877-7058, http://dx.doi.org/10.1016/j.proeng.2015.10.143. 

`[4]` - Darren Engwirda, Conforming restricted Delaunay mesh generation for piecewise smooth complexes, Submitted to the 25th International Meshing Roundtable, (https://arxiv.org/abs/1606.01289), 2016. Keywords: Three-dimensional mesh generation, restricted Delaunay, Delaunay-refinement, Advancing-front, Frontal-Delaunay, Off-centres, Sharp-features.


