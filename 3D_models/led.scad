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

// This is the led scad file containing the modules to draw the side looking leds and photo transistors.
include <utility.scad>
include <led.h.scad>

module led_package_comb(package) {
	w = led_package_getW(package);
	d = led_package_getD(package);
	h = led_package_getH(package);
	
	ccube([w,d,h]);
}

module led_package_part(package, withColor=false) {
	color = withColor ? led_package_getColor(package) : undef;
	
	color(color) led_package_comb(package);
}

module led_lens_comb(lens) {
	r = led_lens_getR(lens);
	
	csphere(r=r);
}

module led_lens_part(lens, withColor=false) {
	color = withColor ? led_lens_getColor(lens) : undef;
	
	color(color) led_lens_comb(lens);
}

module led_lead_comb(lead) {
	w = led_lead_getW(lead);
	d = led_lead_getD(lead);
	h = led_lead_getH(lead);
	
	ccube([w,d,h]);
}

module led_lead_part(lead, withColor=false) {
	color = withColor ? led_lens_getColor(lead) : undef;
	
	color(color) led_lead_comb(lead);
}

module led_assy(led, withColor=false) {
	package = led_getPackage(led);
	packageD = led_package_getD(package);
	packageH = led_package_getH(package);

	lens = led_getLens(led);
	lensTopOffset = led_lens_getTopOffset(lens);
	lensR = led_lens_getR(lens);

	leadA = led_getLeadA(led);
	leadB = led_getLeadB(led);
	leadAD = led_lead_getD(leadA);
	leadBD = led_lead_getD(leadB);
	leadAH = led_lead_getH(leadA) + packageH/2;
	leadBH = led_lead_getH(leadB) + packageH/2;

	_leadA = derive(leadA, led_lead(h=leadAH));
	_leadB = derive(leadB, led_lead(h=leadBH));

	leadFrontOffset = -packageD/2 + led_getLeadFrontOffset(led);
	leadDistance = led_getLeadDistance(led);
	
	union() {
		translate([0, packageD/2, -packageH/2 + lensTopOffset])
			union() {
				led_package_part(package, withColor);
				translate([-leadDistance/2, leadFrontOffset, -leadAH/2])
					led_lead_part(_leadA, withColor);
				translate([leadDistance/2, leadFrontOffset, -leadBH/2])
					led_lead_part(_leadB, withColor);
			}
		led_lens_part(lens, withColor);
	}
}

module led_example() {
	led_PT9087BF = led(
		package=led_package(w=4.6, d=1.7, h=5.9, color="DarkSlateGray"),
		lens=led_lens(r=0.85, topOffset=1.2, color="DarkSlateGray"),
		leadA=led_lead(w=0.4, d=0.4, h=10.1, color="LightGray"),
		leadB=led_lead(w=0.4, d=0.4, h=10.1, color="LightGray"),
		leadDistance=2.54,
		leadFrontOffset=1.7/2
	);
	$fn=32;
	led_assy(led_PT9087BF,withColor=true);
}
