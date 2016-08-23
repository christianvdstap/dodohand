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

// This is the axle header scad file containing the object definitions and calculations for axles.
include <utility.scad>

/* A cylindrical axle */
// Constructor
function axle(r, w, color) = [
	e("r", r), e("w", w), e("color", color)];

// Accessors
function axle_getR(this) = get(this, "r");
function axle_getW(this) = get(this, "w");
function axle_getColor(this) = get(this, "color");
/*******/