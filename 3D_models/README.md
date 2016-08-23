=========================================================================
This file is part of the DodoHand project. This project aims to create
an open implementation of the DataHand keyboard, capable of being created
with commercial 3D printing services.

Copyright (C) 2016 Christian van der Stap

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
=========================================================================


Since openscad does not have a higher organisation (like objects) a certain pattern is followed in these source files.

The source files for the 3d objects are structured as follows:

There are 3 types of files, header, module and xcf files. The header files end with .h.scad and the module files end with just .scad. The header files contain the object definitions and calculations needed by the module files. The file names themselves start with the namespace name of their contents. If a further split is required the file names is extended by an underscore (\_) and a logical name for the contents. The xcf files (gimp source files) contain visual documentation of specific mathematical solutions to measurements, their file name points to the calculation functions.

Header files contain constructors, accessors and calculations.
- Constructors are functions that will create a map based on named value. There name is [namespace]\_[objectName].
- Accessors are functions to retrieve the values from the object. There name is [namespace]\_[objectName]\_get[valueName].
- Calculations are functions to calculate derived values from the object. There name is [namespace]\_[objectName]\_calc[calcName].

The reason behind the header files is to cut potential circular dependencies between different module files and to focus on drawing things in the module files. The objects are used to make defining modules easier since only a single parameter for the values have to be passed (even though its more typing to get the values from the objects).

Module files contain 4 categories of modules combinations, parts, assemblies and placements.
- Combinations are groups of solids that make up a section of a part, without being used in a part the have no meaning. There name will be [namespace]\_[objectName]\_[moduleName]\_comb.
- Parts combine combinations in to actual parts. A part is a single element that can be hold / purchased / 3d printed. Parts are also the place the assign color etc. There name will be [namespace]\_[objectName]\_[moduleName]\_part.
- Assemblies are several parts together that will provide a function.There name will be [namespace]\_[objectName]\_[moduleName]\_assy
- Placements are operators to place modules. There name will be [namespace]\_[objectName]\_[moduleName]\_place

