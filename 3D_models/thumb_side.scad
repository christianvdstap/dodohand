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
// This is the thumb side scad file containing the modules to draw the thumb hammer and anvil
// for the side keys.

include <utility.scad>
include <math.scad>
include <thumb.h.scad>
include <led_pair.scad>
include <thumb_carrier.scad>

module thumb_sideCarrier_base_comb(sideCarrier) {
	constants = thumb_sideCarrier_getConstants(sideCarrier);

	rOuterM2 = constants_getROuterM2(constants);

	w = thumb_sideCarrier_calcW(sideCarrier);
	d = thumb_sideCarrier_calcD(sideCarrier);
	h = thumb_sideCarrier_calcH(sideCarrier);
	
	wFront = thumb_sideCarrier_calcWFront(sideCarrier);
	wBack = thumb_sideCarrier_calcWBack(sideCarrier);
	wTower = thumb_sideCarrier_calcWTower(sideCarrier);
	dTower = thumb_sideCarrier_calcDTower(sideCarrier);
	
	union() {
		translate([0, dTower/2, 0])
			ccube([wTower, dTower, h], hCenter = true);
		hull() {
			translate([0, wFront/2, 0])
				ccube([w, wFront, rOuterM2], hCenter = true); 
			translate([0, d/2, 0])
				ccube([wBack, d, rOuterM2], hCenter = true);
		}
	}
}

module thumb_sideCarrier_innerCut_comb(sideCarrier, withClearance = false) {
	constants = thumb_sideCarrier_getConstants(sideCarrier);
	placement = thumb_sideCarrier_getPlacement(sideCarrier);
	ledPair = thumb_sideCarrier_getLedPair(sideCarrier);
	axle = thumb_sideCarrier_getAxle(sideCarrier);
	magnet = thumb_sideCarrier_getMagnet(sideCarrier);
	
	tWall = constants_calcTWall(constants);
	rawClearance = constants_getClearance(constants);
	clearance = withClearance ? rawClearance : 0;
	leverClearance = constants_calcLeverClearance();
	
	ledFrontOffset = thumb_sidePlacementInfo_getLedFrontOffset(placement);
	ledGapDistance = thumb_sidePlacementInfo_getLedGapDistance(placement);
	
	dLed = led_pair_getD(ledPair);
	wLed = led_pair_getW(ledPair);
	rLed = led_pair_getR(ledPair);
	
	rAxle = axle_getR(axle);
	wAxle = axle_getW(axle);
	
	dMagnet = magnet_getH(magnet);
	
	w = thumb_sideCarrier_calcW(sideCarrier);
	d = thumb_sideCarrier_calcD(sideCarrier);
	h = thumb_sideCarrier_calcH(sideCarrier);
	
	wFront = thumb_sideCarrier_calcWFront(sideCarrier);
	wTower = thumb_sideCarrier_calcWTower(sideCarrier);
	dTower = thumb_sideCarrier_calcDTower(sideCarrier);
	axleFrontOffset = thumb_sideCarrier_calcAxleFrontOffset(sideCarrier);

	difference() {
		// Base shape
		translate([0, dTower/2, tWall + dMagnet - clearance])
			ccube([wTower + clearance*2, dTower + clearance*2, h], hCenter = true);
		// Pillars for leds
		mirror2([1, 0, 0]) {
			//-w/2 + ledFrontOffset + wLed/2 + tWall
			translate([ledGapDistance/2 - rLed/2, ledFrontOffset, h/2])
				ccube([dLed + rLed - clearance*2, wLed + tWall*2 + rawClearance*2 - clearance*2, h*2]);
			thumb_sideCarrier_led_place(sideCarrier)
				rotate([0, -90, 0])
					cylinder(r = rLed*1.5, h = dLed + rLed + leverClearance);
		}
		
		// Pillars for axle retainers
		mirror2([1, 0, 0])
			translate([w/2 + wTower/2 - (wTower - wAxle)/2 + clearance, d/2 + axleFrontOffset - rAxle - tWall*2 + clearance, h/2])
				ccube([w, d, h*2]);
	}
}

module thumb_sideCarrier_led_place(sideCarrier) {
	constants = thumb_sideCarrier_getConstants(sideCarrier);
	placement = thumb_sideCarrier_getPlacement(sideCarrier);
	ledPair = thumb_sideCarrier_getLedPair(sideCarrier);
	
	tWall = constants_calcTWall(constants);

	hLed = led_pair_getH(ledPair);
	dLed = led_pair_getD(ledPair);
	lensTopOffset = led_pair_getLensTopOffset(ledPair);
	
