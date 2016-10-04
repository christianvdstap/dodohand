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

// This is the math scad file that will contain math helper functions.

function lineLength(p, q) = sqrt(pow(p[0]-q[0],2)+pow(p[1]-q[1],2));

function minAxis(points, axis, index) = 
	index == len(points) - 1
		? points[index][axis] 
		: min(points[index][axis], minAxis(points, axis, index+1));

function maxAxis(points, axis, index) = 
	index == len(points) - 1
		? points[index][axis] 
		: max(points[index][axis], maxAxis(points, axis, index+1));

function pythagoras(a,b,h) =
	a == undef ? sqrt(h*h-b*b) : b == undef ? sqrt(h*h-a*a) : sqrt(a*a+b*b);
	
function triangleHeight(a,b,c) =
	let(s=(a+b+c)/2)
	2*sqrt(s*(s-a)*(s-b)*(s-c))/a;