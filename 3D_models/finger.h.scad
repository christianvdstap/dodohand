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

// This is the finger header scad file containing all object definitions and calculations related to the fingers.
include <utility.scad>
include <lib.h.scad>
include <led.h.scad>

/* fingerVector to keep values for each finger. */
// Constants
finger_index = 0;
finger_middle = 1;
finger_ring = 2;
finger_pinkie = 3;
finger_fingers = [0, 1, 2, 3];

// Constructor
function finger_vector(indexValue, middleValue, ringValue, pinkieValue) =
	[indexValue, middleValue, ringValue, pinkieValue];
	
// Accessors
function finger_vector_get(this, finger) = this[finger];
function finger_vector_getIndex(this) = this[finger_index];
function finger_vector_getMiddle(this) = this[finger_middle];
function finger_vector_getRing(this) = this[finger_ring];
function finger_vector_getPinkie(this) = this[finger_pinkie];
/*******/

/* Placement info of the fingers */
// Constructor
function finger_placement(originOffset, angles, origins, rInner, rOuter,
	ledGapDistance, sideLedOffset, downLedOffset) = [
	e("originOffset", originOffset), e("angles", angles), e("origins", origins), 
	e("rInner", rInner), e("rOuter", rOuter), e("ledGapDistance", ledGapDistance),
	e("sideLedOffset", sideLedOffset), e("downLedOffset", downLedOffset)];

// Accessors
function finger_placement_getOriginOffset(this) = get(this, "originOffset");
function finger_placement_getAngles(this) = get(this, "angles");
function finger_placement_getOrigins(this) = get(this, "origins");
function finger_placement_getRInner(this) = get(this, "rInner");
function finger_placement_getROuter(this) = get(this, "rOuter");
function finger_placement_getMountingHoles(this) = get(this, "mountingHoles");
function finger_placement_getLedGapDistance(this) = get(this, "ledGapDistance");
function finger_placement_getSideLedOffset(this) = get(this, "sideLedOffset");
function finger_placement_getDownLedOffset(this) = get(this, "downLedOffset");

// Calculations
function finger_placement_calcOriginWithOffset(this, finger) =
	let(origins = finger_placement_getOrigins(this),
		o = finger_vector_get(origins, finger),
		originOffset = finger_placement_getOriginOffset(this))
	[o[0] + originOffset[0], o[1] + originOffset[1], o[2]];
/*******/

/* Finger PCB information */
// Constructor
function finger_pcbInfo(points, mountHoleLocations, h) = [
	e("points", points), e("mountHoleLocations", mountHoleLocations), e("h", h)];

// Accessors
function finger_pcbInfo_getPoints(this) = get(this, "points");
function finger_pcbInfo_getMountHoleLocations(this) = get(this, "mountHoleLocations");
function finger_pcbInfo_getH(this) = get(this, "h");

/* Guard to act as a stop for the levers of the carriers and fixate the carriers on the pcb */
// Constructor
function finger_guard(constants, placement, pcbInfo, h, hFlange, hPinkie,
	mountHoleIndexes, color) = [
	e("constants", constants), e("placement", placement), e("pcbInfo", pcbInfo),
	e("h", h), e("hFlange", hFlange), e("hPinkie", hPinkie), 
	e("mountHoleIndexes", mountHoleIndexes), e("color", color)];

// Accessors
function finger_guard_getConstants(this) = get(this, "constants");
function finger_guard_getPlacement(this) = get(this, "placement");
function finger_guard_getPcbInfo(this) = get(this, "pcbInfo");
function finger_guard_getH(this) = get(this, "h");
function finger_guard_getHFlange(this) = get(this, "hFlange");
function finger_guard_getHPinkie(this) = get(this, "hPinkie");
function finger_guard_getMountHoleIndexes(this) = get(this, "mountHoleIndexes");
function finger_guard_getColor(this) = get(this, "color");

// Calculations
function finger_guard_calcTGuardWall(this) =
	let(constants = finger_guard_getConstants(this),
		tWall = constants_calcTWall(constants))
	tWall*3;
/*******/


/* The PCB for the finger unit */
// Constructor
function finger_pcb(constants, placement, pcbInfo, ledPair, color) = [
	e("constants", constants), e("placement", placement), e("pcbInfo", pcbInfo),
	e("ledPair", ledPair), e("color", color)];

// Accessors
function finger_pcb_getConstants(this) = get(this, "constants");
function finger_pcb_getPlacement(this) = get(this, "placement");
function finger_pcb_getPcbInfo(this) = get(this, "pcbInfo");
function finger_pcb_getLedPair(this) = get(this, "ledPair");
function finger_pcb_getColor(this) = get(this, "color");
/*******/

