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

// This is the clip scad file containing the modules to draw clips of various shapes.
include <utility.scad>
include <clip.h.scad>

module clip_bend_comb(clip) {
	h = clip_getH(clip);
	rOuter = clip_calcROuter(clip);
	rInner = clip_calcRInner(clip);
	
	translate([-rOuter/2,rOuter/2,0])
		difference() {
			intersection() {
				translate([rOuter/2,-rOuter/2,0])
					ccube([rOuter, rOuter, h]);
				ccylinder(r = rOuter, h = h);
			}
			ccylinder(r = rInner, h = h*2);
		}
}

module clip_sbend_comb(clip) {
	t = clip_getT(clip);
	rOuter = clip_calcROuter(clip);

	union() {
		translate([rOuter/2, rOuter/2 - t/2,0])
			clip_bend_comb(clip);
		translate([-rOuter/2, -rOuter/2 + t/2,0])
			rotate([0, 0, 180])
				clip_bend_comb(clip);
	}
}

module clip_ubend_comb(clip) {
	rOuter = clip_calcROuter(clip);

	union() {
		translate([0, -rOuter/2, 0])
			clip_bend_comb(clip);
		translate([0, rOuter/2, 0])
			rotate([0, 0, 90])
				clip_bend_comb(clip);
	}
}

module clip_s_part(clip, withColor=false) {
	rOuter = clip_calcROuter(clip);
	t = clip_getT(clip);
	h = clip_getH(clip);
	wa = clip_getWa(clip) - rOuter;
	wb = clip_getWb(clip) - rOuter*2;
	wc = clip_getWc(clip) - rOuter;
	color = withColor ? clip_getColor(clip) : undef;
	
	dOffset = rOuter - t/2;
	
	color(color) 
		union() {
			clip_ubend_comb(clip);
			translate([-wb - rOuter, 2*dOffset, 0])
				rotate([0, 0, 180])
					clip_ubend_comb(clip);
			translate([-wa/2 - rOuter/2, -dOffset, 0])
				ccube([wa, t, h]);
			translate([-wb/2 - rOuter/2, dOffset, 0])
				ccube([wb, t, h]);
			translate([-wb + wc/2 - rOuter/2, 3*dOffset, 0])
				ccube([wc, t, h]);
		}
}

module clip_u_part(clip, withColor=false) {
	rOuter = clip_calcROuter(clip);
	t = clip_getT(clip);
	h = clip_getH(clip);
	wa = clip_getWa(clip) - rOuter;
	wb = clip_getWb(clip) - 2*rOuter;
	wc = clip_getWc(clip) - rOuter;
	color = withColor ? clip_getColor(clip) : undef;
	
	dOffset = rOuter - t/2;
	dBendOffset = wb/2 + dOffset;
	dSideOffset = wb/2 + 2*dOffset;
	wOffset = -rOuter + t/2;
	
	color(color)
		union() {
			translate([wOffset, dBendOffset, 0])
				clip_sbend_comb(clip);
			translate([wOffset, -dBendOffset, 0])
				rotate([0, 180, 0]) clip_sbend_comb(clip);
			translate([0, dSideOffset + wa/2, 0])
				ccube([t, wa, h]);
			translate([2*wOffset, 0, 0])
				ccube([t, wb, h]);
			translate([0, -dSideOffset - wc/2, 0])
				ccube([t, wc, h]);
		}
}

module clip_scut_comb(clip) {
	clearance = clip_getClearance(clip);
	rOuter = clip_calcROuter(clip);
	h = clip_getH(clip) + clearance*2;
	t = clip_getT(clip);
	
	wa = clip_getWa(clip);
	wb = clip_getWb(clip);
	wc = clip_getWc(clip);
	wbc = max(wb, wc) - rOuter + 2*clearance;
	
	d = 4*rOuter - t + clearance;
	
	union() {
		translate([-wa/2 + rOuter/2 + clearance/2, -t/2 - clearance, 0])
			ccube([wa+clearance, rOuter*2-t, h]);
		translate([-wbc/2 + rOuter/2 + clearance, rOuter - t/2 - clearance/2, 0])
			ccube([wbc, d, h]);
		translate([-wb/2 + clearance, rOuter*2-clearance/2 - t, 0])
			ccylinder(r=rOuter + clearance/2, h=h);
	}
}