	ledFrontOffset = thumb_sidePlacementInfo_getLedFrontOffset(placement);
	ledGapDistance = thumb_sidePlacementInfo_getLedGapDistance(placement);
	
	translate([ledGapDistance/2 - dLed/2, ledFrontOffset, hLed - lensTopOffset + tWall])
		children();
}

module thumb_sideCarrier_outerDetailCut_comb(sideCarrier) {
	constants = thumb_sideCarrier_getConstants(sideCarrier);
	placement = thumb_sideCarrier_getPlacement(sideCarrier);
	ledPair = thumb_sideCarrier_getLedPair(sideCarrier);
	magnet = thumb_sideCarrier_getMagnet(sideCarrier);
	
	tWall = constants_calcTWall(constants);
	rHole = constants_getRInnerM2(constants);

	wMagnet = magnet_getW(magnet);
	dMagnet = magnet_getD(magnet);

	holeFrontOffset = thumb_sidePlacementInfo_getHoleFrontOffset(placement);
	holeBackOffset = thumb_sidePlacementInfo_getHoleBackOffset(placement);
	holeSideOffset = thumb_sidePlacementInfo_getHoleSideOffset(placement);

	h = thumb_sideCarrier_calcH(sideCarrier);

	union() {
		mirror2([1, 0, 0])
			translate([holeSideOffset, holeFrontOffset, 0])
				ccylinder(r = rHole, h = h);
		translate([0, holeBackOffset, 0])
			ccylinder(r = rHole, h = h);
		mirror2([1, 0, 0])
			thumb_sideCarrier_led_place(sideCarrier)
				led_pair_cut_comb(h, ledPair);
		translate([0, dMagnet/2 + tWall, tWall])
			ccube([wMagnet, dMagnet, h], hCenter = true);
	}
}

module thumb_sideCarrier_axle_place(sideCarrier) {
	axleFrontOffset = thumb_sideCarrier_calcAxleFrontOffset(sideCarrier);
	axleBottomOffset = thumb_sideCarrier_calcAxleBottomOffset(sideCarrier);

	translate([0, axleFrontOffset, axleBottomOffset])
		children();
}

module thumb_sideCarrier_innerDetailCut_comb(sideCarrier) {
	constants = thumb_sideCarrier_getConstants(sideCarrier);
	axle = thumb_sideCarrier_getAxle(sideCarrier);
	magnet = thumb_sideCarrier_getMagnet(sideCarrier);
	sClip = thumb_sideCarrier_getSClip(sideCarrier);
	
	tWall = constants_calcTWall(constants);
	clearance = constants_getClearance(constants);
	leverClearance = constants_calcLeverClearance(constants);

	rAxle = axle_getR(axle);
	wAxle = axle_getW(axle);
	
	hMagnet = magnet_getH(magnet);
	dMagnet = magnet_getD(magnet);
	
	hClip = clip_getH(sClip);
	tClip = clip_getT(sClip);
	waClip = clip_getWa(sClip);
	
	w = thumb_sideCarrier_calcW(sideCarrier);
	d = thumb_sideCarrier_calcD(sideCarrier);
	h = thumb_sideCarrier_calcH(sideCarrier);
	
	dTower = thumb_sideCarrier_calcDTower(sideCarrier);
	wHammer = thumb_sideCarrier_calcWHammer(sideCarrier);
	axleFrontOffset = thumb_sideCarrier_calcAxleFrontOffset(sideCarrier);
	
	union() {
		// Make room for the hammer
		difference() {
			translate([0, -w/2 + axleFrontOffset + rAxle*2 + clearance, tWall + hMagnet + tClip])
				ccube([wHammer, w, h], hCenter = true);
			mirror2([1, 0, 0])
				thumb_sideCarrier_axle_place(sideCarrier)
					translate([wHammer/2 - leverClearance + clearance, 0, 0])
						rotate([0, 90, 0])
							cylinder(r = rAxle*1.5, h = wAxle);
		}
		// Slit for the clip
		translate([0, -d/2 + waClip + clearance, 0])
			ccube([hClip + clearance*4, d, h*2]);
		// Make room for the axle
		thumb_sideCarrier_axle_place(sideCarrier)
			rotate([0, 90, 0])
				ccylinder(r = rAxle + clearance/2, h = w);
	}
}

module thumb_sideCarrier_clip_place(sideCarrier) {
	constants = thumb_sideCarrier_getConstants(sideCarrier);
	sClip = thumb_sideCarrier_getSClip(sideCarrier);
	
	clearance = constants_getClearance(constants);
	rOuter = clip_calcROuter(sClip);
	tClip = clip_getT(sClip);
	
