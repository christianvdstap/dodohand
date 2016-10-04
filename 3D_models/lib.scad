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

// This is the lib scad file where all the components and measurements are kept.
include <utility.scad>
include <lib.h.scad>
include <magnet.h.scad>
include <led.h.scad>
include <clip.h.scad>
include <axle.h.scad>
include <finger.h.scad>
include <thumb.h.scad>

// Constants
constants = 
	let(dInnerM2 = 2.03,
		dInnerM3 = 3.2,
		dOuterM3 = 6.0,
		dVia = 0.99,
		rInnerM2 = dInnerM2/2,
		rInnerM3 = dInnerM3/2,
		rOuterM3 = dOuterM3/2,
		rVia = dVia/2)
	constants(
		nozzleWidth = 0.25,
		clearance = 0.1,
		rInnerM3 = rInnerM3,
		rOuterM3 = rOuterM3,
		rEdgeRimM3 = 0.34,
		rVia = rVia
	);

// Components
lib_magnet_5x4x1 = magnet(
	w = 4,
	d = 5,
	h = 1,
	color="Silver"
);

lib_magnet_4x3x08 = magnet(
	w = 3,
	d = 4,
	h = 0.8,
	color="Silver"
);

lib_axle_08x10 = axle(
	r = 0.4,
	w = 10,
	color = "LightGray"
);

lib_axle_15x12 = axle(
	r = 0.75,
	w = 12,
	color = "LightGray"
);

lib_LTE302 = 
	let(d = 1.7,
		leadFrontOffset = d/2)
	led(
		package = led_package(w=4.6, d=d, h=5.92, color="DarkRed"),
		lens = led_lens(r=0.8, topOffset=1.22, color="DarkRed"),
		leadA = led_lead(w=0.5, d=0.5, h=12.7, color="LightGray"),
		leadB = led_lead(w=0.5, d=0.5, h=13.7, color="LightGray"),
		leadDistance = 2.54,
		leadFrontOffset = leadFrontOffset
	);

lib_PT9087BF =
	let(d = 1.7,
		leadFrontOffset = d/2)
	led(
		package=led_package(w=4.6, d=d, h=5.9, color="DarkSlateGray"),
		lens=led_lens(r=0.85, topOffset=1.2, color="DarkSlateGray"),
		leadA=led_lead(w=0.4, d=0.4, h=10.1, color="LightGray"),
		leadB=led_lead(w=0.4, d=0.4, h=10.1, color="LightGray"),
		leadDistance=2.54,
		leadFrontOffset=leadFrontOffset
	);

lib_led_pair =
	led_pair(lib_LTE302, lib_PT9087BF);

lib_s_clip = 
	let(h = 1.13,
		t = 0.38,
		r = 0.74,
		wa = 3.5,
		wb = 2.5,
		wc = wb,
		clearance = constants_getClearance(constants))
	clip(
		h = h,
		t = t,
		r = r,
		wa = wa,
		wb = wb,
		wc = wc,
		clearance = clearance,
		color = "Gray");

// Finger
lib_finger_placementInfo =
	let(oPinkie=[-76.38, 19.36, 0],
		oRing=[-54.28, 2.20, 0],
		oMiddle=[-27.78, -5.70, 0],
		oIndex=[0, 0, 0],
		aPinkie=-33.0,
		aRing=-21.0,
		aMiddle=4.1,
		aIndex=17.6)
	finger_placement(
		originOffset = [0.14, 0.14],
		angles = finger_vector(aIndex, aMiddle, aRing, aPinkie),
		origins= finger_vector(oIndex, oMiddle, oRing, oPinkie),
		rInner = 14.6757,
		rOuter = 20.6757,
		ledGapDistance = 10.2,
		sideLedOffset = 8.95,
		downLedOffset = 3.84		
	);

lib_finger_pcbInfo =
	let(A = [-93.12, -50.28],
		B = [3.94, -50.28],
		C = [16.66, -37.59],
		D = [16.66, 12.10],
		E = [-16.95,11.90],
		F = [-33.34, 14.24],
		G = [-38.64, 15.73],
		H = [-38.64, 40.01],
		I = [-76.36, 40.01],
		J = [-93.12, 31.45],

		M1 = [-88.31, -45.72, 0],
		M2 = [-5.08, -45.72, 0],
		M3 = [-88.31, 2.37, 0],
		M4 = [-67.59, -13.65, 0],
		M5 = [-15.95, -22.65, 0],
		M6 = [11.91, -16.99, 0],
		M7 = [-88.31, 36.24, 0],
		M8 = [-56.10, 22.78, 0],
		M9 = [-36.55, 13.02, 0],
		M10 = [-11.85, 16.94, 0]		
	)
	finger_pcbInfo(
		points = [A, B, C, D, E, F, G, H, I, J],
		mountHoleLocations = [M1, M2, M3, M4, M5, M6, M7, M8, M9, M10],
		h = 1.6
	);

