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

// This is the finger carrier scad file containing all modules to draw the carrier components.
include <utility.scad>
include <lib.h.scad>
include <finger.h.scad>
include <magnet.scad>
include <led.scad>
include <clip.scad>
include <axle.scad>
include <finger_lever.scad>
include <finger_centerKey.scad>

module finger_carrier_ledCut_comb(carrier) {
	ledPair = finger_carrier_getLedPair(carrier);
	h = finger_carrier_getH(carrier);

	wLed = led_pair_getW(ledPair);
	dLed = led_pair_getD(ledPair);
	hLed = led_pair_getH(ledPair);
	rLed = led_pair_getR(ledPair);
	ledLeadFrontOffset = led_pair_getLeadFrontOffset(ledPair);
	ledLensTopOffset = led_pair_getLensTopOffset(ledPair);
	ledLeadDistance = led_pair_getLeadDistance(ledPair);
	
	translate([0, 0, -hLed/2 + ledLensTopOffset])
		union() {
			translate([dLed/2, 0, 0])
				ccube([dLed, wLed, hLed]);
			mirror2([0, 1, 0])
				translate([ledLeadFrontOffset, ledLeadDistance/2, -h/2 + hLed/2]) {
					ccylinder(r = dLed/4, h = h);
					translate([dLed/4, 0, 0]) ccube([dLed/2, dLed/2, h]);
				}
			translate([0, 0, hLed/2 - ledLensTopOffset])
				rotate([0, 90, 0])
					ccylinder(r = rLed, h = dLed*2);
			
		}
}

module finger_carrier_downLed_place(carrier) {
	placement = finger_carrier_getPlacement(carrier);
	ledPair = finger_carrier_getLedPair(carrier);
	sClip = finger_carrier_getSClip(carrier);
	
	ledGapDistance = finger_placement_getLedGapDistance(placement);
	downLedOffset = finger_placement_getDownLedOffset(placement);

	tClip = clip_getT(sClip);

	dLed = led_pair_getD(ledPair);
	lensTopOffset = led_pair_getLensTopOffset(ledPair);

	h = finger_carrier_getH(carrier);
	hAnvil = finger_carrier_calcHAnvil(carrier);

	translate([ledGapDistance/2 - dLed/2, downLedOffset, -h/2 + hAnvil - tClip - lensTopOffset])
		children();
}

module finger_carrier_sideLed_place(carrier) {
	constants = finger_carrier_getConstants(carrier);
	placement = finger_carrier_getPlacement(carrier);
	ledPair = finger_carrier_getLedPair(carrier);

	tWall = constants_calcTWall(constants);

	sideLedOffset = finger_placement_getSideLedOffset(placement);
	ledGapDistance = finger_placement_getLedGapDistance(placement);

	dLed = led_pair_getD(ledPair);
	lensTopOffset = led_pair_getLensTopOffset(ledPair);

	h = finger_carrier_getH(carrier);

	translate([sideLedOffset, ledGapDistance/2 - dLed/2, h/2 - lensTopOffset - tWall])
		children();
}

module finger_carrier_sideAxle_place(carrier) {
	placement = finger_carrier_getPlacement(carrier);
	axle = finger_carrier_getAxle(carrier);

	sideLedOffset = finger_placement_getSideLedOffset(placement);
	
	rAxle = axle_getR(axle);
	
	h = finger_carrier_getH(carrier);
	hFloor = finger_carrier_getHFloor(carrier);
	axleOffset = finger_carrier_calcSideAxleFloorOffset(carrier);

	translate([0, sideLedOffset, -h/2 + axleOffset])
		children();
}

module finger_carrier_downAxle_place(carrier) {
	lever = finger_lever(carrier);
	sClip = finger_carrier_getSClip(carrier);
	
	dLever = finger_lever_calcD(lever);
	hLever = finger_lever_calcH(lever);

	h = finger_carrier_getH(carrier);
	downAxleOffset = finger_carrier_calcDownAxleBottomOffset(carrier);

	translate([0, -hLever/2 + dLever/2, -h/2 + downAxleOffset])
		children();
}

