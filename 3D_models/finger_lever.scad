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

// This is the finger lever scad file containing all the modules to draw the levers for the fingers.
include <utility.scad>
include <lib.h.scad>
include <finger.h.scad>
include <magnet.scad>
include <clip.scad>
include <axle.scad>

module finger_lever_magnetHolder_comb(lever) {
	constants = finger_lever_getConstants(lever);
	magnet = finger_lever_getMagnet(lever);
	sClip = finger_lever_getSClip(lever);
	
	tWall = constants_calcTWall(constants);

	wMagnet = magnet_getW(magnet);
	dMagnet = magnet_getD(magnet);
	hMagnet = magnet_getH(magnet);
	
	tClip = clip_getT(sClip);
	
	w = finger_lever_calcW(lever);
	d = finger_lever_calcD(lever);
	hHolder = finger_lever_calcHMagnetHolder(lever);

	union() {
		ccube([dMagnet, d, tWall]);
		translate([0, -d/2 + hMagnet/2 + tClip, hHolder/2 - tWall/2])
			ccube([dMagnet, hMagnet, hHolder]);
	}
}

module finger_lever_magnetHolder_part(lever, withColor=false) {
	color = withColor ? finger_lever_getColor(lever) : undef;
	
	color(color) finger_lever_magnetHolder_comb(lever);
}

module finger_baseLever_comb(lever) {
	constants = finger_lever_getConstants(lever);
	axle = finger_lever_getAxle(lever);
	
	clearance = constants_getClearance(constants);
	
	rAxle = axle_getR(axle);
	
	w = finger_lever_calcW(lever);
	d = finger_lever_calcD(lever);
	hBody = finger_lever_calcHBody(lever);

	difference() {
		union() {
			translate([0, 0, hBody/2])
				ccube([w, d, hBody]);
			rotate([0,90,0])
				ccylinder(r = d/2, h = w);
		}
		rotate([0,90,0])
			ccylinder(r = rAxle + clearance/2, h = w*2);
	}
}

module finger_sideLever_comb(lever) {
	constants = finger_lever_getConstants(lever);
	magnet = finger_lever_getMagnet(lever);
	sClip = finger_lever_getSClip(lever);

	tWall = constants_calcTWall(constants);
	clearance = constants_getClearance(constants);

	dMagnet = magnet_getD(magnet);
	hMagnet = magnet_getH(magnet);

	tClip = clip_getT(sClip);
	
	w = finger_lever_calcW(lever);
	d = finger_lever_calcD(lever);
	hBody = finger_lever_calcHBody(lever);
	hMagnetOffset = finger_lever_calcHMagnetOffset(lever);
	tMagnetGap = finger_lever_calcTMagnetGap(lever);

	module holderCut() {
		translate([w - tWall - clearance/2, 0, hMagnetOffset])
			ccube([w, d*2, dMagnet + clearance]);
	}

	difference() {
		finger_baseLever_comb(lever);
		
		translate([0, -d/2 + hMagnet/2 + tClip, hMagnetOffset]) 
			ccube([w*2, hMagnet, dMagnet]);
		translate([0, -d + tClip + clearance, hMagnetOffset])
			ccube([tMagnetGap, d, dMagnet*2]);
		
		symmetric(2) holderCut();
	}
}

module finger_sideKeyCap_comb(sideKeyCap, capSize="small") {
	carrier = finger_sideKeyCap_getCarrier(sideKeyCap);
	lever = finger_lever(carrier);
	
	dLever = finger_lever_calcD(lever);
	wLever = finger_lever_calcW(lever);
	
	rInner = finger_sideKeyCap_calcRInner(sideKeyCap);
	rOuter = finger_sideKeyCap_calcROuter(sideKeyCap);
	w = finger_sideKeyCap_calcW(sideKeyCap);
	d = finger_sideKeyCap_calcD(sideKeyCap);
	hSmallKey = finger_sideKeyCap_getHSmallKey(sideKeyCap);
	hBigKey = finger_sideKeyCap_getHBigKey(sideKeyCap);
	h = (capSize == "small") ? hSmallKey : hBigKey;

	hTopRounding = hSmallKey/5;

	rotate([0, 0, 90])
		translate([-dLever/2, 0, 0])
			intersection() {
				translate([-d/2 + dLever, 0, 0]) 
					intersection() {
						union() {
							ccube([d, w, h - hTopRounding], hCenter = true);
							translate([0, 0, h - hTopRounding])
								resize([d, w, hTopRounding*2])
									rotate([0, 90, 0])
										ccylinder(r = w/2, h = d);
						}
						translate([0, 0, h/2])
							resize([w/2, w, h*2])
								ccylinder(r = w/2, h = h*2);
					}
				translate([-rInner, 0, 0])
					difference() {
						cylinder(r = rOuter, h = h);
						translate([0, 0, h/2])
							ccylinder(r = rInner, h = h*2);
					}
			}
}