	axleFrontOffset = thumb_sideCarrier_calcAxleFrontOffset(sideCarrier);

	translate([0, -axleFrontOffset + tClip, -rOuter - clearance])
		rotate([90, 0, -90])
			children();
}

module thumb_sideCarrier_hammer_comb(downCarrier, sideCarrier) {
	constants = thumb_sideCarrier_getConstants(sideCarrier);
	placement = thumb_sideCarrier_getPlacement(sideCarrier);
	axle = thumb_sideCarrier_getAxle(sideCarrier);
	ledPair = thumb_sideCarrier_getLedPair(sideCarrier);
	sClip = thumb_sideCarrier_getSClip(sideCarrier);
	key = thumb_sideCarrier_getKey(sideCarrier);
	
	clearance = constants_getClearance(constants);
	leverClearance = constants_calcLeverClearance(constants);
	
	ledFrontOffset = thumb_sidePlacementInfo_getLedFrontOffset(placement);
	
	rAxle = axle_getR(axle);
	
	rLed = led_pair_getR(ledPair);

	rOuter = clip_calcROuter(sClip);

	hKey = thumb_key_getH(key);

	axleFrontOffset = thumb_sideCarrier_calcAxleFrontOffset(sideCarrier);
	axleBottomOffset = thumb_sideCarrier_calcAxleBottomOffset(sideCarrier);
	wHammer = thumb_sideCarrier_calcWHammer(sideCarrier); 
	h = thumb_sideCarrier_calcH(sideCarrier);
	angle = thumb_sideCarrier_getAngle(sideCarrier);
	maxRotation = thumb_sideCarrier_calcMaxRotation(sideCarrier);
	stemFrontOffset = thumb_sideCarrier_calcStemFrontOffset(sideCarrier);
	tStem = thumb_sideCarrier_calcTStem(sideCarrier);
	lensBottomOffset = thumb_sideCarrier_calcLensBottomOffset(sideCarrier);
		
	hDownCarrier = thumb_downCarrier_getH(downCarrier);

	module lensCut() {
		rotate([maxRotation, 0, 0])
			translate([0, -axleFrontOffset + ledFrontOffset, lensBottomOffset - axleBottomOffset])
				rotate([0, 90, 0])
					ccylinder(r = rLed, h = tStem + clearance);
	}

	A = [0, 0];
	B = [axleFrontOffset, 0];
	C = [axleFrontOffset + rAxle*2, rAxle*2];
	F = [stemFrontOffset + tStem, hDownCarrier - axleBottomOffset + rAxle*2 + hKey];
	G = [stemFrontOffset, hDownCarrier - axleBottomOffset + rAxle*2 + hKey];
	I = [0, rAxle*4];

	D = [axleFrontOffset + rAxle*2 - ((h - axleBottomOffset)*tan(maxRotation)), (h - axleBottomOffset) * sin(90 - maxRotation) + rAxle*2];
	E = [stemFrontOffset + tStem, D[1] + ((D[0] - stemFrontOffset - tStem)*tan(angle))];
	H = [stemFrontOffset, I[1] + (stemFrontOffset*tan(angle))];

	union() {
		difference() {
			translate([0, 0, -rAxle*2])
				rotate([90, 0, 90])
					linear_extrude(height = wHammer - leverClearance*2, center = true)
						translate([-axleFrontOffset, 0, 0])
							union() {
								polygon(points = [A, B, C, D, E, F, G, H, I]);
								translate([axleFrontOffset, rAxle*2, 0])
									difference() {
										circle(r = rAxle*2);
										translate([0, rAxle*2, 0])
											square(size = rAxle*4, center = true);
									}
							}			
			rotate([0, 90, 0])
				ccylinder(r = rAxle + clearance/2, h = wHammer);
			lensCut();
			thumb_sideCarrier_clip_place(sideCarrier)
				clip_scut_comb(sClip);
		}
		difference() {
			thumb_sideCarrier_clip_place(sideCarrier)
				clip_smount_comb(sClip);
			lensCut();
		}
	}
}

module thumb_sideCarrier_keyBase_comb(sideCarrier, w, r) {
	constants = thumb_sideCarrier_getConstants(sideCarrier);
	key = thumb_sideCarrier_getKey(sideCarrier);
	
	clearance = constants_getClearance(constants);
	leverClearance = constants_calcLeverClearance(constants);
	
	frontOffset = thumb_sideCarrier_calcStemFrontOffset(sideCarrier);
	tStem = thumb_sideCarrier_calcTStem(sideCarrier);
	
	h = thumb_key_getH(key);
	d = r + frontOffset + tStem/2;
	