/* Places the down clip, this placement assumes the object is alligned on top of the z orgin. */
module finger_carrier_downClip_place(carrier) {
	lever = finger_lever(carrier);
	sClip = finger_carrier_getSClip(carrier);
	
	hLever = finger_lever_calcH(lever);
	magnetCutTopOffset = finger_lever_calcDownLeverMagnetCutTopOffset(lever);
	
	tClip = clip_getT(sClip);
	
	h = finger_carrier_getH(carrier);
	hAnvil = finger_carrier_calcHAnvil(carrier);
	
	translate([0, hLever/2 - magnetCutTopOffset, -h/2 + hAnvil - tClip])
		children();
}

module finger_carrier_sideClip_place(carrier) {
	constants = finger_carrier_getConstants(carrier);
	placement = finger_carrier_getPlacement(carrier);
	sClip = finger_carrier_getSClip(carrier);
	lever = finger_lever(carrier);

	clearance = constants_getClearance(constants);

	sideLedOffset = finger_placement_getSideLedOffset(placement);
	
	rOuter = clip_calcROuter(sClip);
	rInner = clip_calcRInner(sClip);
	tClip = clip_getT(sClip);
	dLever = finger_lever_calcD(lever);
	
	h = finger_carrier_getH(carrier);
	
	translate([0, -sideLedOffset + dLever/2 + rOuter/2 + tClip/2 - clearance, h/2 - rOuter/2])
		rotate([0, -90, 0])
			children();
}

module finger_carrier_base_comb(carrier) {
	constants = finger_carrier_getConstants(carrier);
	placement = finger_carrier_getPlacement(carrier);

	clearance = constants_getClearance(constants);

	r = finger_placement_getRInner(placement);

	h = finger_carrier_getH(carrier);
	outerCubeSide = finger_carrier_calcOuterCubeSide(carrier);
	
	intersection() {
		union() {
			ccube([outerCubeSide, outerCubeSide, h]);
		}
		ccylinder(r = r - clearance/2, h = h);
	}
}

module finger_carrier_innerSideLeverCut_comb(carrier) {
	constants = finger_carrier_getConstants(carrier);
	
	clearance = constants_getClearance(constants);

	h = finger_carrier_getH(carrier);
	hFloor = finger_carrier_getHFloor(carrier);
	outerCubeSide = finger_carrier_calcOuterCubeSide(carrier);
	anvilSideA = finger_carrier_calcAnvilSideA(carrier);
	anvilSideB = finger_carrier_calcAnvilSideB(carrier);
	leverGap = finger_carrier_calcLeverGap(carrier);

	union() {
		symmetric(2)
			translate([outerCubeSide/2 + anvilSideB/2 - clearance/2, 0, hFloor - clearance/2])
				ccube([outerCubeSide, leverGap, h]);
		symmetric(2)
			translate([0, outerCubeSide/2 + anvilSideA/2 - clearance/2, hFloor - clearance/2])
				ccube([leverGap, outerCubeSide, h]);
	}
}

module finger_carrier_outerSideLeverCut_comb(carrier) {
	constants = finger_carrier_getConstants(carrier);
	placement = finger_carrier_getPlacement(carrier);
	ledPair = finger_carrier_getLedPair(carrier);
	lever = finger_lever(carrier);
	sClip = finger_carrier_getSClip(carrier);
	
	clearance = constants_getClearance(constants);
	leverClearance = constants_calcLeverClearance(constants);
	
	sideLedOffset = finger_placement_getSideLedOffset(placement);

	rLed = led_pair_getR(ledPair);

	dLever = finger_lever_calcD(lever);

	h = finger_carrier_getH(carrier);
	hFloor = finger_carrier_getHFloor(carrier);
	outerCubeSide = finger_carrier_calcOuterCubeSide(carrier);
	leverGap = finger_carrier_calcLeverGap(carrier);

