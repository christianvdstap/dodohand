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
// This is the thumb.scad file containing the modules to draw various thumb unit assemblies.

include <utility.scad>
include <thumb_pcb.scad>
include <thumb_carrier.scad>

module thumb_placeSideCarrier(downCarrier, sideCarrier, angle, origin, key = "A", sidePosition) {
	translate(origin)
		rotate([0, 0, angle])
			thumb_sideCarrier_assy(downCarrier, sideCarrier, key, sidePosition);
}

module thumb_assy(pcb, downCarrier, sideCarrier, downPosition = "up",
					sidePositions = thumb_vector("down","down","down","down")) {
	downKey = thumb_downCarrier_getDownKey(downCarrier);
	hCarrier = thumb_downCarrier_getH(downCarrier);
	dCarrier = thumb_downCarrier_calcD(downCarrier);
	tHinge = thumb_downKey_calcTHinge(downKey);
	placement = thumb_pcb_getPlacement(pcb);
						
	keyIds = thumb_vector("A", "B", "C", "D");

	union() {
		thumb_pcb_part(pcb, true);
		translate([0, 0, 0.01]) {
			translate([0, 0, hCarrier/2])
				thumb_downCarrier_assy(downCarrier, downPosition);		
			translate([0, -dCarrier/2 - tHinge/2, 0]) {
				for (key = thumb_keys) {
					angle = thumb_placement_getSideAngle(placement, key);
					origin = thumb_placement_getSideOrigin(placement, key);
					keyId = thumb_vector_get(keyIds, key);
					position = thumb_vector_get(sidePositions, key);
					thumb_placeSideCarrier(downCarrier, sideCarrier, angle, origin, keyId, position);
					
					echo(keyId, angle=angle, origin=origin);
				}
			}
		}

	}
	
}
