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

// This is the pcb scad file containing PCB utility modules.
include <utility.scad>
include <lib.h.scad>
include <led.h.scad>

module viasLedPair2D(constants, ledPair, ledGapDistance) {
	leadDistance = led_pair_getLeadDistance(ledPair);
	rVia = constants_getRVia(constants);
	
	viaOffset = leadDistance / 2;
	viaGapOffset = ledGapDistance / 2;
	
	mirror2([1, 0, 0])
		mirror2([0, 1, 0]) 
			translate([viaGapOffset, viaOffset, 0])
				circle(r = rVia);
}