	symmetric(4)
		difference() {
			translate([0, outerCubeSide/2 + sideLedOffset - dLever/2 - clearance, 0])
				ccube([leverGap, outerCubeSide, h*2]);		
			mirror2([1, 0, 0])
				rotate([0,0,90])
					finger_carrier_sideLed_place(carrier)
						rotate([90, 0, 0])
							cylinder(r = rLed*3/2, h = rLed + leverClearance - clearance);
			mirror2([1, 0, 0])
				finger_carrier_sideAxle_place(carrier)
					translate([-leverGap/2 + leverClearance - clearance, 0, 0])
						rotate([0, -90, 0])
							cylinder(r = dLever/2, h = rLed + leverClearance - clearance);
			mirror([0, 1, 0])
				finger_carrier_sideClip_place(carrier)
					clip_smount_comb(sClip);			
		}
}

module finger_carrier_innerCut_comb(carrier, withClearance = true) {
	constants = finger_carrier_getConstants(carrier);
	axle = finger_carrier_getAxle(carrier);
	lever = finger_lever(carrier);
	centerHammer = finger_centerHammer(carrier);
	ledPair = finger_carrier_getLedPair(carrier);
	
	rawClearance = constants_getClearance(constants);
	clearance = withClearance ? rawClearance : 0;
	tWall = constants_calcTWall(constants);
	
	rAxle = axle_getR(axle);
	wAxle = axle_getW(axle);
	
	dLever = finger_lever_calcD(lever);
	
	h = finger_carrier_getH(carrier);
	hFloor = finger_carrier_getHFloor(carrier) - clearance/2;

	outerCubeSide = finger_carrier_calcOuterCubeSide(carrier);
	innerCubeSide = finger_carrier_calcInnerCubeSide(carrier) + clearance;
	innerWallSide = finger_carrier_calcInnerWallSide(carrier) + clearance;
	anvilSideA = finger_carrier_calcAnvilSideA(carrier) - clearance;
	anvilSideB = finger_carrier_calcAnvilSideB(carrier) - clearance;
	hAnvil = finger_carrier_calcHAnvil(carrier) + rawClearance - clearance /2;
	leverGap = finger_carrier_calcLeverGap(carrier) - clearance;

	wDownAxleCut = (innerWallSide - wAxle)/2 - rawClearance + clearance;
	dDownAxleCut = (innerWallSide - leverGap)/2;
	
	wSideAxleRetain = led_pair_getLeadDistance(ledPair) - led_pair_getD(ledPair)/2 + rawClearance - clearance;
	// Inverting the clearance to maximize the width
	centerHammerSide = finger_centerHammer_calcSide(centerHammer) + (withClearance ? 0 : rawClearance);
	centerHammerHCavity = finger_centerHammer_calcHCavity(centerHammer);

	difference() {
		ccube([innerCubeSide, innerCubeSide, h*2]);
		difference(){
			// The anvil
			translate([0, 0, -h + hAnvil])
				ccube([anvilSideB, anvilSideA, h]);
			// Cut out a space for the down axle holders of the anvil
			translate([0, -innerWallSide/2 + dDownAxleCut/2, 0])
				mirror2([1, 0, 0])
					translate([innerWallSide/2 - wDownAxleCut/2, 0, 0])
						ccube([wDownAxleCut, dDownAxleCut, h*2]);
		}
		// Small bulge on the anvil to help printing the roof
		translate([0, 0, -h/2 + hAnvil/2 + tWall/2])
			ccube([anvilSideB, centerHammerSide, hAnvil + tWall]);
		symmetric(4) {
			// Bridge floor to the sides
			difference() {
				translate([0, outerCubeSide/2, -h + hFloor])
					ccube([leverGap, outerCubeSide, h]);
				finger_carrier_innerSideLeverDetailCut_comb(carrier);
			}
			// Cut off the corners
			translate([outerCubeSide/2 + innerWallSide/2, outerCubeSide/2 + innerWallSide/2, 0])
				ccube([outerCubeSide, outerCubeSide, h*2]);
		}
		// Cut out retainers for the side axles
		symmetric(4)finger_carrier_sideAxle_place(carrier)
			difference() {
				translate([0, 0, -h/2 + rAxle*2 - clearance/2])
					ccube([outerCubeSide, wSideAxleRetain, h]);
				ccube([wAxle + clearance, wSideAxleRetain*2, h*2]);
			}
	}
}

