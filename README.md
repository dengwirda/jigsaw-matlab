# JIGSAW: An unstrutured mesh generator

<p align="center">
  <img src = "../master/jigsaw/img/bunny-TRIA3-1.png"> &nbsp
  <img src = "../master/jigsaw/img/bunny-TRIA3-2.png"> &nbsp
  <img src = "../master/jigsaw/img/bunny-TRIA3-3.png"> &nbsp
  <img src = "../master/jigsaw/img/bunny-TRIA4-3.png">
</p>

**`JIGSAW`** is a Delaunay-based unstructured mesh generator for two- and three-dimensional geometries. It is designed to generate high-quality triangular and tetrahedral meshes for planar, surface and volumetric problems. **`JIGSAW`** is based on a recently developed "restricted" Frontal-Delaunay algorithm -- a hybrid technique combining many of the best features of advancing-front and Delaunay-refinement type approaches.

**`JIGSAW`** is a stand-alone mesh generator written in C++. This toolbox provides a `MATLAB` // `OCTAVE` based scripting interface, including file I/O, mesh visualisation and post-processing facilities. In addition to mesh generation, a set of file conversion utilities are also provided, allowing **`JIGSAW`** to read and write meshes using a number of popular geometry dialects, including the `VTK`, `OFF`, `STL` and `MESH` formats.

**`JIGSAW`** is currently available for 64-bit `Windows` and `Linux` platforms.

# Installation

**`JIGSAW`** itself is a fully self-contained executable, without dependencies on third-party libraries or run-time packages. To make use of **`JIGSAW`**'s  scripting interface, users are required to have access to a working <a href="http://www.mathworks.com">`MATLAB`</a> and/or <a href="https://www.gnu.org/software/octave">`OCTAVE`</a> installation.

# Getting Started

After downloading and unzipping the current **`JIGSAW`** <a href="https://github.com/dengwirda/jigsaw-matlab/archive/master.zip">repository</a>, navigate to the installation directory within `MATLAB` (`OCTAVE`) and see `meshdemo.m` for a list of example problems:
````
meshdemo(1); % build surface-meshes
meshdemo(2); % build volume-meshes
meshdemo(3); % preserve "sharp-features" in piecewise smooth domains
meshdemo(4); % build planar-meshes -- impose topological constraints
meshdemo(5); % build planar meshes -- explore mesh-size controls
````
Additional information, documentation, online tutorials and references are <a href="https://sites.google.com/site/dengwirda/jigsaw">available here</a>.
