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

// This is the utility scad file that will contain utility functions, utility modules.

include <math.scad>

/* creates a (key,value) entry.
 * name the name of the value
 * value the value
 */
function e(name,value) = [name, value];

/* gets a value from a vector of entries
 * this the vector of entries. Must contain [key, value] vectors. See e(name, value) to create these.
 * name the name of the value to get.
 */
function get(this, name) = this[search([name], this)[0]][1];

/* derives a new vector of entries by overriding the original entries with the
 * entries of the overrides. Override keys that are not present in original are ignored.
 *
 * original the original vector of entries
 * override the vector with the override entries
 */
function derive(original, overrides) = _derive(original, overrides, 0);
function _derive(original, overrides, index) =
	let(entry = original[index],
		override = get(overrides, entry[0]),
		derived = override == undef ? [entry] : [e(entry[0], override)])
	index == len(original)
		? []
		: concat(derived, _derive(original, overrides, index+1));

function box(w,d,h,others) = concat([e("w",w), e("d",d), e("h",h)], others);
function box_getW(this) = get(this, "w");
function box_getD(this) = get(this, "d");
function box_getH(this) = get(this, "h");

module ccube(v, center=true, hCenter=false) {
	h = len(v) == undef ? v : v[2];
	hOffset = hCenter ? h/2 : 0;
	translate([0, 0, hOffset]) cube(v, center=center);
}

module csphere(r, center=true) {
	sphere(r=r, center=center);
}

module ccylinder(r, h, center=true) {
	cylinder(r=r, h=h, center=center);
}

module mirror2(x) {
	children();
	mirror(x) children();
}

module symmetric(n) {
	angle = 360/n;
	for (m=[0 : n - 1]) {
		rotate([0, 0, angle*m]) children();
	}
}

module ellipse(r1, r2) {
	scale([r1, r2, 0])
		circle(r = 1);
}

module lens(P, Q, r) {
	s = lineLength(P, Q);
	
	A = [-s/2, 0];
	B = [s/2, 0];
	C1 = [0, r];
	C2 = [0, -r];
	
	circle1 = circleFromPoints(A, C1, B);
	circle2 = circleFromPoints(A, C2, B);
	
	PQ = pointBetween(P,Q);
	angle = lineXRotation(P, Q);
	
	translate([PQ[0], PQ[1], 0])
		rotate([0, 0, angle])
			intersection() {
				translate(circle1[0])
					circle(r = circle1[1]);
				translate(circle2[0])
					circle(r = circle2[1]);
			}
}