/* The finger carrier is the main piece inside the guard where the finger levers are attached to. */
// Constructor
function finger_carrier(constants, placement, ledPair, magnet, sClip, axle, leverInfo,
	h, hFloor,  color, leverColor) = [
	e("constants", constants), e("placement", placement), e("ledPair", ledPair),
	e("magnet", magnet), e("sClip", sClip), e("axle", axle), e("leverInfo", leverInfo),
	e("h", h), e("hFloor", hFloor), e("color", color), e("leverColor", leverColor)];

// Accessors
function finger_carrier_getConstants(this) = get(this, "constants");
function finger_carrier_getPlacement(this) = get(this, "placement");
function finger_carrier_getLedPair(this) = get(this, "ledPair");
function finger_carrier_getMagnet(this) = get(this, "magnet");
function finger_carrier_getSClip(this) = get(this, "sClip");
function finger_carrier_getAxle(this) = get(this, "axle");
function finger_carrier_getLeverInfo(this) = get(this, "leverInfo");
function finger_carrier_getH(this) = get(this, "h");
function finger_carrier_getHFloor(this) = get(this, "hFloor");
function finger_carrier_getColor(this) = get(this, "color");

//Calculations
function finger_carrier_calcTRim(carrier) =
	let(constants = finger_carrier_getConstants(carrier),
		tWall = constants_calcTWall(constants))
	tWall * 2;

function finger_carrier_calcInnerCubeSide(carrier) =
	let(constants = finger_carrier_getConstants(carrier),
		placement = finger_carrier_getPlacement(carrier),
		ledPair = finger_carrier_getLedPair(carrier),
	
		tWall = constants_calcTWall(constants),
		h = finger_carrier_getH(carrier),
		wLed = led_pair_getW(ledPair),
		sideLedOffset = finger_placement_getSideLedOffset(placement))
	(sideLedOffset + wLed/2 + tWall)*2;

function finger_carrier_calcOuterCubeSide(carrier) =
	let(innerCubeSide = finger_carrier_calcInnerCubeSide(carrier),
		tRim = finger_carrier_calcTRim(carrier))
	innerCubeSide + tRim*2;

function finger_carrier_calcInnerWallSide(carrier) =
	let(placement = finger_carrier_getPlacement(carrier),
		ledPair = finger_carrier_getLedPair(carrier),

		wLed = led_pair_getW(ledPair),
		sideLedOffset = finger_placement_getSideLedOffset(placement))
	sideLedOffset*2 - wLed;

function finger_carrier_calcAnvilSideA(carrier) =
	let(placement = finger_carrier_getPlacement(carrier),
		ledPair = finger_carrier_getLedPair(carrier),

		wLed = led_pair_getW(ledPair),
		downLedOffset = finger_placement_getDownLedOffset(placement))
	downLedOffset*2 + wLed;

function finger_carrier_calcAnvilSideB(carrier) =
	let(placement = finger_carrier_getPlacement(carrier),
		ledPair = finger_carrier_getLedPair(carrier),

		dLed = led_pair_getD(ledPair),
		ledGapDistance = finger_placement_getLedGapDistance(placement))
	ledGapDistance + dLed;
	
function finger_carrier_calcDownLedLensOffset(carrier) =
	let(ledPair = carrier_getLedPair(carrier),
	
		hLed = led_pair_getH(ledPair),
		ledLensTopOffset = led_pair_getLensTopOffset(ledPair),
		hFloor = carrier_getHFloor(carrier))
	hFloor + hLed - ledLensTopOffset;

function finger_carrier_calcDownAxleBottomOffset(carrier) =
	let(lever = finger_lever(carrier),
	
		dLever = finger_lever_calcD(lever),
		h = finger_carrier_getH(carrier),
		hAnvil = finger_carrier_calcHAnvil(carrier))
	hAnvil - dLever/2;

function finger_carrier_calcHAnvil(carrier) =
	let(constants = finger_carrier_getConstants(carrier),
		ledPair = finger_carrier_getLedPair(carrier),
		sClip = finger_carrier_getSClip(carrier),
		
		tWall = constants_calcTWall(constants),
		hFloor = finger_carrier_getHFloor(carrier),
		hLed = led_pair_getH(ledPair),
		tClip = clip_getT(sClip))
	tWall + hLed + tClip;

