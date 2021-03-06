(*
 * A Label with a contrasting outline
 *
 * Copyright (C) 2013 Piotr Esden-Tempski <piotr@esden.net>
 *
 * This file is part of paparazzi.
 *
 * paparazzi is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * paparazzi is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with paparazzi; see the file COPYING.  If not, write to
 * the Free Software Foundation, 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 *)

type icon = {
  lines : float array list;
  ellipse : float array list;
  width: int
}

let icon_fixedwing_template = {
  lines = [
    [|  0.; -6.;  0.; 14.|];
    [| -9.;  0.;  9.;  0.|];
    [| -4.; 10.;  4.; 10.|]
  ];
  ellipse = [];
  width = 4
}

let icon_rotorcraft_template = {
  lines = [
    [|  0.; -8.;  0.; 8.|];
    [| -8.;  0.;  8.; 0.|];
    [| 6.; -15.; 0.; -24.;  -6.; -15.|];
  ];
  ellipse = [
    [| 8.; -5.; 18.; 5.|];
    [| -8.; -5.; -18.; 5.|];
    [| -5.; 8.; 5.; 18.|];
    [| -5.; -8.; 5.; -18.|];
  ];
  width = 2
}

let icon_home_template = {
  lines = [
    [| -9.; -9.; -9.; 9.; 9.; 9.; 9.; -9.|];
    [| -12.; -7.; 0.; -15.; 12.; -7.|];
  ];
  ellipse = [];
  width = 3;
}

class widget = fun ?(color="red") ?(icon_template=icon_fixedwing_template) (group:GnoCanvas.group) ->
  let new_line width color points =
    GnoCanvas.line ~fill_color:color ~props:[`WIDTH_PIXELS width; `CAP_STYLE `ROUND] ~points:points group in
  let new_ellipse width color points =
    GnoCanvas.ellipse ~props:[`OUTLINE_COLOR color; `WIDTH_PIXELS width] ~x1:points.(0) ~y1:points.(1) ~x2:points.(2) ~y2:points.(3) group in
  let icon_bg =
    (List.map (fun points -> new_line (icon_template.width+2) "black" points) icon_template.lines,
    List.map (fun points -> new_ellipse (icon_template.width+2) "black" points) icon_template.ellipse) in
  let icon =
    (List.map (fun points -> new_line icon_template.width color points) icon_template.lines,
    List.map (fun points -> new_ellipse icon_template.width color points) icon_template.ellipse) in
object(self)
  method set_color color =
    List.iter2 (fun segment ellipse -> segment#set [`FILL_COLOR color]; ellipse#set [`FILL_COLOR color]) (fst icon) (snd icon)
  method set_bg_color color =
    List.iter2 (fun segment ellipse -> segment#set [`FILL_COLOR color]; ellipse#set [`FILL_COLOR color]) (fst icon_bg) (snd icon_bg)
end

