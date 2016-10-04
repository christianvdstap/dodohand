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

// This is the thumb header scad file containing all object definitions and calculations related to the thumb.
include <utility.scad>
include <axle.h.scad>
include <led.h.scad>

/* A vector to keep the information of thumb side keys. */
// Constants
thumb_keyA = 0;
thumb_keyB = 1;
thumb_keyC = 2;
thumb_keyD = 3;
thumb_keys = [thumb_keyA, thumb_keyB, thumb_keyC, thumb_keyD];

// Constructor
function thumb_vector(keyAValue, keyBValue, keyCValue, keyDValue) = 
	[keyAValue, keyBValue, keyCValue, keyDValue];
	
// Accessors
function thumb_vector_get(this, thumbKey) = this[thumbKey];
function thumb_vector_getKeyA(this) = this[thumbKeyA];
function thumb_vector_getKeyB(this) = this[thumbKeyB];
function thumb_vector_getKeyC(this) = this[thumbKeyC];
function thumb_vector_getKeyD(this) = this[thumbKeyD];
/*******/


/* Placement information for the side keys of the thumb. */
// Constructor
function thumb_sidePlacementInfo(ledFrontOffset, ledGapDistance, holeFrontOffset, holeBackOffset, holeSideOffset) = [
	e("ledFrontOffset", ledFrontOffset), e("ledGapDistance", ledGapDistance),
	e("holeFrontOffset", holeFrontOffset), e("holeBackOffset", holeBackOffset), e("holeSideOffset", holeSideOffset)];

// Accessors
function thumb_sidePlacementInfo_getLedFrontOffset(this) = get(this, "ledFrontOffset");
function thumb_sidePlacementInfo_getLedGapDistance(this) = get(this, "ledGapDistance");
function thumb_sidePlacementInfo_getHoleFrontOffset(this) = get(this, "holeFrontOffset");
function thumb_sidePlacementInfo_getHoleBackOffset(this) = get(this, "holeBackOffset");
function thumb_sidePlacementInfo_getHoleSideOffset(this) = get(this, "holeSideOffset");
/*******/


/* Placement information of the down key of the thumb. */
// Constructor
function thumb_downPlacementInfo(ledGapDistance, ledOffset) = [
	e("ledGapDistance", ledGapDistance), e("ledOffset", ledOffset)];
	
// Accessors
function thumb_downPlacementInfo_getLedGapDistance(this) = get(this, "ledGapDistance");
function thumb_downPlacementInfo_getLedOffset(this) = get(this, "ledOffset");
/*******/


/* Placement information of the thumb. */
// Constructor
function thumb_placement(sideInfo, downInfo, downOrigin, sideOrigins, sideAngles) = [
	e("sideInfo", sideInfo), e("downInfo", downInfo), e("downOrigin", downOrigin),
	e("sideOrigins", sideOrigins), e("sideAngles", sideAngles)];
	
// Accessors
function thumb_placement_getSideInfo(this) = get(this, "sideInfo");
function thumb_placement_getDownInfo(this) = get(this, "downInfo");
function thumb_placement_getDownOrigin(this) = get(this, "downOrigin");
function thumb_placement_getSideOrigins(this) = get(this, "sideOrigins");
function thumb_placement_getSideOrigin(this, thumbKey) = thumb_vector_get(get(this, "sideOrigins"), thumbKey);
function thumb_placement_getSideAngles(this) = get(this, "sideAngles");
function thumb_placement_getSideAngle(this, thumbKey) = thumb_vector_get(get(this, "sideAngles"), thumbKey);
/*******/


/* Thumb PCB information */
// Constructor
function thumb_pcb(constants, placement, ledPair, downKey, points, mountHoleLocations, h, color) = [
	e("constants", constants), e("placement", placement), e("ledPair", ledPair),
	e("points", points), e("mountHoleLocations", mountHoleLocations), e("h", h), e("color", color)];