module finger_carrier_anvilDetailCut_comb(carrier) {
	constants = finger_carrier_getConstants(carrier);
	placement = finger_carrier_getPlacement(carrier);
	ledPair = finger_carrier_getLedPair(carrier);
	axle = finger_carrier_getAxle(carrier);
	sClip = finger_carrier_getSClip(carrier);
	lever = finger_lever(carrier);
	
	clearance = constants_getClearance(constants);
	leverClearance = constants_calcLeverClearance(constants);
	
	ledGapDistance = finger_placement_getLedGapDistance(placement);
	downLedOffset = finger_placement_getDownLedOffset(placement);

	wLed = led_pair_getW(ledPair);
	dLed = led_pair_getD(ledPair);
	rLed = led_pair_getR(ledPair);

	rAxle = axle_getR(axle);

	hClip = clip_getH(sClip);
	tClip = clip_getT(sClip);

	dLever = finger_lever_calcD(lever);

	h = finger_carrier_getH(carrier);
	hFloor = finger_carrier_getHFloor(carrier);
	outerCubeSide = finger_carrier_calcOuterCubeSide(carrier);
	innerWallSide = finger_carrier_calcInnerWallSide(carrier);
	anvilSideB = finger_carrier_calcAnvilSideB(carrier);
	hAnvil = finger_carrier_calcHAnvil(carrier);
	leverGap = finger_carrier_calcLeverGap(carrier);

	union() {
		difference() {
			translate([0, 0, hFloor])
				ccube([leverGap + clearance, outerCubeSide, h]);
			// Add guides for the lever at the lens openings (to give them extra cover) and axle openings.
			mirror2([1, 0, 0]) {
				finger_carrier_downLed_place(carrier)
					rotate([0, -90, 0])
						cylinder(r = rLed*3/2, h = rLed + leverClearance - clearance);
				finger_carrier_downLed_place(carrier)
					translate([-rLed/2 - leverClearance/2 + clearance/2, 0, -dLever - rLed])
						ccube([rLed + leverClearance - clearance, rLed*2, hAnvil - dLever]);
				finger_carrier_downAxle_place(carrier)
					translate([-leverGap/2 + leverClearance - clearance, 0, 0])
						rotate([0, -90, 0])
							cylinder(r = dLever/2, h = rLed + leverClearance - clearance);
			}
		}
		// Make room for the led/transistor watching the down lever.
		mirror2([1, 0, 0]) {
			finger_carrier_downLed_place(carrier)
				difference() {
					finger_carrier_ledCut_comb(carrier);
					// Blockade the eye a little to compensate for the clip
					translate([-leverClearance/2-rLed + clearance, 0, -rLed - clearance])
						ccube([leverClearance, rLed*2, tClip*2]);
				}
			// Extra upwards cut to clear the roof of the led as that can not be printed due to missing opposing walls.
			translate([ledGapDistance/2, downLedOffset, hFloor])
				ccube([dLed, wLed, h]);
		}
		
		// Cylinder cut for down lever axle
		finger_carrier_downAxle_place(carrier)
			rotate([0, 90, 0])
				ccylinder(r = rAxle + clearance/2, h = anvilSideB);
		
		// Clip cutout
		finger_carrier_downClip_place(carrier)
			ccube([innerWallSide, hClip + clearance, h], hCenter = true);		
	}
}

module finger_carrier_innerSideLeverDetailCut_comb(carrier) {
	constants = finger_carrier_getConstants(carrier);
	lever = finger_lever(carrier);
	
	clearance = constants_getClearance(constants);
	dLever = finger_lever_calcD(lever);
	
	leverGap = finger_carrier_calcLeverGap(carrier);
	
	symmetric(4)
		finger_carrier_sideAxle_place(carrier)
			rotate([0, 90, 0])
				ccylinder(r = dLever/2 + clearance/2, h = leverGap);
}

module finger_carrier_outerSideLeverDetailCut_comb(carrier) {
	constants = finger_carrier_getConstants(carrier);
	placement = finger_carrier_getPlacement(carrier);
	axle = finger_carrier_getAxle(carrier);
	sClip = finger_carrier_getSClip(carrier);
	lever = finger_lever(carrier);