function finger_carrier_calcLeverGap(carrier) =
	let(placement = finger_carrier_getPlacement(carrier),
		ledPair = finger_carrier_getLedPair(carrier),

		ledGapDistance = finger_placement_getLedGapDistance(placement),
		dLed = led_pair_getD(ledPair),
		rLed = led_pair_getR(ledPair))
	ledGapDistance - dLed - rLed*2;
	
function finger_carrier_calcSideAxleFloorOffset(carrier) =
	let(axle = finger_carrier_getAxle(carrier),
		rAxle = axle_getR(axle),
		hFloor = finger_carrier_getHFloor(carrier))
	hFloor + rAxle;
/*******/


/* Lever information */
// Constructor
function finger_leverInfo(hSmallKey, hBigKey, color) = [
	e("hSmallKey", hSmallKey), e("hBigKey", hBigKey), e("color", color)];
	
// Accessors
function finger_leverInfo_getHSmallKey(this) = get(this, "hSmallKey");
function finger_leverInfo_getHBigKey(this) = get(this, "hBigKey");
function finger_leverInfo_getColor(this) = get(this, "color");
/*******/


/* The side lever of the carrier. */
// Constructor
function finger_lever(carrier) = [
	e("carrier", carrier)];

// Accessors
function finger_lever_getCarrier(this) = get(this, "carrier");
function finger_lever_getConstants(this) =
	finger_carrier_getConstants(get(this, "carrier"));
function finger_lever_getPlacement(this) =
	finger_carrier_getPlacement(get(this, "carrier"));
function finger_lever_getMagnet(this) =
	finger_carrier_getMagnet(get(this, "carrier"));
function finger_lever_getSClip(this) =
	finger_carrier_getSClip(get(this, "carrier"));
function finger_lever_getLedPair(this) =
	finger_carrier_getLedPair(get(this, "carrier"));
function finger_lever_getAxle(this) =
	finger_carrier_getAxle(get(this, "carrier"));
function finger_lever_getLeverInfo(this) =
	finger_carrier_getLeverInfo(get(this, "carrier"));
function finger_lever_getColor(this) =
	finger_leverInfo_getColor(finger_lever_getLeverInfo(this));

// Calculations
function finger_lever_calcW(this) =
	let(constants = finger_lever_getConstants(this),
		placement = finger_lever_getPlacement(this),
		ledPair = finger_lever_getLedPair(this),
		
		leverClearance = constants_calcLeverClearance(constants),
		ledGapDistance = finger_placement_getLedGapDistance(placement),
		dLed = led_pair_getD(ledPair),
		rLed = led_pair_getR(ledPair))
	ledGapDistance - dLed - rLed*2 - leverClearance*2;

function finger_lever_calcD(this) =
	let(constants = finger_lever_getConstants(this),
		ledPair = finger_lever_getLedPair(this),
		sClip = finger_lever_getSClip(this),
		
		rLed = led_pair_getR(ledPair),
		tClip = clip_getT(sClip),
		clearance = constants_getClearance(constants))
	rLed*2 + tClip + clearance;
	

function finger_lever_calcH(this) =
	let(carrier = finger_lever_getCarrier(this),
		hCarrier = finger_carrier_getH(carrier))
	hCarrier;

function finger_lever_calcTMagnetGap(this) =
	let(sClip = finger_lever_getSClip(this),
		hClip = clip_getH(sClip),
		tClip = clip_getT(sClip))
	hClip + tClip*2;
	
function finger_lever_calcHBody(this) =
	let(h = finger_lever_calcH(this),
		d = finger_lever_calcD(this))
	h - d/2;

function finger_lever_calcTMagnetEdge(this) =
	let(constants = finger_lever_getConstants(this),
		tWall = constants_calcTWall(constants))
	2*tWall;

function finger_lever_calcHMagnetOffset(this) =
	let(magnet = finger_lever_getMagnet(this),

		dMagnet = magnet_getD(magnet),
		hBody = finger_lever_calcHBody(this),
		tMagnetEdge = finger_lever_calcTMagnetEdge(this))
	hBody - dMagnet/2 - tMagnetEdge;

function finger_lever_calcHMagnetHolder(this) =
	let(magnet = finger_lever_getMagnet(this),
	
		w = finger_lever_calcW(this),
		wMagnet = magnet_getW(magnet))
	(w - wMagnet) / 2;
	
function finger_lever_calcDownLeverMagnetCutTopOffset(this) =
	let(hBody = finger_lever_calcHBody(this),
		tMagnetGap = finger_lever_calcTMagnetGap(this),
		tMagnetEdge = finger_lever_calcTMagnetEdge(this))
	tMagnetGap/2 + tMagnetEdge;
/*******/