// Accessors
function thumb_pcb_getConstants(this) = get(this, "constants");
function thumb_pcb_getPlacement(this) = get(this, "placement");
function thumb_pcb_getLedPair(this) = get(this, "ledPair");
function thumb_pcb_getPoints(this) = get(this, "points");
function thumb_pcb_getMountHoleLocations(this) = get(this, "mountHoleLocations");
function thumb_pcb_getH(this) = get(this, "h");
function thumb_pcb_getColor(this) = get(this, "color");
/*******/


/* Thumb down key information.
 *          |
 *        D_|
 *        / \
 *       /  |\        
 *     E/   | \ 
 *      |   |  \
 *     F\   |   \
 *       |  |    \
 *      G|  |     |C
 *       |  |    /
 *       |  |   /
 *       |  |  /B
 *       |  |  |
 *       |__|__|
 *       H  O  A
 *          |
 */
// Constructor
function thumb_downKey(axle, points, h, color) = [
	e("axle", axle), e("points", points), e("h", h), e("color", color)];

// Accessors
function thumb_downKey_getAxle(this) = get(this, "axle");
function thumb_downKey_getPoints(this) = get(this, "points");
function thumb_downKey_getH(this) = get(this, "h");
function thumb_downKey_getColor(this) = get(this, "color");

// Calculations
function thumb_downKey_calcWHinge(this) =
	let(points = thumb_downKey_getPoints(this),
		AH = abs(points[0][0] - points[len(points) - 1][0]))
	AH/2;

function thumb_downKey_calcTHinge(this) =
	let(axle = thumb_downKey_getAxle(this),
	
		r = axle_getR(axle))
	r*2 * 2;
		
function thumb_downKey_calcRHinge(this) =
	let(t = thumb_downKey_calcTHinge(this))
	t/2;

/*******/


/* Thumb down carrier information. */
function thumb_downCarrier(constants, placement, ledPair, magnet, sClip, downKey, h, hFloor, color) = [
	e("constants", constants), e("placement", placement), e("ledPair", ledPair), e("magnet", magnet),
	e("sClip", sClip),  e("downKey", downKey), e("h", h), e("hFloor", hFloor), e("color", color)];

// Accessors
function thumb_downCarrier_getConstants(this) = get(this, "constants");
function thumb_downCarrier_getPlacement(this) = get(this, "placement");
function thumb_downCarrier_getLedPair(this) = get(this, "ledPair");
function thumb_downCarrier_getMagnet(this) = get(this, "magnet");
function thumb_downCarrier_getSClip(this) = get(this, "sClip");
function thumb_downCarrier_getDownKey(this) = get(this, "downKey");
function thumb_downCarrier_getH(this) = get(this, "h");
function thumb_downCarrier_getHFloor(this) = get(this, "hFloor");
function thumb_downCarrier_getColor(this) = get(this, "color");

// Calculations
function thumb_downCarrier_calcTWall(this) =
	let(constants = thumb_downCarrier_getConstants(this),
		clearance = constants_getClearance(constants),
		tWall = constants_calcTWall(constants))
	tWall*2 + clearance;

function thumb_downCarrier_calcTRoof(this) =
	let(constants = thumb_downCarrier_getConstants(this),
		magnet = thumb_downCarrier_getMagnet(this),
		tWall = constants_calcTWall(constants),
		hMagnet = magnet_getH(magnet))
	tWall + hMagnet + tWall;

function thumb_downCarrier_calcW(this) =
	let(placement = thumb_downCarrier_getPlacement(this),
		ledPair = thumb_downCarrier_getLedPair(this),

		dLed = led_pair_getD(ledPair),
		ledGapDistance = thumb_downPlacementInfo_getLedGapDistance(placement),
		tWall = thumb_downCarrier_calcTWall(this))
	ledGapDistance + dLed + tWall*2;
	
function thumb_downCarrier_calcD(this) =
	let(placement = thumb_downCarrier_getPlacement(this),
		ledPair = thumb_downCarrier_getLedPair(this),
		downKey = thumb_downCarrier_getDownKey(this),

		wLed = led_pair_getW(ledPair),
		ledOffset = thumb_downPlacementInfo_getLedOffset(placement),
		tDownKeyHinge = thumb_downKey_calcTHinge(downKey),
		tWall = thumb_downCarrier_calcTWall(this))
	ledOffset*2 + wLed + tWall*2 + tDownKeyHinge;
	
