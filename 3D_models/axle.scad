/*
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
*/

// This is the axle scad file containing the modules to draw axles.
include <utility.scad>
include <axle.h.scad>

module axle_part(axle, withColor = false) {
	r = axle_getR(axle);
	w = axle_getW(axle);
	color = withColor ? axle_getColor(axle) : undef;

	rotate([0, 90, 0]) 
		color(color)
			ccylinder(r = r, h = w);
}

module axle_example() {
	axle = axle(r = 0.8, w = 10, color = "LightGrey");
	
	axle_part(axle, true);
}