/* Straight clip for the carrier anvil */
// Constructor
function finger_carrier_anvilClip(carrier) =
	let(constants = finger_carrier_getConstants(carrier),
		placement = finger_carrier_getPlacement(carrier),
		ledPair = finger_carrier_getLedPair(carrier),
		sClip = finger_carrier_getSClip(carrier),

		clearance = constants_getClearance(constants),
		ledGapDistance = finger_placement_getLedGapDistance(placement),
		dLed = led_pair_getD(ledPair),

		wb = ledGapDistance + dLed - clearance*2)
	derive(sClip, [e("wb", wb)]);
/*******/


/* Central hammer for the down button. */
// Constructor
function finger_centerHammer(carrier) = 
	[e("carrier", carrier)];

// Accessors
function finger_centerHammer_getCarrier(this) = get(this, "carrier");
function finger_centerHammer_getConstants(this) =
	finger_carrier_getConstants(get(this, "carrier"));
function finger_centerHammer_getPlacement(this) =
	finger_carrier_getPlacement(get(this, "carrier"));
function finger_centerHammer_getMagnet(this) =
	finger_carrier_getMagnet(get(this, "carrier"));
function finger_centerHammer_getSClip(this) =
	finger_carrier_getSClip(get(this, "carrier"));
function finger_centerHammer_getLedPair(this) =
	finger_carrier_getLedPair(get(this, "carrier"));
function finger_centerHammer_getAxle(this) =
	finger_carrier_getAxle(get(this, "carrier"));
function finger_centerHammer_getLeverInfo(this) =
	finger_carrier_getLeverInfo(get(this, "carrier"));
function finger_centerHammer_getColor(this) =
	finger_leverInfo_getColor(finger_centerHammer_getLeverInfo(this));

// Calculations
function finger_centerHammer_calcSide(this) = 
	let(carrier = finger_centerHammer_getCarrier(this),
		placement = finger_centerHammer_getPlacement(this),
		ledPair = finger_centerHammer_getLedPair(this),
		lever = finger_lever(carrier),

		dLever = finger_lever_calcD(lever),
		downLedOffset = finger_placement_getDownLedOffset(placement),
		wLed = led_pair_getW(ledPair))
	downLedOffset*2 - wLed;
	
function finger_centerHammer_calcSideCavity(this) =
	let(centerHammerSide = finger_centerHammer_calcSide(this))
	centerHammerSide*4/3;

function finger_centerHammer_calcHCavity(this) =
	let(centerHammerSide = finger_centerHammer_calcSide(this))
	centerHammerSide/2;

function finger_centerHammer_calcH(this) =
	let(carrier = finger_centerHammer_getCarrier(this),
		lever = finger_lever(carrier),
	
		hCarrier = finger_carrier_getH(carrier),
		hAnvil = finger_carrier_calcHAnvil(carrier),
		travel = finger_centerHammer_calcTravel(this))
	hCarrier - hAnvil + travel;

function finger_centerHammer_calcMaxLeverAngle(this) =
	let(carrier = finger_centerHammer_getCarrier(this),
		lever = finger_lever(carrier),
		
		hAnvil = finger_carrier_calcHAnvil(carrier),
		hFloor = finger_carrier_getHFloor(carrier),
		hBody = finger_lever_calcHBody(lever),
		dLever = finger_lever_calcD(lever),
		
		r = dLever/2,
		h = hAnvil - hFloor - r,
		q = math_pythagoras(a = hBody, b = r),
		x = math_pythagoras(b = h, h = q),
		A = atan(h/x),
		B = acos(hBody/q))
	A - B;
	
function finger_centerHammer_calcTravel(this) =
	let(carrier = finger_centerHammer_getCarrier(this),
		lever = finger_lever(carrier),
		
		dLever = finger_lever_calcD(lever),
		hLever = finger_lever_calcH(lever),
		hAnvil = finger_carrier_calcHAnvil(carrier),

		A = finger_centerHammer_calcMaxLeverAngle(this),
		m = tan(A),
		r = finger_centerHammer_calcSide(this) / 2,
		x = hLever/2,
		y1 = m*x - r * sqrt(1 + m*m),
		y2 = r / sin(A),
		y = y1 + y2,
		h = hAnvil - dLever/2)
	-(h - y - r);
/*******/


/** Center key cap */
// Constructor
function finger_centerKeyCap(carrier) = 
	[e("carrier", carrier)];

// Accessors
function finger_centerKeyCap_getCarrier(this) = get(this, "carrier");
function finger_centerKeyCap_getConstants(this) =
	finger_carrier_getConstants(get(this, "carrier"));
