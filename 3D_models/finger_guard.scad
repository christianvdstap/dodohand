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

// This is the finger guard scad file containing the modules for drawing the finger guard.
include <utility.scad>
include <finger.h.scad>
include <finger_pcbInfo.scad>
include <lib.h.scad>

module finger_guard_comb(guard) {
	constants = finger_guard_getConstants(guard);
	placement = finger_guard_getPlacement(guard);
	pcbInfo = finger_guard_getPcbInfo(guard);

	rInnerHole = constants_getRInnerM3(constants);
	rOuterHole = constants_getROuterM3(constants);
	
	rInner = finger_placement_getRInner(placement);
	rOuter = finger_placement_getROuter(placement);
	origins = finger_placement_getOrigins(placement);
	originOffset = finger_placement_getOriginOffset(placement);

	holes = finger_pcbInfo_getMountHoleLocations(pcbInfo);
	
	h = finger_guard_getH(guard);
	hFlange = finger_guard_getHFlange(guard);
	hPinkie = finger_guard_getHPinkie(guard);
	mountHoleIndexes = finger_guard_getMountHoleIndexes(guard);
	tWall = finger_guard_calcTGuardWall(guard);
	
	module base_comb(h) {
		cylinder(r = rOuter, h = hFlange);
		cylinder(r = rInner + tWall, h = h);
	}
	
	difference() {
		union() {
			for (f = [finger_index, finger_middle, finger_ring]) {
				translate(finger_placement_calcOriginWithOffset(placement, f))
					base_comb(h);
			}
			translate(finger_placement_calcOriginWithOffset(placement, finger_pinkie))
				base_comb(hPinkie);			

			for (i = mountHoleIndexes) {
				translate(holes[i])
					cylinder(r = rOuterHole, h = hFlange);
			}
		}

		for (f = finger_fingers) {
			o = finger_placement_calcOriginWithOffset(placement, f);
			translate(o)
				translate([0, 0, -h/2]) 
					cylinder(r = rInner, h = h*2);
		}
		for (i = mountHoleIndexes) {
			translate(holes[i])
				translate([0, 0, -hFlange/2])
					cylinder(r = rInnerHole, h = hFlange*2);
		}
	}	
}

module finger_guard_part(guard, withColor=false) {
	color = withColor ? finger_guard_getColor(guard) : undef;

	color(color) finger_guard_comb(guard);
}

module finger_guard_assy(guard) {
	h = finger_guard_getH(guard);
	pcbInfo = finger_guard_getPcbInfo(guard);
	
	intersection() {
		finger_guard_part(guard, withColor = true);
		linear_extrude(h = h) finger_pcbInfo_outerPolygon_comb(pcbInfo);
	}
}
