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
// This is the thumb carrier scad file containing the modules to draw the thumb carrier.
include <utility.scad>
include <thumb.h.scad>
include <led_pair.scad>
include <axle.scad>

module thumb_carrier_base_comb(downCarrier) {
	downKey = thumb_downCarrier_getDownKey(downCarrier);
	tHinge = thumb_downKey_calcTHinge(downKey);
	
	w = thumb_downCarrier_calcW(downCarrier);
	d = thumb_downCarrier_calcD(downCarrier);
	h = thumb_downCarrier_getH(downCarrier);

	translate([0, tHinge/2, 0])
		ccube([w, d, h]);
}

module thumb_carrier_innerCut_comb(downCarrier, withClearance = false) {
	constants = thumb_downCarrier_getConstants(downCarrier);
	downKey = thumb_downCarrier_getDownKey(downCarrier);
	ledPair = thumb_downCarrier_getLedPair(downCarrier);
	magnet = thumb_downCarrier_getMagnet(downCarrier);
	placement = thumb_downCarrier_getPlacement(downCarrier);
	axle = thumb_downKey_getAxle(downKey);
	
	rawClearance = constants_getClearance(constants);
	clearance = withClearance ? rawClearance : 0;
	leverClearance = constants_calcLeverClearance(constants);
	tWall = constants_calcTWall(constants);

	tHinge = thumb_downKey_calcTHinge(downKey);
	wHinge = thumb_downKey_calcWHinge(downKey);

	dLed = led_pair_getD(ledPair);
	wLed = led_pair_getW(ledPair);
	rLed = led_pair_getR(ledPair);

	hMagnet = magnet_getH(magnet);

	ledOffset = thumb_downPlacementInfo_getLedOffset(placement);
	ledGapDistance = thumb_downPlacementInfo_getLedGapDistance(placement);
	
	tCarrierWall = thumb_downCarrier_calcTWall(downCarrier);
	tRoof = thumb_downCarrier_calcTRoof(downCarrier);
	hFloor = thumb_downCarrier_getHFloor(downCarrier);
	
	wAxle = axle_getW(axle);
	
	w = thumb_downCarrier_calcW(downCarrier);
	d = thumb_downCarrier_calcD(downCarrier);
	h = thumb_downCarrier_getH(downCarrier);

	difference() {
		union() {
			// Main shape
			translate([0, tWall/2 + clearance/2, -tWall - clearance])
				ccube([w - tCarrierWall*2 - clearance*2, d - tHinge - tWall - clearance, h]);
			// Holders for the hinge of the down key
			translate([0, d/2 + tHinge/2 + clearance, 0])
				ccube([w*2, tHinge*2, h*3/2]);
			// Attach hFloor below the hinge cut
			translate([0, d/2, -h + hFloor - clearance])
				ccube([w - tCarrierWall*2 - clearance*2, tHinge*2, h]);
		}
		// Side cuts
		mirror2([1, 0, 0])
			translate([w/2 + ledGapDistance/2 - dLed + rLed - clearance, 0, -tRoof - clearance])
				ccube([w, ledOffset*2 - wLed - tWall*2 + clearance*2, h*2]);
		// Remove room for hinge
		translate([0, d/2 + tHinge/2 - tWall, hFloor - clearance])
			difference() {		
				translate([0, -clearance, 0])
					ccube([wAxle + clearance*2, tHinge*2, h]);
				translate([0, -tHinge - rawClearance, 0])
					ccube([wHinge - clearance*2, tWall*2, h*2]);
			}
	}
}

module thumb_carrier_outerDetail_comb(downCarrier) {
	constants = thumb_downCarrier_getConstants(downCarrier);
	downKey = thumb_downCarrier_getDownKey(downCarrier);
	axle = thumb_downKey_getAxle(downKey);

	clearance = constants_getClearance(constants);
	leverClearance = constants_calcLeverClearance(constants);
	tWall = constants_calcTWall(constants);
	

	tHinge = thumb_downKey_calcTHinge(downKey);
	wHinge = thumb_downKey_calcWHinge(downKey);

	rAxle = axle_getR(axle);

	d = thumb_downCarrier_calcD(downCarrier);
	w = thumb_downCarrier_calcW(downCarrier);
	h = thumb_downCarrier_getH(downCarrier);
	tCarrierWall = thumb_downCarrier_calcTWall(downCarrier);
	axleTopOffset = thumb_downCarrier_calcAxleTopOffset(downCarrier);

