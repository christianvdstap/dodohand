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

// This is the magnet scad file containing modules to draw magnets.
include <utility.scad>
include <magnet.h.scad>

module magnet_comb(magnet) {
	w = magnet_getW(magnet);
	d = magnet_getD(magnet);
	h = magnet_getH(magnet);
	ccube([w, d, h]);
}

module magnet_part(magnet, withColor=false) {
	color = withColor ? magnet_getColor(magnet) : undef;

	color(color) magnet_comb(magnet);
}

module magnet_example() {
	magnet = magnet(
		w = 4,
		d = 5,
		h = 1,
		color="Silver"
	);
	magnet_part(magnet);
}