	clearance = constants_getClearance(constants);
	
	sideLedOffset = finger_placement_getSideLedOffset(placement);
	
	rAxle = axle_getR(axle);
	
	rOuter = clip_calcROuter(sClip);
	
	dLever = finger_lever_calcD(lever);
	
	h = finger_carrier_getH(carrier);
	innerWallSide = finger_carrier_calcInnerWallSide(carrier);	
	
	symmetric(4) {
		finger_carrier_sideAxle_place(carrier)
			rotate([0, 90, 0])
				ccylinder(r = rAxle + clearance/2, h = innerWallSide);
		finger_carrier_sideClip_place(carrier)
			difference() {
				clip_scut_comb(sClip);
				scale([1, 1, 2])
					clip_smount_comb(sClip);
			}
	}
}

module finger_carrier_outerSideLedDetailCut_comb(carrier) {
	ledPair = finger_carrier_getLedPair(carrier);
	
	wLed = led_pair_getW(ledPair);
	hLed = led_pair_getH(ledPair);
	lensTopOffset = led_pair_getLensTopOffset(ledPair);
	
	outerCubeSide = finger_carrier_calcOuterCubeSide(carrier);
	
	symmetric(4)
		mirror2([0, 1, 0])
			finger_carrier_sideLed_place(carrier) {
				rotate([0, 0, 90])
					finger_carrier_ledCut_comb(carrier);
				translate([0, outerCubeSide/2, -hLed/2 + lensTopOffset])
					ccube([wLed, outerCubeSide, hLed]);
			}
}

module finger_carrier_outerHammerShaftCut_comb(carrier) {
	constants = finger_carrier_getConstants(carrier);
	centerHammer = finger_centerHammer(carrier);
	
	clearance = constants_getClearance(constants);
	tWall = constants_calcTWall(constants);
	centerHammerSide = finger_centerHammer_calcSide(centerHammer) + clearance;
	centerHammerSideCavity = finger_centerHammer_calcSideCavity(centerHammer) + clearance;
	centerHammerHCavity = finger_centerHammer_calcHCavity(centerHammer) + clearance / 2;
	h = finger_carrier_getH(carrier);
	hAnvil = finger_carrier_calcHAnvil(carrier);

	translate([0, 0, -h/2 + hAnvil + clearance/2])
		union() {
			ccube([centerHammerSide, centerHammerSide, h], hCenter = true);
			// Extra cutout for printing
			ccube([centerHammerSideCavity, centerHammerSide, centerHammerHCavity + tWall], hCenter = true);
		}
}

module finger_carrier_outerDownRing_comb(carrier) {
	constants = finger_carrier_getConstants(carrier);
	centerKeyCap = finger_centerKeyCap(carrier);
	
	clearance = constants_getClearance(constants);
	tWall = constants_calcTWall(constants);
	rCenterKeyCap = finger_centerKeyCap_calcR(centerKeyCap);
	
	hCarrier = finger_carrier_getH(carrier);
	
	h = clearance*2;
	r = rCenterKeyCap*2/3;
	
	translate([0, 0, hCarrier/2])
		difference() {
			ccylinder(r = r, h = h*2);
			ccylinder(r = r - tWall, h = h*3);
		}
}

module finger_carrier_inner_part(carrier, withColor=false) {
	color = withColor ? finger_carrier_getColor(carrier) : undef;
	
	color(color)
		difference() {
			// Base shape
			finger_carrier_base_comb(carrier);

			// Side lever gaps
			finger_carrier_innerSideLeverCut_comb(carrier);

			// Inside cutout
			finger_carrier_innerCut_comb(carrier, true);

			// Anvil detailing
			finger_carrier_anvilDetailCut_comb(carrier);
			
			// Side lever detailing
			finger_carrier_innerSideLeverDetailCut_comb(carrier);
	}
}

module finger_carrier_outer_part(carrier, withColor = false) {
	color = withColor ? finger_carrier_getColor(carrier) : undef;
	
