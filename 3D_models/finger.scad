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

// This is the finger.scad file containing the modules to draw various finger unit assemblies.
include <utility.scad>
include <finger.h.scad>
include <finger_guard.scad>
include <finger_pcb.scad>
include <finger_carrier.scad>


module finger_keyCap_part(){}
module finger_centerKeyCap_part(){}
module finger_centerHammer(){}

module finger_assy(pcb, carrier, guard) {
	placement = finger_carrier_getPlacement(carrier);
	
	angles = finger_placement_getAngles(placement);

	hCarrier = finger_carrier_getH(carrier);
	
	union() {
		translate([0,0,-0.01])
			finger_pcb_part(pcb, withColor=true);
		finger_guard_assy(guard, withColor=true);
		for (f = finger_fingers) {
			a = finger_vector_get(angles, f);
			translate([0, 0, hCarrier/2 - 0.05])
				translate(finger_placement_calcOriginWithOffset(placement, f))
					rotate([0, 0, a]) {
						finger_carrier_inner_assy(carrier);
						finger_carrier_outer_assy(carrier);
					}
		}
	}
}

// S, E, N, W, D
module finger_single_assy(carrier, leverPositions = ["up","up","up","up","up"]) {
	union() {
		finger_carrier_inner_assy(carrier, leverPositions[4]);
		translate([0, 0, 0])
			finger_carrier_outer_assy(carrier, leverPositions);
	}
}