function finger_centerKeyCap_getPlacement(this) =
	finger_carrier_getPlacement(get(this, "carrier"));
function finger_centerKeyCap_getMagnet(this) =
	finger_carrier_getMagnet(get(this, "carrier"));
function finger_centerKeyCap_getSClip(this) =
	finger_carrier_getSClip(get(this, "carrier"));
function finger_centerKeyCap_getLedPair(this) =
	finger_carrier_getLedPair(get(this, "carrier"));
function finger_centerKeyCap_getAxle(this) =
	finger_carrier_getAxle(get(this, "carrier"));
function finger_centerKeyCap_getLeverInfo(this) =
	finger_carrier_getLeverInfo(get(this, "carrier"));
function finger_centerKeyCap_getColor(this) =
	finger_leverInfo_getColor(finger_centerKeyCap_getLeverInfo(this));

// Calculations
function finger_centerKeyCap_calcR(this) =
	let(carrier = finger_centerKeyCap_getCarrier(this),
		constants = finger_centerKeyCap_getConstants(this),
		placement = finger_centerKeyCap_getPlacement(this),
		lever = finger_lever(carrier),
		
		clearance = constants_getClearance(constants),
		tWall = constants_calcTWall(constants),
		sideLedOffset = finger_placement_getSideLedOffset(placement),
		dLever = finger_lever_calcD(lever))
	sideLedOffset - dLever/2 - clearance - tWall;
	
function finger_centerKeyCap_calcT(this) =
	let(carrier = finger_centerKeyCap_getCarrier(this),
		lever = finger_lever(carrier),
		dLever = finger_lever_calcD(lever))
	dLever;
/*******/


/** Side key cap */
function finger_sideKeyCap(carrier) = 
	[e("carrier", carrier)];

// Accessors
function finger_sideKeyCap_getCarrier(this) = get(this, "carrier");
function finger_sideKeyCap_getConstants(this) =
	finger_carrier_getConstants(get(this, "carrier"));
function finger_sideKeyCap_getPlacement(this) =
	finger_carrier_getPlacement(get(this, "carrier"));
function finger_sideKeyCap_getMagnet(this) =
	finger_carrier_getMagnet(get(this, "carrier"));
function finger_sideKeyCap_getSClip(this) =
	finger_carrier_getSClip(get(this, "carrier"));
function finger_sideKeyCap_getLedPair(this) =
	finger_carrier_getLedPair(get(this, "carrier"));
function finger_sideKeyCap_getAxle(this) =
	finger_carrier_getAxle(get(this, "carrier"));
function finger_sideKeyCap_getLeverInfo(this) =
	finger_carrier_getLeverInfo(get(this, "carrier"));
function finger_sideKeyCap_getColor(this) =
	finger_leverInfo_getColor(finger_sideKeyCap_getLeverInfo(this));
function finger_sideKeyCap_getHSmallKey(this) =
	finger_leverInfo_getHSmallKey(finger_sideKeyCap_getLeverInfo(this));
function finger_sideKeyCap_getHBigKey(this) =
	finger_leverInfo_getHBigKey(finger_sideKeyCap_getLeverInfo(this));
	
// Calculations
function finger_sideKeyCap_calcW(this) =
	let(placement = finger_sideKeyCap_getPlacement(this),
		ledPair = finger_sideKeyCap_getLedPair(this),
		
		ledGapDistance = finger_placement_getLedGapDistance(placement),
		dLed = led_pair_getD(ledPair))
	ledGapDistance + dLed;

function finger_sideKeyCap_calcD(this) =
	let(carrier = finger_sideKeyCap_getCarrier(this),
		lever = finger_lever(carrier),
		
		dLever = finger_lever_calcD(lever))
	dLever*2;

function finger_sideKeyCap_calcRInner(this) =
	let(carrier = finger_sideKeyCap_getCarrier(this),
		placement = finger_sideKeyCap_getPlacement(this),
		lever = finger_lever(carrier),
		
		sideLedOffset = finger_placement_getSideLedOffset(placement),
		dLever = finger_lever_calcD(lever))
	sideLedOffset - dLever/2;
	
function finger_sideKeyCap_calcROuter(this) =
	let(carrier = finger_sideKeyCap_getCarrier(this),
		placement = finger_sideKeyCap_getPlacement(this),
		lever = finger_lever(carrier),
		
		sideLedOffset = finger_placement_getSideLedOffset(placement),
		dLever = finger_lever_calcD(lever),
		wLever = finger_lever_calcW(lever),
		
		x = sideLedOffset + dLever/2,
		y = wLever / 2)
	sqrt(x*x + y*y);	
/*******/
