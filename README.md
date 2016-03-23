# JIGSAW: an unstrutured mesh generator

<p align="center">
  <img src = "../master/jigsaw/img/bunny-TRIA3-1.png"> &nbsp
  <img src = "../master/jigsaw/img/bunny-TRIA3-2.png"> &nbsp
  <img src = "../master/jigsaw/img/bunny-TRIA3-3.png"> &nbsp
  <img src = "../master/jigsaw/img/bunny-TRIA4-3.png">
</p>

<b>JIGSAW</b> is a Delaunay-based unstructured mesh generator for two- and three-dimensional geometries. It is designed to generate high-quality triangular and tetrahedral meshes for planar, surface and volumetric problems. <b>JIGSAW</b> is based on a recently developed 'Frontal-Delaunay' algorithm -- a hybrid technique combining the best features of 'Advancing-Front' and 'Delaunay-Refinement' type approaches.

<b>JIGSAW</b> is a stand-alone mesh generator written in C++. This toolbox provides a <b>MATLAB</b> // <b>OCTAVE</b> interface, including file I/O, mesh visualisation and post-processing facilities. In addition to mesh generation, a set of file conversion utilities are also provided, allowing <b>JIGSAW</b> to read and write meshes using a number of popular geometry formats, including the <b>VTK</b>, <b>OFF</b>, <b>STL</b> and <b>MESH</b> formats.

<b>JIGSAW</b> is currently available for 64-bit Windows and Linux platforms.

# Getting Started

After downloading the current <b>JIGSAW</b> <a href="https://github.com/dengwirda/jigsaw-matlab/archive/master.zip">repository</a>, see `meshdemo.m` for a list of example problems:
````
meshdemo(1); % build surface-meshes
meshdemo(2); % build volume-meshes
meshdemo(3); % preserve "sharp-features" in piecewise smooth domains
meshdemo(4); % build planar-meshes -- impose topological constraints
meshdemo(5); % build planar meshes -- explore mesh-size controls
````
Additional information, documentation, online tutorials and references are <a href="https://sites.google.com/site/dengwirda/jigsaw">available here</a>.
