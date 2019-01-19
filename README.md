## `JIGSAW: An unstructured mesh generator`

<p align="center">
  <img src = "../master/jigsaw/img/bunny-TRIA3-1.png"> &nbsp
  <img src = "../master/jigsaw/img/bunny-TRIA3-2.png"> &nbsp
  <img src = "../master/jigsaw/img/bunny-TRIA3-3.png"> &nbsp
  <img src = "../master/jigsaw/img/bunny-TRIA4-3.png">
</p>

`JIGSAW` is a computational library for unstructured mesh generation and tessellation; designed to generate high-quality triangulations and polyhedral decompositions of general planar, surface and volumetric domains. `JIGSAW` includes `refinement`-based algorithms for the construction of new meshes, `optimisation`-driven techniques for the improvement of existing grids, as well as routines to assemble (restricted) Delaunay tessellations and Voronoi complexes.

This package provides a <a href="http://www.mathworks.com">`MATLAB`</a> / <a href="http://www.gnu.org/software/octave">`OCTAVE`</a> based scripting interface to the underlying `JIGSAW` mesh generator, including a range of additional facilities for file I/O, mesh visualisation and post-processing operations.

`JIGSAW` has been compiled and tested on various `64-bit` `Linux` , `Windows` and `Mac` based platforms. 

## `Code Structure`

`JIGSAW` is a multi-part library, consisting of a `MATLAB` / `OCTAVE` front-end, and a core `c++` back-end. All of the heavy-lifting is done in the `c++` layer - the interface contains additional scripts for `file I/O`, `visualisation` and general `data processing`:

	├── JIGSAW  :: MATLAB/OCTAVE top-level functions
	├── script  -- MATLAB/OCTAVE utilities
	└── jigsaw
	    ├── src -- JIGSAW source files
	    ├── inc -- JIGSAW header files (for libjigsaw)
	    ├── bin -- put JIGSAW exe binaries here
	    ├── lib -- put JIGSAW lib binaries here
	    ├── geo -- default folder for JIGSAW inputs
	    ├── out -- default folder for JIGSAW output
	    └── uni -- unit tests and libjigsaw programs


The `MATLAB` / `OCTAVE` interface is provided for convenience - you're not forced to use it, but it's perhaps the easiest way to get started!

It's also possible to interact with the `JIGSAW` back-end directly, either through `(i)` scripting: building text file inputs and calling the `JIGSAW` executable from the command-line, or `(ii)` programmatically: using `JIGSAW` data-structures within your own applications and calling the library via its `API`.

## `Getting Started`

The first step is to compile the code! The `JIGSAW` src can be found in <a href="../master/jigsaw/src/">`../jigsaw/src/`</a>.

`JIGSAW` is a `header-only` package - there is only the single main `jigsaw.cpp` file that simply `#include`'s the rest of the library as headers. The resulting build process should be fairly straight-forward as a result. `JIGSAW` does not currently dependent on any external packages or libraries.

#### `On Linux/Mac`

`JIGSAW` has been successfully built using various versions of the `g++` and `llvm` compilers. Since the build process is a simple one-liner, there's no `make` script - instead:

	g++ -std=c++11 -pedantic -Wall -s -O3 -flto -D NDEBUG
	-D __cmd_jigsaw -static-libstdc++ jigsaw.cpp
	-o jigsaw64r
	
will build the main `JIGSAW` cmd-line executable,

	g++ -std=c++11 -pedantic -Wall -s -O3 -flto -D NDEBUG
	-D __cmd_tripod -static-libstdc++ jigsaw.cpp
	-o tripod64r
	
