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
// This is the thumb pcb scad file containing the modules to draw the thumb unit PCB.
include <utility.scad>
include <lib.h.scad>
include <pcb.scad>
include <thumb.h.scad>

module thumb_pcb_mountHoles(pcb, withClearance = false) {
	constants = thumb_pcb_getConstants(pcb);
	placement = thumb_pcb_getPlacement(pcb);
	ledPair = thumb_pcb_getLedPair(pcb);
	sidePlacement = thumb_placement_getSideInfo(placement);
	downPlacement = thumb_placement_getDownInfo(placement);
	
	rawClearance = constants_getClearance(constants);
	clearance = withClearance ? rawClearance : 0;
	
	rInnerM2 = constants_getRInnerM2(constants);
	rInnerM3 = constants_getRInnerM3(constants);
	
	ledFrontOffset = thumb_sidePlacementInfo_getLedFrontOffset(sidePlacement);
	ledGapDistance = thumb_sidePlacementInfo_getLedGapDistance(sidePlacement);
	holeFrontOffset = thumb_sidePlacementInfo_getHoleFrontOffset(sidePlacement);
	holeBackOffset = thumb_sidePlacementInfo_getHoleBackOffset(sidePlacement);
	holeSideOffset = thumb_sidePlacementInfo_getHoleSideOffset(sidePlacement);
	
	downLedGapDistance = thumb_downPlacementInfo_getLedGapDistance(downPlacement);
	downLedOffset = thumb_downPlacementInfo_getLedOffset(downPlacement);
	
	points = thumb_pcb_getPoints(pcb);
	holeLocations = thumb_pcb_getMountHoleLocations(pcb);
	h = thumb_pcb_getH(pcb);

	downCarrier = thumb_pcb_getDownCarrier(pcb);
	downKey = thumb_downCarrier_getDownKey(downCarrier);
	
	dCarrier = thumb_downCarrier_calcD(downCarrier);
	tHinge = thumb_downKey_calcTHinge(downKey);	
	
	union() {
//		for (holeLocation = holeLocations) {
//			translate(holeLocation)
//				circle(r = rInnerM3 - clearance/2);
//		}		
		for (thumbKey = thumb_keys) {
			o = thumb_placement_getSideOrigin(placement, thumbKey);
			a = thumb_placement_getSideAngle(placement, thumbKey);

			translate(o + [0, -dCarrier/2 - tHinge/2])
				rotate([0, 0, 90 + a])	{
					translate([ledFrontOffset, 0, 0])
						rotate([0, 0, -90])
							viasLedPair2D(constants, ledPair, ledGapDistance, withClearance);
					mirror2([0, 1, 0])
						translate([holeFrontOffset, holeSideOffset, 0])
							circle(r = rInnerM2 - clearance/2);
					translate([holeBackOffset, 0, 0])
						circle(r = rInnerM2 - clearance/2);
				}
		}
		mirror2([0, 1, 0]) 
			translate([0, downLedOffset, 0])
				viasLedPair2D(constants, ledPair, downLedGapDistance, withClearance);
	}
}

module thumb_pcb_comb(pcb) {
	points = thumb_pcb_getPoints(pcb);
	
	polygon(points);	
}

module thumb_pcb_part(pcb, withColor = false) {
	h = thumb_pcb_getH(pcb);
	color = withColor ? thumb_pcb_getColor(pcb) : undef;
	
	color(color)
		translate([0, 0, -h])
			linear_extrude(height = h)
				difference() {
					thumb_pcb_comb(pcb);
					thumb_pcb_mountHoles(pcb, false);
				}
}

module thumb_pcb_fit_part(pcb, withColor = false) {
	h = thumb_pcb_getH(pcb);
	color = withColor ? thumb_pcb_getColor(pcb) : undef;
	
	color(color)
		translate([0, 0, -h]) {
			linear_extrude(height = h)
				thumb_pcb_comb(pcb);
			linear_extrude(height = 4)
				thumb_pcb_mountHoles(pcb, true);
		}
}