	color(color)
		union() {
			difference() {
				intersection() {
					// The negative of the inner cut, without clearance
					finger_carrier_innerCut_comb(carrier, false);
					
					// Intersect with base shape to cut away the extra lengths needed to make the cuts in the inner carrier
					finger_carrier_base_comb(carrier);
				}

				// Side lever gaps
				finger_carrier_outerSideLeverCut_comb(carrier);
				
				// Side lever detailing
				finger_carrier_outerSideLeverDetailCut_comb(carrier);
				
				// Led placement detailing
				finger_carrier_outerSideLedDetailCut_comb(carrier);
				
				// Shaft for the center hammer
				finger_carrier_outerHammerShaftCut_comb(carrier);
			}
		// Protection ring to keep the hammer above the lever when it hits the floor
		finger_carrier_outerDownRing_comb(carrier);
	}
}

module finger_carrier_inner_assy(carrier, downLeverPosition = "up") {
	ledPair = finger_carrier_getLedPair(carrier);
	anvilClip = finger_carrier_anvilClip(carrier);
	axle = finger_carrier_getAxle(carrier);
	lever = finger_lever(carrier);
	led = led_pair_getLed(ledPair);
	transistor = led_pair_getTransistor(ledPair);
	centerHammer = finger_centerHammer(carrier);

	tClip = clip_getT(anvilClip);
	maxDownLeverAngle = finger_centerHammer_calcMaxLeverAngle(centerHammer);
	downLeverAngle = -90 - (downLeverPosition == "up" ? 0 : maxDownLeverAngle);

	union() {
		// Main body
		finger_carrier_inner_part(carrier, true);
		
		// Down lever
		finger_carrier_downAxle_place(carrier)
			rotate([downLeverAngle, 0, 0])
				finger_downLever_assy(lever);
		
		// Down led
		finger_carrier_downLed_place(carrier) 
			rotate([0, 0, -90])
				led_assy(led, true);
		// Down transistor
		mirror([1, 0, 0])
			finger_carrier_downLed_place(carrier)
				rotate([0, 0, -90])
					led_assy(transistor, true);

		// Down lever clip
		finger_carrier_downClip_place(carrier)
			translate([0, 0, tClip/2])
				clip_straight_part(anvilClip, true);
		
		// Down axle
		finger_carrier_downAxle_place(carrier)
			axle_part(axle, true);
	}
}

//S, E, N, W, D
module finger_carrier_outer_assy(carrier, leverPositions=["up", "up", "up", "up", "up"]) {
	constants = finger_carrier_getConstants(carrier);
	ledPair = finger_carrier_getLedPair(carrier);
	sClip = finger_carrier_getSClip(carrier);
	axle = finger_carrier_getAxle(carrier);
	lever = finger_lever(carrier);
	led = led_pair_getLed(ledPair);
	transistor = led_pair_getTransistor(ledPair);
	centerHammer = finger_centerHammer(carrier);
	
	clearance = constants_getClearance(constants);
	travel = leverPositions[4] == "up" ? finger_centerHammer_calcTravel(centerHammer) : clearance*2;

	union() {
		// Main body
		finger_carrier_outer_part(carrier, true);
		
		// Levers
		for (i = [0:3]) {
			rotate([0, 0, i*90])
				finger_carrier_sideAxle_place(carrier) {
					a = leverPositions[i] == "up" ? 0 : -15;
					capSize = i == 2 ? "big" : "small";
					rotate([a, 0, 0]) finger_sideLever_assy(carrier, capSize = capSize);
				}
		}
		
		// Sides
		symmetric(4) {
			// Clips
			finger_carrier_sideClip_place(carrier)
				clip_s_part(sClip, true);
			// Axle
			finger_carrier_sideAxle_place(carrier)
				axle_part(axle, true);
			// Leds
			finger_carrier_sideLed_place(carrier)
				led_assy(led, true);
			// Transistors
			mirror([1, 0, 0])
				finger_carrier_sideLed_place(carrier)
					led_assy(transistor, true);
		}
		
		translate([0, 0, finger_carrier_getH(carrier)/2 + travel])
			finger_centerKey_part(carrier, true);
	}
}