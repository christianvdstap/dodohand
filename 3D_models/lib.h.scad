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

// This is the lib header scad file containing the constant object definitions and calculations.
include <utility.scad>

/* General constants that are used in many places. */
// Constructor
function constants(nozzleWidth, clearance, rInnerM2, rInnerM3, rOuterM3, rEdgeRimR3, rVia) = [
	e("nozzleWidth", nozzleWidth), e("clearance", clearance), e("rInnerM2", rInnerM2),
	e("rInnerM3", rInnerM3), e("rOuterM3", rOuterM3), e("rEdgeRimM3", rEdgeRimM3),
	e("rVia", rVia)];

// Accessors
function constants_getNozzleWidth(this) = get(this, "nozzleWidth");
function constants_getClearance(this) = get(this, "clearance");
function constants_getRInnerM2(this) = get(this, "rInnerM2");
function constants_getRInnerM3(this) = get(this, "rInnerM3");
function constants_getROuterM3(this) = get(this, "rOuterM3");
function constants_getREdgeRimM3(this) = get(this, "rEdgeRimM3");
function constants_getRVia(this) = get(this, "rVia");

// Calculations
function constants_calcTWall(this) =
	let(nozzleWidth = constants_getNozzleWidth(this))
	nozzleWidth*2;

function constants_calcLeverClearance(this) =
	let(nozzleWidth = constants_getNozzleWidth(this),
		clearance = constants_getClearance(this))
	nozzleWidth + clearance;
/*******/