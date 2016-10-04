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

// This is the finger pcb scad file containing the modules for drawing the finger unit PCB.
include <utility.scad>
include <lib.h.scad>
include <finger.h.scad>
include <pcb.scad>
include <finger_pcbInfo.scad>

module finger_pcb_comb(pcb) {
	constants = finger_pcb_getConstants(pcb);
	placement = finger_pcb_getPlacement(pcb);
	pcbInfo = finger_pcb_getPcbInfo(pcb);
	ledPair = finger_pcb_getLedPair(pcb);

	rInnerM3 = constants_getRInnerM3(constants);
	rOuterM3 = constants_getROuterM3(constants);
	rEdgeRimM3 = constants_getREdgeRimM3(constants);
	rVia = constants_getRVia(constants);

	angles = finger_placement_getAngles(placement);
	origins = finger_placement_getOrigins(placement);
	rGuard = finger_placement_getROuter(placement);
	ledGapDistance = finger_placement_getLedGapDistance(placement);
	sideLedOffset = finger_placement_getSideLedOffset(placement);
	downLedOffset = finger_placement_getDownLedOffset(placement);
	originOffset = finger_placement_getOriginOffset(placement);

	points = finger_pcbInfo_getPoints(pcbInfo);
	holesM3 = finger_pcbInfo_getMountHoleLocations(pcbInfo);

	intersection() {
		difference() {
			union() {
				polygon(points = points);
				for (o = origins) {
					translate(o)
						circle(r = rGuard);
				}
				for (hole = holesM3) {
					translate(hole)
						circle(r = rOuterM3 + rEdgeRimM3);
				}				
			}
			for (hole = holesM3) {
				translate(hole)
					circle(r = rInnerM3);
			}
			
			for (i = finger_fingers) {
				translate(finger_placement_calcOriginWithOffset(placement, i))
					rotate([0, 0, finger_vector_get(angles, i)]) {
						symmetric(4)
							translate([0, sideLedOffset, 0])
								viasLedPair2D(constants, ledPair, ledGapDistance);
						translate([0, downLedOffset, 0])
							viasLedPair2D(constants, ledPair, ledGapDistance);
					}
			}
		}
		finger_pcbInfo_outerPolygon_comb(pcbInfo);
	}
}

module finger_pcb_part(pcb, withColor = false) {
	pcbInfo = finger_pcb_getPcbInfo(pcb);
	h = finger_pcbInfo_getH(pcbInfo);
	color = withColor ? finger_pcb_getColor(pcb) : undef;
	
	color(color)
		translate([0, 0, -h/2])
			linear_extrude(height = h, center = true)
				finger_pcb_comb(pcb);
}