	union() {
		translate([0, d/2 , 0])
			union() {
				translate([0, tHinge/2 - clearance, 0]) 
					ccube([wHinge + leverClearance*2, tHinge*2, h*2]);
				translate([0, 0, -tWall])
					ccube([wHinge + leverClearance*2, tHinge*2, h]);
			}
		thumb_carrier_leverGapCut_comb(downCarrier);
		translate([0, d/2, h/2 - axleTopOffset])
			rotate([0, 90, 0])
				ccylinder(r = rAxle + clearance/2, h = w);
	}
}

module thumb_carrier_leverGapCut_comb(downCarrier) {
	constants = thumb_downCarrier_getConstants(downCarrier);
	downKey = thumb_downCarrier_getDownKey(downCarrier);
	placement = thumb_downCarrier_getPlacement(downCarrier);

	tWall = constants_calcTWall(constants);
	clearance = constants_getClearance(constants);
	leverClearance = constants_calcLeverClearance(constants);
	
	tHinge = thumb_downKey_calcTHinge(downKey);
	
	ledOffset = thumb_downPlacementInfo_getLedOffset(placement);
	
	tCarrierWall = thumb_downCarrier_calcTWall(downCarrier);
	tRoof = thumb_downCarrier_calcTRoof(downCarrier);

	h = thumb_downCarrier_getH(downCarrier);
	wBar = thumb_downCarrier_calcWBar(downCarrier);
	dBar = thumb_downCarrier_calcDBar(downCarrier);
	hammerOffset = thumb_downCarrier_calcHammerOffset(downCarrier);
	
	mirror([0, 1, 0])
		translate([0, hammerOffset - tHinge, 0]) {
			ccube([wBar - leverClearance*2, tHinge*2, h*2]);
			translate([0, 0, -tRoof + clearance])
				ccube([wBar, tHinge*2, h]);
		}
}

module thumb_carrier_led_place(downCarrier) {
	ledPair = thumb_downCarrier_getLedPair(downCarrier);
	placement = thumb_downCarrier_getPlacement(downCarrier);

	dLed = led_pair_getD(ledPair);
	ledLensTopOffset = led_pair_getLensTopOffset(ledPair);
	
	ledOffset = thumb_downPlacementInfo_getLedOffset(placement);
	ledGapDistance = thumb_downPlacementInfo_getLedGapDistance(placement);
	
	h = thumb_downCarrier_getH(downCarrier);
	tRoof = thumb_downCarrier_calcTRoof(downCarrier);
	
	translate([ledGapDistance/2 - dLed/2, ledOffset, h/2 - ledLensTopOffset - tRoof])
		children();
}

module thumb_carrier_innerDetail_comb(downCarrier) {
	constants = thumb_downCarrier_getConstants(downCarrier);
	downKey = thumb_downCarrier_getDownKey(downCarrier);
	ledPair = thumb_downCarrier_getLedPair(downCarrier);
//	placement = thumb_downCarrier_getPlacement(downCarrier);
	sClip = thumb_downCarrier_getSClip(downCarrier);
	magnet = thumb_downCarrier_getMagnet(downCarrier);

	tWall = constants_calcTWall(constants);
	clearance = constants_getClearance(constants);
	leverClearance = constants_calcLeverClearance(constants);
	
	tHinge = thumb_downKey_calcTHinge(downKey);

	tCarrierWall = thumb_downCarrier_calcTWall(downCarrier);
	tRoof = thumb_downCarrier_calcTRoof(downCarrier);

	tClip = clip_getT(sClip);
	hClip = clip_getH(sClip);

	wMagnet = magnet_getW(magnet);
	dMagnet = magnet_getD(magnet);
	hMagnet = magnet_getH(magnet);

	h = thumb_downCarrier_getH(downCarrier);
	wBar = thumb_downCarrier_calcWBar(downCarrier);
	dBar = thumb_downCarrier_calcDBar(downCarrier);
	retainOffset = thumb_downCarrier_calcBarRetainOffset(downCarrier);

	union() {
		// Cut out spaces for the leds
		mirror2([1, 0, 0])
			mirror2([0, 1, 0])
				thumb_carrier_led_place(downCarrier)
					led_pair_cut_comb(h, ledPair);
		// Cut out spaces for the magnets
		difference() {
			mirror2([0, 1, 0])			
				translate([0, retainOffset - dMagnet/2, 0]) {
					translate([0, 0, h - tWall - hMagnet - clearance])
						ccube([wMagnet, dMagnet, h]);
					ccube([hClip + clearance*4, dMagnet, h]);
					translate([0, 0, -tRoof + clearance])
						ccube([wBar, dMagnet, h]);
				}
			thumb_bar_ledRetainCut_comb(downCarrier);
		}