	angle = atan(h / frontOffset) - 90;
	rCorner = tStem/2;

	difference() {
		intersection() {
			translate([0, -d/2 + frontOffset + tStem/2, 0])
				union() {
					difference() {
						ccube([w, d, h], hCenter = true);
						mirror2([1, 0, 0])
							translate([w/2 - rCorner/2, d/2 - rCorner/2, h/2]) 
						rotate([0, 0, 45])
							translate([rCorner, 0, 0])
								ccube([rCorner*2, rCorner*2, h*2]);
					}
					mirror2([1, 0, 0])
						translate([w/2 - rCorner, d/2 - rCorner, h/2])
							ccylinder(r = rCorner, h = h);
				}
				if (r > 0) {
					translate([0, -r, 0])
						linear_extrude(height = h*2)
							scale([d / r, d / r, 1])
								lens([-w/2, 0], [w/2, 0], r);
				}				
			}
		translate([0, -r, 0])
			rotate([angle, 0, 0])
				translate([0, 0, -h/2])
					union() {
						if (r > 0) {
							linear_extrude(height = h*2)
								lens([-w/2, 0], [w/2, 0], r);
						}
						translate([0, -d, 0])
							ccube([w*2, d*2, h*2], hCenter = true);
						mirror2([1, 0, 0])
							difference() {
								translate([w, -d + rCorner, 0])
									ccube([w + rCorner*2, d*2, h*2], hCenter = true);
								translate([w/2 - rCorner, rCorner, h])
									ccylinder(r = rCorner, h = h*3);
						}
					}
		}
}

module thumb_sideCarrier_keyA_comb(sideCarrier) {
	constants = thumb_sideCarrier_getConstants(sideCarrier);
	key = thumb_sideCarrier_getKey(sideCarrier);
	downKey = thumb_sideCarrier_getDownKey(sideCarrier);

	clearance = constants_calcLeverClearance(constants);
	points = thumb_downKey_getPoints(downKey);
	P = points[3];
	Q = points[4];
	w = lineLength(P, Q) - clearance*2;
	r = thumb_downKey_getRDE(downKey);
	
	thumb_sideCarrier_keyBase_comb(sideCarrier, w, r);	
}

module thumb_sideCarrier_keyB_comb(sideCarrier) {
	constants = thumb_sideCarrier_getConstants(sideCarrier);
	key = thumb_sideCarrier_getKey(sideCarrier);
	downKey = thumb_sideCarrier_getDownKey(sideCarrier);

	clearance = constants_calcLeverClearance(constants);
	points = thumb_downKey_getPoints(downKey);
	P = points[2];
	Q = points[3];
	w = lineLength(P, Q) - clearance*2;
	r = thumb_downKey_getRCD(downKey);
	
	thumb_sideCarrier_keyBase_comb(sideCarrier, w, r);	
}

module thumb_sideCarrier_keyC_comb(sideCarrier) {
	constants = thumb_sideCarrier_getConstants(sideCarrier);
	key = thumb_sideCarrier_getKey(sideCarrier);
	downKey = thumb_sideCarrier_getDownKey(sideCarrier);
	
	clearance = constants_calcLeverClearance(constants);
	points = thumb_downKey_getPoints(downKey);
	P = points[4];
	Q = points[5];
	w = lineLength(P, Q) - clearance*2;
	
	thumb_sideCarrier_keyBase_comb(sideCarrier, w, 0);	
}

module thumb_sideCarrier_keyD_comb(sideCarrier) {
	constants = thumb_sideCarrier_getConstants(sideCarrier);
	key = thumb_sideCarrier_getKey(sideCarrier);
	upKey = thumb_sideCarrier_getUpKey(sideCarrier);
	downKey = thumb_sideCarrier_getDownKey(sideCarrier);
	
	leverClearance = constants_calcLeverClearance(constants);
	
	hKey = thumb_key_getH(key);

	tHinge = thumb_downKey_calcTHinge(downKey);
	points = thumb_downKey_getPoints(downKey);
	P = points[2];
	
	rKeyB = thumb_downKey_getRCD(downKey);
	
	tStem = thumb_sideCarrier_calcTStem(sideCarrier);
	frontOffset = thumb_sideCarrier_calcStemFrontOffset(sideCarrier);
	
	angle = thumb_upKey_getANeck(upKey);
	hNeck = thumb_upKey_getHNeck(upKey);
	wTop = thumb_upKey_getWTop(upKey);
		