will build the `TRIPOD` cmd-line utility (`JIGSAW`'s tessellation infrastructure) and,

	g++ -std=c++11 -pedantic -Wall -O3 -flto -fPIC -D NDEBUG
	-D __lib_jigsaw -static-libstdc++ jigsaw.cpp
	-shared -o libjigsaw64r.so

will build `JIGSAW` as shared library. See the headers in <a href="../master/jigsaw/inc/">`../jigsaw/inc/`</a> for details on the `API`.

#### `On Windows`

`JIGSAW` has been successfully built using various versions of the `msvc` compiler. I do not provide a sample `msvc` project, but the following steps can be used to create one:

	* Create a new, empty MSVC project.
	* Import the jigsaw.cpp file, this contains the main() entry-point.

#### `Folder Structure`

Once you have built the `JIGSAW` binaries, place them in the appropriate sub-folders in`../jigsaw/bin/` and/or `../jigsaw/lib/` directories, so that they can be found by the `MATLAB` / `OCTAVE` interface, and the unit tests in `../jigsaw/uni/`. If you wish to support multiple platforms, simply build binaries for each `OS` and place them in the appropriate directory - the `MATLAB` / `OCATVE` interface will do an `OS`-dependent lookup to call the appropriate binary.

## `Example Problems`

After compiling and configuring the code, navigate to the `JIGSAW` installation directory in your <a href="http://www.mathworks.com">`MATLAB`</a> / <a href="https://www.gnu.org/software/octave">`OCTAVE`</a> environment and run the following set of example problems:
````
meshdemo(0); % simple 2-dim. examples to get started
meshdemo(1); % simple 3-dim. examples to get started
meshdemo(2); % frontal-delaunay methods for surfaces
meshdemo(3); % frontal-delaunay methods for volumes
meshdemo(4); % dealing with sharp-features in piecewise smooth domains
meshdemo(5); % dealing with user mesh-size controls
meshdemo(6); % dealing with topological constraints
meshdemo(7); % mesh iso-surface geometry -- (case 1)
meshdemo(8); % mesh iso-surface geometry -- (case 2)
````
Additionally, the <a href="../master/jigsaw/example.jig">`../jigsaw/example.jig`</a> file provides a description of `JIGSAW`'s configuration options, and can be used as a command-line example. A set of unit-tests and `libjigsaw` example programs are contained in <a href="../master/jigsaw/uni/">`../jigsaw/uni/`</a>. The `JIGSAW-API` is documented via the header files in <a href="../master/jigsaw/inc/">`../jigsaw/inc/`</a>. A repository of 3D surface models generated using `JIGSAW` can be found <a href="https://github.com/dengwirda/jigsaw-models">here</a>.

## `License`

This program may be freely redistributed under the condition that the copyright notices (including this entire header) are not removed, and no compensation is received through use of the software.  Private, research, and institutional use is free.  You may distribute modified versions of this code `UNDER THE CONDITION THAT THIS CODE AND ANY MODIFICATIONS MADE TO IT IN THE SAME FILE REMAIN UNDER COPYRIGHT OF THE ORIGINAL AUTHOR, BOTH SOURCE AND OBJECT CODE ARE MADE FREELY AVAILABLE WITHOUT CHARGE, AND CLEAR NOTICE IS GIVEN OF THE MODIFICATIONS`. Distribution of this code as part of a commercial system is permissible `ONLY BY DIRECT ARRANGEMENT WITH THE AUTHOR`. (If you are not directly supplying this code to a customer, and you are instead telling them how they can obtain it for free, then you are not required to make any arrangement with me.) 

`DISCLAIMER`:  Neither I nor: Columbia University, the Massachusetts Institute of Technology, the University of Sydney, nor the National Aeronautics and Space Administration warrant this code in any way whatsoever.  This code is provided "as-is" to be used at your own risk.

## `References`

There are a number of publications that describe the algorithms used in `JIGSAW` in detail. If you make use of `JIGSAW` in your work, please consider including a reference to the following:

`[1]` - Darren Engwirda: Generalised primal-dual grids for unstructured co-volume schemes, J. Comp. Phys., 375, pp. 155-176, https://doi.org/10.1016/j.jcp.2018.07.025, 2018.

`[2]` - Darren Engwirda, Conforming Restricted Delaunay Mesh Generation for Piecewise Smooth Complexes, Procedia Engineering, 163, pp. 84-96, https://doi.org/10.1016/j.proeng.2016.11.024, 2016.

`[3]` - Darren Engwirda, Voronoi-based Point-placement for Three-dimensional Delaunay-refinement, Procedia Engineering, 124, pp. 330-342, http://dx.doi.org/10.1016/j.proeng.2015.10.143, 2015.

`[4]` - Darren Engwirda, David Ivers, Off-centre Steiner points for Delaunay-refinement on curved surfaces, Computer-Aided Design, 72, pp. 157-171, http://dx.doi.org/10.1016/j.cad.2015.10.007, 2016.

`[5]` - Darren Engwirda, Locally-optimal Delaunay-refinement and optimisation-based mesh generation, Ph.D. Thesis, School of Mathematics and Statistics, The University of Sydney, http://hdl.handle.net/2123/13148, 2014.