		// Cut out lever gap
		thumb_carrier_leverGapCut_comb(downCarrier);
	}
}

module thumb_bar_base_comb(downCarrier) {
	constants = thumb_downCarrier_getConstants(downCarrier);
	leverClearance = constants_calcLeverClearance(constants);
	
	wBar = thumb_downCarrier_calcWBar(downCarrier);
	dBar = thumb_downCarrier_calcDBar(downCarrier);
	hBar = thumb_downCarrier_calcHBar(downCarrier);
	
	ccube([wBar - leverClearance*2, dBar - leverClearance*2, hBar]);
}

module thumb_bar_ledRetainCut_comb(downCarrier) {
	constants = thumb_downCarrier_getConstants(downCarrier);
	ledPair = thumb_downCarrier_getLedPair(downCarrier);
	placement = thumb_downCarrier_getPlacement(downCarrier);
	
	clearance = constants_getClearance(constants);
	leverClearance = constants_calcLeverClearance(constants);
	
	rLed = led_pair_getR(ledPair);
	
	ledOffset = thumb_downPlacementInfo_getLedOffset(placement);	
	
	h = thumb_downCarrier_getH(downCarrier);
	wBar = thumb_downCarrier_calcWBar(downCarrier);
	
	mirror2([0, 1, 0])
		mirror2([1, 0, 0])
			translate([wBar - leverClearance + clearance, ledOffset, 0])
				ccube([wBar, rLed*3, h]);
}

module thumb_bar_cut_comb(downCarrier, withTolerance = false) {
	constants = thumb_downCarrier_getConstants(downCarrier);
	placement = thumb_downCarrier_getPlacement(downCarrier);
	sClip = thumb_downCarrier_getSClip(downCarrier);
	
	rawClearance = constants_getClearance(constants);
	clearance = withTolerance ? rawClearance : 0;
	rawLeverClearance = constants_calcLeverClearance(constants);
	leverClearance = withTolerance ? rawLeverClearance : 0;
	
	hClip = clip_getH(sClip);
	
	h = thumb_downCarrier_getH(downCarrier);
	tRoof = thumb_downCarrier_calcTRoof(downCarrier);
	wBar = thumb_downCarrier_calcWBar(downCarrier);
	dBar = thumb_downCarrier_calcDBar(downCarrier);
	retainOffset = thumb_downCarrier_calcBarRetainOffset(downCarrier);
	
	difference() {
		translate([0, 0, -tRoof])
			ccube([wBar - leverClearance*2, dBar - leverClearance*2, h]);
		// Add retaining guides around the led lenses
		thumb_bar_ledRetainCut_comb(downCarrier);
		// Add retaining guides at the ends of the bar
		mirror2([0, 1, 0])
			translate([0, retainOffset + dBar/2 - leverClearance, 0])
				ccube([hClip + clearance*4, dBar, h*2]);
	}
}

module thumb_bar_clip_place(downCarrier) {
	placement = thumb_downCarrier_getPlacement(downCarrier);
	sClip = thumb_downCarrier_getSClip(downCarrier);
	
	ledOffset = thumb_downPlacementInfo_getLedOffset(placement);
	
	rOuter = clip_calcROuter(sClip);
	hBar = thumb_downCarrier_calcHBar(downCarrier);	
	
	translate([0, ledOffset , hBar/2 - rOuter/2])
		rotate([-90, 0, 90])
			children();
}

module thumb_bar_detail_comb(downCarrier) {
	sClip = thumb_downCarrier_getSClip(downCarrier);
	
	mirror2([0, 1, 0])
		thumb_bar_clip_place(downCarrier)
			clip_scut_comb(sClip);
}

module thumb_carrier_outer_part(downCarrier, withColor = false) {
	color = withColor ? thumb_downCarrier_getColor(downCarrier) : undef;

	color(color)
		difference() {
			thumb_carrier_base_comb(downCarrier);
			thumb_carrier_outerDetail_comb(downCarrier);
			thumb_carrier_innerCut_comb(downCarrier, false);
		}
}

module thumb_carrier_inner_part(downCarrier, withColor = false) {
	color = withColor ? thumb_downCarrier_getColor(downCarrier) : undef;