	translate([0, frontOffset + tStem, hKey]) rotate([0, 0, -90])
		union() {
			difference() {
				rotate([0, angle, 0])
					translate([tStem/2, 0, 0])
						ccube([tStem, tStem, hNeck + tStem*cos(angle)], hCenter = true);
				translate([hNeck * sin(angle) + tStem/2, 0, hNeck * cos(angle)])
					ccube([hNeck*2, hNeck*2, hNeck], hCenter = true);
			}
			translate([hNeck * sin(angle), 0, hNeck * cos(angle) - tStem/2])
				union() {
					rotate([0, 90, 0])
						translate([-tStem/4, 0, 0])
							ccube([tStem/2, tStem, wTop], hCenter = true);
					translate([wTop - tStem, 0, 0])
						linear_extrude(height = tStem/2)
							hull() {
								difference() {
									ellipse(r1 = tStem, r2 = tStem*2);
									translate([0, -tStem*3/2, 0])
										square([tStem*4, tStem*4], true);
								}
								translate([0, tStem/4, 0])
									square([tStem*2, tStem/2], true);
							}
				}
		}
}

module thumb_sideCarrier_outer_part(sideCarrier, withColor = false) {
	color = withColor ? thumb_sideCarrier_getColor(sideCarrier) : undef;
	
	color(color)
		difference() {
			thumb_sideCarrier_base_comb(sideCarrier);
			thumb_sideCarrier_innerCut_comb(sideCarrier, true);
			thumb_sideCarrier_outerDetailCut_comb(sideCarrier);
		}
}

module thumb_sideCarrier_inner_part(sideCarrier, withColor = false) {
	color = withColor ? thumb_sideCarrier_getColor(sideCarrier) : undef;
	
	color(color)
		difference() {
			intersection() {
				thumb_sideCarrier_base_comb(sideCarrier);
				thumb_sideCarrier_innerCut_comb(sideCarrier, false);
			}
			thumb_sideCarrier_innerDetailCut_comb(sideCarrier);
		}
}

module thumb_sideCarrier_hammer_part(downCarrier, sideCarrier, withColor = false, keyId = "A") {
	key = thumb_sideCarrier_getKey(sideCarrier);
	color = withColor ? thumb_key_getColor(key) : undef;
	hCarrier = thumb_downCarrier_getH(downCarrier);
	axleBottomOffset = thumb_sideCarrier_calcAxleBottomOffset(sideCarrier);
	axleFrontOffset = thumb_sideCarrier_calcAxleFrontOffset(sideCarrier);
	
	color(color)
		union() {
			thumb_sideCarrier_hammer_comb(downCarrier, sideCarrier);
			translate([0, -axleFrontOffset, hCarrier - axleBottomOffset])
				if (keyId == "B") {
					thumb_sideCarrier_keyB_comb(sideCarrier);
				} else if (keyId == "C") {
					thumb_sideCarrier_keyC_comb(sideCarrier);
				} else if (keyId == "D") {
					thumb_sideCarrier_keyD_comb(sideCarrier);
				} else {
					thumb_sideCarrier_keyA_comb(sideCarrier);
				}
		}
}

module thumb_sideCarrier_hammer_assy(downCarrier, sideCarrier, key = "A", position = "down") {
	sClip = thumb_sideCarrier_getSClip(sideCarrier);
	rotation = position == "down" ? 0 : thumb_sideCarrier_calcMaxRotation(sideCarrier);
	
	thumb_sideCarrier_axle_place(sideCarrier)
		rotate([-rotation, 0, 0]) {
			thumb_sideCarrier_hammer_part(downCarrier, sideCarrier, true, key);
			thumb_sideCarrier_clip_place(sideCarrier)
				clip_s_part(sClip, true);
		}
}

module thumb_sideCarrier_assy(downCarrier, sideCarrier, key = "A", position = "down") {
	axle = thumb_sideCarrier_getAxle(sideCarrier);
	ledPair = thumb_sideCarrier_getLedPair(sideCarrier);
	led = led_pair_getLed(ledPair);
	transistor = led_pair_getTransistor(ledPair);

	union() {
		thumb_sideCarrier_outer_part(sideCarrier, true);
		thumb_sideCarrier_inner_part(sideCarrier, true);
		thumb_sideCarrier_hammer_assy(downCarrier, sideCarrier, key, position);
		thumb_sideCarrier_axle_place(sideCarrier)
			axle_part(axle, true);
		thumb_sideCarrier_led_place(sideCarrier)
			rotate([0, 0, -90])
				led_assy(led, true);
		mirror([1, 0, 0])
			thumb_sideCarrier_led_place(sideCarrier)
				rotate([0, 0, -90])
					led_assy(transistor, true);
	}
}