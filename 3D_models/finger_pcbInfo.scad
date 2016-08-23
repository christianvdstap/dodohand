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

// This is the pcb info scad file containing the modules to draw the bounding polygon of the finger PCB.
include <utility.scad>
include <finger.h.scad>

module finger_pcbInfo_outerPolygon_comb(pcbInfo) {
	points = finger_pcbInfo_getPoints(pcbInfo);

	minX = minAxis(points, 0, 0);
	minY = minAxis(points, 1, 0);
	maxX = maxAxis(points, 0, 0);
	maxY = maxAxis(points, 1, 0);
	
	polygon(points=[[minX, minY], [minX, maxY], [maxX, maxY], [maxX, minY]]);
}