	color(color)
		difference() {
			intersection() {
				thumb_carrier_innerCut_comb(downCarrier, true);
				thumb_carrier_base_comb(downCarrier);
			}
			thumb_carrier_innerDetail_comb(downCarrier);
			thumb_bar_cut_comb(downCarrier, false);
		}
}

module thumb_bar_part(downCarrier, withColor = false) {
	constants = thumb_downCarrier_getConstants(downCarrier);
	downKey = thumb_downCarrier_getDownKey(downCarrier);
	ledPair = thumb_downCarrier_getLedPair(downCarrier);
	sClip = thumb_downCarrier_getSClip(downCarrier);
	
	color = withColor ? thumb_downKey_getColor(downKey) : undef;
	
	clearance = constants_getClearance(constants);
	
	lensTopOffset = led_pair_getLensTopOffset(ledPair);
	rLed = led_pair_getR(ledPair);
	
	h = thumb_downCarrier_getH(downCarrier);
	hBar = thumb_downCarrier_calcHBar(downCarrier);
	travelDistance = thumb_downCarrier_calcTravelDistance(downCarrier);
	
	hDiff = h - hBar;
	
	color(color)
		translate([0, 0, -hDiff/2 + travelDistance - clearance])
			union() {
				difference() {
					intersection() {
						thumb_bar_base_comb(downCarrier);
						thumb_bar_cut_comb(downCarrier, true);
					}
					thumb_bar_detail_comb(downCarrier);
				}
				mirror2([0, 1, 0])
					thumb_bar_clip_place(downCarrier)
						clip_smount_comb(sClip);
			}
}

module thumb_downKey_base2d_comb(downCarrier) {
	downKey = thumb_downCarrier_getDownKey(downCarrier);
	points = thumb_downKey_getPoints(downKey);
	
	B = points[1];
	C = points[2];
	D = points[3];
	E = points[4];
	G = points[6];
	
	paramsA = triangleEllipseParameters(D, B, C);
	paramsB = triangleEllipseParameters(D, G, E);
	
	rotate([0, 180, 0])
		mirror([0, 1, 0]) {
			polygon(points);
			triangleEllipse(paramsA);
			triangleEllipse(paramsB);
		}	
}

module thumb_downKey_base_comb(downCarrier) {
	downKey = thumb_downCarrier_getDownKey(downCarrier);
	h = thumb_downKey_getH(downKey);
	tHinge = thumb_downKey_calcTHinge(downKey);
	
	translate([0, tHinge/2, 0])
		linear_extrude(height = h)
			thumb_downKey_base2d_comb(downCarrier);
}

module thumb_downKey_baseCut_comb(downCarrier) {
	downKey = thumb_downCarrier_getDownKey(downCarrier);
	
	wHinge = thumb_downKey_calcWHinge(downKey);
	tHinge = thumb_downKey_calcTHinge(downKey);
	h = thumb_downKey_getH(downKey);

	rotation = thumb_downCarrier_calcMaxRotation(downCarrier);

	mirror2([1, 0, 0])
		translate([0, -tHinge/2, 0])
			rotate([rotation, 0, 0])
				translate([wHinge, tHinge, -h/2])
					ccube([wHinge, tHinge*2, h]);
}

module thumb_downKey_hinge_comb(downCarrier) {
	downKey = thumb_downCarrier_getDownKey(downCarrier);
	constants = thumb_downCarrier_getConstants(downCarrier);
	axle = thumb_downKey_getAxle(downKey);
	wHinge = thumb_downKey_calcWHinge(downKey);
	tHinge = thumb_downKey_calcTHinge(downKey);
	rHinge = thumb_downKey_calcRHinge(downKey);
	
	clearance = constants_getClearance(constants);
	leverClearance = constants_calcLeverClearance(constants);
	
	rAxle = axle_getR(axle);
	
	h = thumb_downKey_getH(downKey);
	axleTopOffset = thumb_downCarrier_calcAxleTopOffset(downCarrier);
	hCarrier = thumb_downCarrier_getH(downCarrier);
	hFloor = thumb_downCarrier_getHFloor(downCarrier);
	rotation = thumb_downCarrier_calcMaxRotation(lib_thumb_downCarrier);

	hLowerHinge = hCarrier - axleTopOffset - hFloor - leverClearance;
	
