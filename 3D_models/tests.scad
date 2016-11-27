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

// This is the tests scad file, used for rendering parts while developing
include <lib.scad>
include <finger.scad>
include <thumb.scad>
include <thumb_pcb.scad>
include <thumb_side.scad>
include <thumb_carrier.scad>

$fn=64;

//finger_assy(lib_fingerPcb, lib_finger_carrier, lib_guard);
//finger_single_assy(lib_finger_carrier,  ["up", "up", "down", "up", "down"]);
thumb_assy(lib_thumb_pcb, lib_thumb_downCarrier, lib_thumb_sideCarrier, "down",	thumb_vector("down", "down", "down", "down"));
//thumb_pcb_fit_part(lib_thumb_pcb, true);