module clip_smount_comb(clip) {
	clearance = clip_getClearance(clip);
	rOuter = clip_calcROuter(clip);
	rInner = clip_calcRInner(clip);
	h = clip_getH(clip) + clearance*2;
	t = clip_getT(clip);

	wa = clip_getWa(clip) - rOuter + clearance;
	
	union() {
		translate([-rInner/2-t/2, 0 ,0])
			ccylinder(r=rInner, h=h);
		translate([-wa/2-rInner/2-t/2, 0, 0])
			ccube([wa, rInner*2, h]);
	}
	
}

module clip_ucut_comb(clip) {
	clearance = clip_getClearance(clip);
	rOuter = clip_calcROuter(clip);
	rInner = clip_calcRInner(clip);
	h = clip_getH(clip) + clearance*2;
	t = clip_getT(clip);
	
	wa = clip_getWa(clip);
	wb = clip_getWb(clip);
	wc = clip_getWc(clip);

	module outerCut() {
		ccylinder(r=rInner, h=2*h);
		hull(){
			translate([rInner/2, rOuter, 0]) ccube([rInner, rOuter*2, 2*h]);
			translate([-rOuter, -rInner/2, 0]) ccube([rOuter*2, rInner, 2*h]);
			translate([-rOuter, rOuter, 0]) ccube([rOuter*2, rOuter*2, 2*h]);
		}
	}
	
	difference() {
		translate([-rOuter + t/2, 0, 0])
			ccube([2*rOuter + 2*clearance, wa+wb+wc - 2*t + 2*clearance, h]);		
		translate([-rInner-t/2, wb/2 + rInner, 0])
			outerCut();
		translate([-rInner-t/2, -(wb/2 + rInner), 0])
			mirror([0, 1, 0])
				outerCut();
	}
}

module clip_s_assy(clip, withColor=false) {
	union() {
		clip_s_part(clip, withColor=withColor);
		clip_smount_comb(clip);
	}
}

module clip_straight_comb(clip) {
	hClip = clip_getH(clip);
	tClip = clip_getT(clip);
	wb = clip_getWb(clip);

	ccube([wb, hClip, tClip]);
}

module clip_straight_part(clip, withColor = false) {
	color = withColor ? clip_getColor(clip) : undef;

	color(color) clip_straight_comb(clip);
}

module clip_s_example() {
	clip = 
		let(h = 1.13,
			t = 0.38,
			r = 0.74,
			wa = 3.5,
			wb = 2.5,
			wc = wb - r - t/2,
			clearance = 0.1)
		clip(
			h = h,
			t = t,
			r = r,
			wa = wa,
			wb = wb,
			wc = wc,
			clearance = clearance,
			color = "Gray");

	$fn=64;
	rOuter = clip_calcROuter(clip);
	wa = clip_getWa(clip);
	h = clip_getH(clip);
	clearance = clip_getClearance(clip);
	
	union() {
		difference() {
			ccube([wa*2, rOuter*6, h*2]);
			translate([wa - rOuter/2,-rOuter*3 + clearance/2,0])
				clip_scut_comb(clip);
		}
		
		translate([wa - rOuter/2,-rOuter*3,0])
			clip_s_assy(clip, withColor=true);
	}
}

module clip_u_example() {
	clip = 
		let(h = 1.13,
			t = 0.38,
			r = 0.74,
			wa = 2,
			wb = 4.5,
			wc = wa,
			clearance = 0.1)
		clip(
			h = h,
			t = t,
			r = r,
			wa = wa,
			wb = wb,
			wc = wc,
			clearance = clearance,
			color = "Gray");

	$fn=64;
	rOuter = clip_calcROuter(clip);
	wb = clip_getWb(clip);
	h = clip_getH(clip);
	t = clip_getT(clip);
	clearance = clip_getClearance(clip);

	union() {
		difference() {
			translate([-2*rOuter+t/2,0,0])
				ccube([4*rOuter, 10,3]);
			translate([0,0,0])
				ccube([6*rOuter,4.5,6]);
			clip_ucut_comb(clip);
		}
		clip_u_part(clip, withColor=true);
	}
}
