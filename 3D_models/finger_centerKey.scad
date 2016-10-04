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

// This is the finger center key scad file containing the modules to draw the center key hammer and keycap.
include <utility.scad>
include <lib.h.scad>
include <finger.h.scad>

module finger_centerKey_hammer_comb(centerHammer) {
	constants = finger_centerHammer_getConstants(centerHammer);

	clearance = constants_getClearance(constants);
	tWall = constants_calcTWall(constants);

	h = finger_centerHammer_calcH(centerHammer);
	side = finger_centerHammer_calcSide(centerHammer) - tWall;
	
	sideCavity = finger_centerHammer_calcSideCavity(centerHammer);
	rHolder = side / 3;
	
	translate([0, 0, -h + side/2]) {
		difference() {
			union() {
				ccube([side, side, h - side/2], hCenter = true);
				symmetric(4) 
					difference() {
						ccube([side/2 + tWall, side + tWall, h - side/2], hCenter = true);
						ccube([side/2, side*2, h*2]);
					}
				rotate([0, 90, 0])
					ccylinder(r = side/2, h = side);
				mirror2([1, 0, 0])
					translate([side/2 - tWall/2, 0, -side/2 + rHolder + clearance])
						sphere(r = rHolder);
			}
			translate([0, 0, h/2 - side/4])
				union() {
					rotate([90, 0, 0])
						ccylinder(r = side/4, h = side*2);
					translate([0, 0, -h/2])
						ccube([side/2, side*2, h]);
				}
		}
	}
}

module finger_centerKey_hammer_part(centerHammer, withColor = false) {
	color = withColor ? finger_centerHammer_getColor(centerHammer) : undef;
	
	color(color) finger_centerKey_hammer_comb(centerHammer);
}

module finger_centerKey_cap_comb(centerKeyCap) {
	constants = finger_centerKeyCap_getConstants(centerKeyCap);
	r = finger_centerKeyCap_calcR(centerKeyCap);
	t = finger_centerKeyCap_calcT(centerKeyCap);
	x = constants_calcTWall(constants);
	
	rCircle = r * 5/3;

	hIntersectOffset = pythagoras(h = rCircle, a = r);
	
	translate([0, 0, t/2]) {
		intersection() {
			difference() {
				ccylinder(r = r, h = t);
				translate([0, 0, rCircle])
					sphere(r = rCircle, $fn = 32);
			}
			translate([0, 0, -hIntersectOffset])
				sphere(r = rCircle);
		}
	}
}

module finger_centerKey_cap_part(centerKeyCap, withColor = false) {
	color = withColor ? finger_centerKeyCap_getColor(centerKeyCap) : undef;
	
	color(color) finger_centerKey_cap_comb(centerKeyCap);
}

module finger_centerKey_part(carrier, withColor = false) {
	centerHammer = finger_centerHammer(carrier);
	centerKeyCap = finger_centerKeyCap(carrier);
	
	finger_centerKey_hammer_part(centerHammer, withColor);
	finger_centerKey_cap_part(centerKeyCap, withColor);
}