	difference() {
		union() {
			translate([0, 0, -axleTopOffset - clearance]) {
				ccube([wHinge, tHinge, h + axleTopOffset + clearance], hCenter = true);
				rotate([0, 90, 0])
					ccylinder(r = rHinge, h = wHinge);
				rotate([rotation, 0, 0])
					translate([0, 0, - hLowerHinge/2])
						ccube([wHinge, tHinge, hLowerHinge]);
			}
		}
		translate([0, 0, -axleTopOffset - clearance])
			rotate([0, 90, 0])	
				ccylinder(r = rAxle + clearance/2, h = wHinge*2);
	}
}

module thumb_downKey_hammer_comb(downCarrier) {
	downKey = thumb_downCarrier_getDownKey(downCarrier);
	constants = thumb_downCarrier_getConstants(downCarrier);
	
	clearance = constants_getClearance(constants);
	leverClearance = constants_calcLeverClearance(constants);

	tHinge = thumb_downKey_calcTHinge(downKey);
	rHinge = thumb_downKey_calcRHinge(downKey);
	h = thumb_downKey_getH(downKey);

	hammerOffset = thumb_downCarrier_calcHammerOffset(downCarrier);
	tRoof = thumb_downCarrier_calcTRoof(downCarrier);
	travelDistance = thumb_downCarrier_calcTravelDistance(downCarrier);
	dCarrier = thumb_downCarrier_calcD(downCarrier);
	wBar = thumb_downCarrier_calcWBar(downCarrier);
	
	hHammer = tRoof + travelDistance - rHinge + clearance;
	wHammer = wBar - leverClearance*4;
	
	translate([0, -dCarrier/2 - hammerOffset + tHinge, -hHammer])
		union() {
			ccube([wHammer, tHinge, h + hHammer], hCenter = true);
			rotate([0, 90, 0]) ccylinder(r = rHinge, h = wHammer);
		}
}

module thumb_downKey_part(downCarrier, withColor = false) {
	constants = thumb_downCarrier_getConstants(downCarrier);
	downKey = thumb_downCarrier_getDownKey(downCarrier);
	
	color = withColor ? thumb_downKey_getColor(downKey) : undef;
	
	clearance = constants_getClearance(constants);
	axleTopOffset = thumb_downCarrier_calcAxleTopOffset(downCarrier);
	
	color(color)
		translate([0, 0, axleTopOffset + clearance])
			union() {
				difference() {
					thumb_downKey_base_comb(downCarrier);
					thumb_downKey_baseCut_comb(downCarrier);
				}
				thumb_downKey_hinge_comb(downCarrier);
				thumb_downKey_hammer_comb(downCarrier);
			}
}

module thumb_downCarrier_assy(downCarrier, position = "up") {
	constants = thumb_downCarrier_getConstants(downCarrier);
	downKey = thumb_downCarrier_getDownKey(downCarrier);
	ledPair = thumb_downCarrier_getLedPair(downCarrier);
	led = led_pair_getLed(ledPair);
	transistor = led_pair_getTransistor(ledPair);	
	axle = thumb_downKey_getAxle(downKey);

	clearance = constants_getClearance(constants);
	
	rawTravelDistance = thumb_downCarrier_calcTravelDistance(downCarrier);
	dCarrier = thumb_downCarrier_calcD(downCarrier);
	hCarrier = thumb_downCarrier_getH(downCarrier);
	axleTopOffset = thumb_downCarrier_calcAxleTopOffset(downCarrier);
	rawRotation = thumb_downCarrier_calcMaxRotation(downCarrier);
	
	travelDistance = position == "up" ? 0 : rawTravelDistance - clearance;
	rotation = position == "up" ? rawRotation : 0;
	
	union() {
		thumb_carrier_outer_part(downCarrier, true);
		thumb_carrier_inner_part(downCarrier, true);
		translate([0, 0, -travelDistance])
			thumb_bar_part(downCarrier, true);
		translate([0, dCarrier/2, hCarrier/2 - axleTopOffset])
			rotate([-rotation, 0, 0])
				thumb_downKey_part(lib_thumb_downCarrier, true);
		translate([0, dCarrier/2, hCarrier/2 - axleTopOffset])
			axle_part(axle);
		mirror2([0, 1, 0])
			thumb_carrier_led_place(downCarrier)
				rotate([0,0,-90])
					led_assy(led, true);
		mirror([1, 0, 0])
			mirror2([0, 1, 0])
				thumb_carrier_led_place(downCarrier)
					rotate([0,0,-90])
						led_assy(transistor, true);		
	}

}