function thumb_downCarrier_calcWBar(this) =
	let(placement = thumb_downCarrier_getPlacement(this),
		ledPair = thumb_downCarrier_getLedPair(this),

		dLed = led_pair_getD(ledPair),
		rLed = led_pair_getR(ledPair),
		ledGapDistance = thumb_downPlacementInfo_getLedGapDistance(placement))
	ledGapDistance - dLed - rLed*2;
	
function thumb_downCarrier_calcDBar(this) =
	let(placement = thumb_downCarrier_getPlacement(this),
		ledPair = thumb_downCarrier_getLedPair(this),

		wLed = led_pair_getW(ledPair),
		ledOffset = thumb_downPlacementInfo_getLedOffset(placement),
		tWall = thumb_downCarrier_calcTWall(this))
	ledOffset * 2 + wLed;
	
function thumb_downCarrier_calcHBar(this) =
	let(ledPair = thumb_downCarrier_getLedPair(this),
	
		topOffset = led_pair_getLensTopOffset(ledPair),
		rLed = led_pair_getR(ledPair),
		h = thumb_downCarrier_getH(this),
		tRoof = thumb_downCarrier_calcTRoof(this))
	h - topOffset - rLed - tRoof;
	
function thumb_downCarrier_calcBarRetainOffset(this) =
	let(ledPair = thumb_downCarrier_getLedPair(this),
		wLed = led_pair_getW(ledPair),
		rLed = led_pair_getR(ledPair),
		dBar = thumb_downCarrier_calcDBar(this))
	dBar/2 - wLed/2 + rLed;
	
function thumb_downCarrier_calcHammerOffset(this) =
	let(constants = thumb_downCarrier_getConstants(this),
		magnet = thumb_downCarrier_getMagnet(this),
		tWall = constants_calcTWall(constants),
		dMagnet = magnet_getD(magnet),
		retainOffset = thumb_downCarrier_calcBarRetainOffset(this))
	retainOffset - dMagnet - tWall;
	
function thumb_downCarrier_calcAxleTopOffset(this) =
	let(downKey = thumb_downCarrier_getDownKey(this),
		axle = thumb_downKey_getAxle(downKey),
		rAxle = axle_getR(axle),
		tCarrierWall = thumb_downCarrier_calcTWall(this))
	rAxle + tCarrierWall;
	
function thumb_downCarrier_calcTravelDistance(this) =
	let(ledPair = thumb_downCarrier_getLedPair(this),
		rLed = led_pair_getR(ledPair),
		lensTopOffset = led_pair_getLensTopOffset(ledPair))
	lensTopOffset + rLed;
	
function thumb_downCarrier_calcMaxRotation(this) =
	let(downKey = thumb_downCarrier_getDownKey(this),
		dCarrier = thumb_downCarrier_calcD(this),
		hammerOffset = thumb_downCarrier_calcHammerOffset(this),
		tHinge = thumb_downKey_calcTHinge(downKey),
		travelDistance = thumb_downCarrier_calcTravelDistance(this),
		r = dCarrier/2 + hammerOffset - tHinge/2)
	asin(travelDistance / r);
/*******/


/* Thumb side key information. */
// Constructor
function thumb_key(h, color) = [
	e("h", h), e("color", color)];

// Accessor
function thumb_key_getH(this) = get(this, "h");
function thumb_key_getColor(this) = get(this, "color");
/*******/


/* Thumb up key inforation.
 *   <   d    >
 *       _ _ _
 *  ^   / _ __|
 *  h2 / /
 *    / /
 *  v/ / <wTop>
 *  ^| |
 *  h| |
 *  v| |
 */
// Constructor
function thumb_upKey(d, wTop, h, h2) = [
	e("d", d), e("wTop", wTop), e("h", h), e("h2", h2)];

// Accessors
function thumb_upKey_getD(this) = get(this, "d");
function thumb_upKey_getWTop(this) = get(this, "wTop");
function thumb_upKey_getH(this) = get(this, "h");
function thumb_upKey_getH2(this) = get(this, "h2");
/*******/

