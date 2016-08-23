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

// This is the clip header scad file containing object definitions and calculations for clips of various shapes.
include <utility.scad>

function clip(h, t, r, wa, wb, wc, clearance, color) = [
	e("h", h), e("t", t), e("r", r),
	e("wa", wa), e("wb", wb), e("wc", wc),
	e("clearance", clearance), e("color", color)];
function clip_getH(this) = get(this, "h");
function clip_getT(this) = get(this, "t");
function clip_getR(this) = get(this, "r");
function clip_getWa(this) = get(this, "wa");
function clip_getWb(this) = get(this, "wb");
function clip_getWc(this) = get(this, "wc");
function clip_getClearance(this) = get(this, "clearance");
function clip_getColor(this) = get(this, "color");

function clip_calcROuter(this) =
	let(r = clip_getR(this),
		t = clip_getT(this))
	r + t/2;
function clip_calcRInner(this) =
	let(r = clip_getR(this),
		t = clip_getT(this))
	r - t/2;