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

// This is the led header scad file containing the object definitions and calculations of side looking leds and accompanying photo transistors.
include <utility.scad>

/* The package (main body) of the led */
// Constructor
function led_package(w, d, h, color) = box(w,d,h,[e("color", color)]);

// Accessors
function led_package_getW(this) = box_getW(this);
function led_package_getD(this) = box_getD(this);
function led_package_getH(this) = box_getH(this);
function led_package_getColor(this) = get(this, "color");
/*******/


/* The lens of the led */
// Constructor
function led_lens(r, topOffset, color) =
	[e("r", r), e("topOffset", topOffset), e("color", color)];
	
// Accessors
function led_lens_getR(this) = get(this, "r");
function led_lens_getTopOffset(this) = get(this, "topOffset");
function led_lens_getColor(this) = get(this, "color");
/*******/


/* A single lead of a led */
// Constructor
function led_lead(w, d, h, color) = box(w, d, h, [e("color", color)]);

// Accessors
function led_lead_getW(this) = box_getW(this);
function led_lead_getD(this) = box_getD(this);
function led_lead_getH(this) = box_getH(this);
function led_lead_getColor(this) = get(this, "color");
/*******/


/* A led (or transistor) */
// Constructor
function led(package, lens, leadA, leadB, leadDistance, leadFrontOffset) = [
	e("package", package), e("lens", lens),
	e("leadA", leadA), e("leadB", leadB), 
	e("leadDistance", leadDistance), e("leadFrontOffset", leadFrontOffset)];

// Accessors
function led_getPackage(this) = get(this, "package");
function led_getLens(this) = get(this, "lens");
function led_getLeadA(this) = get(this, "leadA");
function led_getLeadB(this) = get(this, "leadB");
function led_getLeadDistance(this) = get(this, "leadDistance");
function led_getLeadFrontOffset(this) = get(this, "leadFrontOffset");
/*******/


/* Led pair, a led pair is the average of the led and the transistor. */
// Constructor
function led_pair(led, transistor) =
	let(ledPackage = led_getPackage(led),
		ledLens = led_getLens(led),
		ledW = led_package_getW(ledPackage),
		ledD = led_package_getD(ledPackage),
		ledH = led_package_getH(ledPackage),
		ledR = led_lens_getR(ledLens),
		ledLensTopOffset = led_lens_getTopOffset(ledLens),
		ledLeadFrontOffset = led_getLeadFrontOffset(led),
		ledLeadDistance = led_getLeadDistance(led),
		
		transistorPackage = led_getPackage(transistor),
		transistorLens = led_getLens(transistor),
		transistorW = led_package_getW(transistorPackage),
		transistorD = led_package_getD(transistorPackage),
		transistorH = led_package_getH(transistorPackage),
		transistorR = led_lens_getR(transistorLens),
		transistorLensTopOffset = led_lens_getTopOffset(transistorLens),
		transistorLeadFrontOffset = led_getLeadFrontOffset(transistor),
		transistorLeadDistance = led_getLeadDistance(transistor),
		
		w = max(ledW, transistorW),
		d = max(ledD, transistorD),
		h = max(ledH, transistorH),
		r = max(ledR, transistorR),
		lensTopOffset = (ledLensTopOffset + transistorLensTopOffset) / 2,
		leadFrontOffset = (ledLeadFrontOffset + transistorLeadFrontOffset) / 2,
		leadDistance = (ledLeadDistance + transistorLeadDistance) / 2) [
	e("w", w), e("d", d), e("h", h), e("r", r), e("lensTopOffset", lensTopOffset),
	e("leadFrontOffset", leadFrontOffset), e("leadDistance", leadDistance),
	e("led", led), e("transistor", transistor)];

// Accessors
function led_pair_getW(this) = get(this, "w");
function led_pair_getD(this) = get(this, "d");
function led_pair_getH(this) = get(this, "h");
function led_pair_getR(this) = get(this, "r");
function led_pair_getLensTopOffset(this) = get(this, "lensTopOffset");
function led_pair_getLeadFrontOffset(this) = get(this, "leadFrontOffset");
function led_pair_getLeadDistance(this) = get(this, "leadDistance");
function led_pair_getLed(this) = get(this, "led");
function led_pair_getTransistor(this) = get(this, "transistor");
/*******/
