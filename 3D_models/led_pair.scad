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

// This is the led pair scad file containing the reusable combinations for led / transistor pairs.
include <utility.scad>
include <led.h.scad>

module led_pair_cut_comb(h, ledPair) {
	wLed = led_pair_getW(ledPair);
	dLed = led_pair_getD(ledPair);
	hLed = led_pair_getH(ledPair);
	rLed = led_pair_getR(ledPair);
	ledLeadFrontOffset = led_pair_getLeadFrontOffset(ledPair);
	ledLensTopOffset = led_pair_getLensTopOffset(ledPair);
	ledLeadDistance = led_pair_getLeadDistance(ledPair);
	
	translate([0, 0, -hLed/2 + ledLensTopOffset])
		union() {
			translate([dLed/2, 0, 0])
				ccube([dLed, wLed, hLed]);
			mirror2([0, 1, 0])
				translate([ledLeadFrontOffset, ledLeadDistance/2, -h/2 + hLed/2]) {
					ccylinder(r = dLed/4, h = h);
					translate([dLed/4, 0, 0])
						ccube([dLed/2, dLed/2, h]);
				}
			translate([0, 0, hLed/2 - ledLensTopOffset])
				rotate([0, 90, 0])
					ccylinder(r = rLed, h = dLed*2);
		}
}