lib_fingerPcb =
	finger_pcb(
		constants = constants,
		placement = lib_finger_placementInfo,
		pcbInfo = lib_finger_pcbInfo,
		ledPair = lib_led_pair,

		color="Green"
	);

lib_guard = 
	let(holes = finger_pcbInfo_getMountHoleLocations(lib_finger_pcbInfo),
		mountHoleIndexes = [2 : len(holes) - 1])
	finger_guard(
		constants = constants,
		placement = lib_finger_placementInfo,
		pcbInfo = lib_finger_pcbInfo,

		h = 15,
		hPinkie = 18,
		hFlange = 2,
		mountHoleIndexes = mountHoleIndexes,
		color = "SteelBlue"
	);

lib_leverInfo =
	finger_leverInfo(
		hSmallKey = 10,
		hBigKey = 15,
		color = "RoyalBlue"
	);

lib_finger_carrier =
	finger_carrier(
		constants = constants,
		placement = lib_finger_placementInfo,
		ledPair = lib_led_pair,
		magnet = lib_magnet_5x4x1,
		sClip = lib_s_clip,
		axle = lib_axle_08x10,
		leverInfo = lib_leverInfo,

		h = 12,
		hFloor = 1.5,
		color = "LightSteelBlue"
	);

// Thumb
lib_thumb_sidePlacementInfo = 
	thumb_sidePlacementInfo(
		ledFrontOffset = 3.00,
		ledGapDistance = 8.08,
		holeFrontOffset = 2.34,
		holeBackOffset = 20.98,
		holeSideOffset = 7.92
	);
	
lib_thumb_downPlacementInfo =
	thumb_downPlacementInfo(
		ledGapDistance = 9.76,
		ledOffset = 13.08
	);

lib_thumb_placementInfo =
	let(
		oKeyA = [7.98, -16.00],
		oKeyB = [-10.00, -14.00],
		oKeyC = [9.50, 9.98],
		oKeyD = [-19.99, 5.99],
		aKeyA = 14,
		aKeyB = 160,
		aKeyC = 0,
		aKeyD = 170	
	)
	thumb_placement(
		sideInfo = lib_thumb_sidePlacementInfo,
		downInfo = lib_thumb_downPlacementInfo,
		downOrigin = [0, 0],
		sideOrigins = thumb_vector(oKeyA, oKeyB, oKeyC, oKeyD),
		sideAngles = thumb_vector(aKeyA, aKeyB, aKeyC, aKeyD)
	);
	
lib_thumb_pcb =
	let(
		A=[-22.06, 20.55],
		B=[33.10, 20.52],
		C=[33.10, -28.10],
		D=[0.07, -28.10],
		E=[-46.50, -22.55],
		F=[-46.50, 2.27],
		M1 = [-0.06, -23.08, 0],
		M2 = [27.85, -4.95, 0],
		M3 = [-13.04, 17.28, 0],
		M4 = [-29.40, -9.30, 0]
	)
	thumb_pcb(
		constants = constants,
		placement = lib_thumb_placementInfo,
		ledPair = lib_led_pair,
		points = [A, B, C, D, E, F],
		mountHoleLocations = [M1, M2, M3, M4],
		h = 1.6,

		color = "Green"
	);
	
lib_thumb_downKey =
	let(
		A = [6, 0],
		B = [6, 12],
		C = [9.5, 23],
		D = [-1.5, 48],
		E = [-7, 32],
		F = [-6.5, 24],
		G = [-6, 16],
		H = [-6, 0]
	)
	thumb_downKey(
		axle = lib_axle_15x12,
		points = [A, B, C, D, E, F, G, H],
		h = 3,
		color = "RoyalBlue"
	);
		
lib_thumb_downCarrier =
	thumb_downCarrier(
		constants = constants,
		placement = lib_thumb_downPlacementInfo,
		ledPair = lib_led_pair,
		magnet = lib_magnet_5x4x1,
		sClip = lib_s_clip,
		downKey = lib_thumb_downKey,

		h = 9.5,
		hFloor = 1.5,

		color = "LightSteelBlue"
	);

lib_thumb_sideKey =
	thumb_key(
		h = 15,
		color = "RoyalBlue"
	);
	
lib_thumb_upKey = 
	thumb_upKey(
		d = 0,
		wTop = 8,
		h = 15,
		h2 = 10
	);	

lib_thumb_anvil = [];