module finger_sideLever_part(carrier, capSize = "small", withColor=false) {
	lever = finger_lever(carrier);
	sideKeyCap = finger_sideKeyCap(carrier);

	color = withColor ? finger_lever_getColor(lever) : undef;
	hBody = finger_lever_calcHBody(lever);
	
	color(color) 
		union() {
			finger_sideLever_comb(lever);
			translate([0, 0, hBody])
				finger_sideKeyCap_comb(sideKeyCap, capSize);
		}
}

module finger_sideLever_assy(carrier, capSize = "small") {
	lever = finger_lever(carrier);
	constants = finger_lever_getConstants(lever);
	magnet = finger_lever_getMagnet(lever);
	sClip = finger_lever_getSClip(lever);
	
	tWall = constants_calcTWall(constants);
	
	dMagnet = magnet_getD(magnet);
	hMagnet = magnet_getH(magnet);

	tClip = clip_getT(sClip);

	w = finger_lever_calcW(lever);
	d = finger_lever_calcD(lever);
	h = finger_lever_calcH(lever);	
	hMagnetOffset = finger_lever_calcHMagnetOffset(lever);
	
	module placeMagnetHolder() {
		translate([w/2 - tWall/2, 0, hMagnetOffset])
			rotate([0, -90, 0]) 
				finger_lever_magnetHolder_part(lever, withColor=true);
	}

	module placeMagnet() {
		translate([0, -d/2 + hMagnet/2 + tClip, hMagnetOffset])
			rotate([90, 0, 0])
				magnet_part(magnet, withColor=true);
	}
	
	union() {
		finger_sideLever_part(carrier, capSize = capSize, withColor=true);

		symmetric(2)
			placeMagnetHolder();
		placeMagnet();
	}
}

module finger_downLever_comb(lever) {
	constants = finger_lever_getConstants(lever);
	magnet = finger_lever_getMagnet(lever);
	sClip = finger_lever_getSClip(lever);
	
	clearance = constants_getClearance(constants);
	tWall = constants_calcTWall(constants);
	
	wMagnet = magnet_getW(magnet);
	dMagnet = magnet_getD(magnet);
	hMagnet = magnet_getH(magnet);

	tClip = clip_getT(sClip);

	w = finger_lever_calcW(lever);
	d = finger_lever_calcD(lever);
	hBody = finger_lever_calcHBody(lever);
	hHolder = finger_lever_calcHMagnetHolder(lever);
	tMagnetGap = finger_lever_calcTMagnetGap(lever);
	magnetCutTopOffset = finger_lever_calcDownLeverMagnetCutTopOffset(lever);

	difference() {
		finger_baseLever_comb(lever);
		
		translate([0, -tClip/2-clearance/2, hBody*3/2 - wMagnet - hHolder])
			ccube([dMagnet, hMagnet, hBody]);

		translate([0, -d + tClip + clearance, hBody - magnetCutTopOffset])
			ccube([w*2, d, tMagnetGap]);
		
		translate([0, 0, hBody*3/2 - tWall - clearance/2])
			ccube([dMagnet + clearance, d*2, hBody]);
	}
}

module finger_downLever_part(lever, withColor = false) {
	color = withColor ? finger_lever_getColor(lever) : undef;
	
	color(color) finger_downLever_comb(lever);
}

module finger_downLever_assy(lever) {
	constants = finger_lever_getConstants(lever);
	magnet = finger_lever_getMagnet(lever);
	sClip = finger_lever_getSClip(lever);
	
	tWall = constants_calcTWall(constants);

	wMagnet = magnet_getW(magnet);
	hMagnet = magnet_getH(magnet);
	
	tClip = clip_getT(sClip);
	
	d = finger_lever_calcD(lever);
	hBody = finger_lever_calcHBody(lever);
	hHolder = finger_lever_calcHMagnetHolder(lever);

	union() {
		finger_downLever_part(lever, withColor = true);
		
		translate([0, 0, hBody - tWall/2])
			rotate([0, 180, 0]) 
				finger_lever_magnetHolder_part(lever, withColor = true);
		
		translate([0, -d/2 + hMagnet/2 + tClip, hBody - wMagnet/2 - hHolder])
			rotate([90, 90, 0])
				magnet_part(magnet, withColor = true);
	}
}