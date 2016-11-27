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
	
function lineSlope(p, q) =
	// m = (y0 - y1) / (x0 - x2)
	p[0] == q[0] ? undef : (p[1] - q[1]) / (p[0] - q[0]);

function pointsToLine(p, q) =
	let(A = q[1] - p[1],
		B = p[0] - q[0],
		C = A*p[0] + B*p[1])
	[A, B, C];	

function angleToLine(p, angle, length) =
	let(q = [p[0]+cos(angle)*length, p[1]+sin(angle)*length])
	pointsToLine(p, q);

function lineIntersection(A, B) =
	let(det = A[0]*B[1] - B[0]*A[1],
		x = (B[1]*A[2] - A[1]*B[2])/det,
		y = (A[0]*B[2] - B[0]*A[2])/det)
	det == 0 ? undef : [x, y];

function tail(arr) =
	len(arr) <= 1
	? []
	: [for (n = [1 : len(arr) - 1]) arr[n]];

function head(arr) =
	len(arr) <= 1
	? []
	: [for (n = [0 : len(arr) - 2]) arr[n]];

function sum(arr) =
	len(arr) == 1
	? arr[0]
	: arr[0] + sum(tail(arr));

function matrixDeterminant(matrix) =
	let(R = len(matrix),
		C = len(matrix[0]))
	  C != R
	? undef
	: C == 1
	? matrix[0][0]
	: C == 2
	? (matrix[0][0] * matrix[1][1]) - (matrix[0][1] * matrix[1][0])
	: let(sub = [ for(c1 = [0 : C-1]) [for (r = [1 : R-1]) [for (c2 = [0 : C-1]) if (c2 != c1) matrix[r][c2] ]]])
	  sum([for (c = [0 : len(matrix) - 1]) matrix[0][c] * (c % 2 == 0 ? matrixDeterminant(sub[c]) : -matrixDeterminant(sub[c]))]);
	 
// y = a x1 + b x2 + c x3 + d x4
//[[y1, x11, x12, ..., x1n],
// [y2, x21, x22, ..., x2n],
//  ...
// [yn, xn1, xn2, ..., xnn]
//]
function cramer2(points) =
	let(D = matrixDeterminant(
			[for (r = [0 : len(points)-1])
				tail(points[r])
			]),
		Dx = [for (c1 = [1 : len(points[0])-1])
				matrixDeterminant(
					[for (r = [0 : len(points)-1])
						[for (c2 = [1: len(points[r])-1]) 
							(c1 == c2) ? points[r][0] : points[r][c2] ]]
				)]
	)
	[for (n = [0 : len(Dx)-1]) Dx[n]/D];
	
// a X^2 + b x + c = 0
// [a,b,c]
function quadratic(formula)	=
	let(a = formula[0],
		b = formula[1],
		c = formula[2],
		D = b*b - 4*a*c,
		x0 = (-b + sqrt(D)) / (2*a),
		y0 = a*x0*x0 + b*x0 + c,
		x1 = (-b - sqrt(D)) / (2*a),
		y1 = a*x1*x1 + b*x1 + c
	) a == 0
	? undef
	: [[x0,y0],[x1,y1]];


function pointBetween(P, Q) =
	[(P[0]+Q[0])/2, (P[1]+Q[1])/2];

function perpendicular(line, point) =
	let(D = -line[1]*point[0] + line[0]*point[1])
	[-line[1], line[0], D];

// PQ is in between P and Q
function circleFromPoints(P, PQ, Q)	=
	let(lPPQ = pointsToLine(P, PQ),
		lQPQ = pointsToLine(Q, PQ),
		cPPQ = pointBetween(P, PQ),
		cQPQ = pointBetween(Q, PQ),
		lineA = perpendicular(lPPQ, cPPQ),
		lineB = perpendicular(lQPQ, cQPQ),
		center = lineIntersection(lineA, lineB),
		r = lineLength(center, PQ)
	) center == undef
	? undef
	: [center, r];

function rotatePoint(line, point, angle) =
	let(lineP = perpendicular(line, point),
		pointC = lineIntersection(line, lineP),
		pointAtO = [point[0] - pointC[0], point[1] - pointC[1]],
		pointRotAtO = [pointAtO[0] * cos(angle) - pointAtO[1] * sin(angle), pointAtO[0] * sin(angle) + pointAtO[1] * cos(angle)],
		pointRot = [pointRotAtO[0] + pointC[0], pointRotAtO[1] + pointC[1]]
	) pointRot;

function reflection(line, point) =
	rotatePoint(line, point, 180);

function lineXRotation(P, Q) =
	let(dX = Q[0] - P[0],
		dY = Q[1] - P[1]
	) dX == 0 
	? 0 
	: atan(dY / dX);

function lineToVector(P, Q) =
	let(dX = P[0] - Q[0],
		dY = P[1] - Q[1]
	) [dX, dY];
	
function scaleVector(v, s)  =
	let(dX = v[0] * s,
		dY = v[1] * s
	) [dX, dY];
	
function unitVector(v) =
	let(s = 1 / pythagoras(a = v[0], b = v[1])
	) scaleVector(v, s);

function resizeVector(v, s) =
	scaleVector(unitVector(v), s);
