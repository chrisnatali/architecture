// Apt Living Room
// units in inches
x_origin = 0;
y_origin = 0;
z_origin = 0;
z_slab_ext = 4;
z_floor_ext = 1;
x_lr_ext = 178.625;
y_lr_ext = 316.3125;
x_y_exter_wall = 12;
x_y_inter_wall = 5;
x_sep_wall = 12;
x_hall = 60.875;
z_lr_e_floor_to_ceil = 147.3125;
z_lr_e_wall = 147.3125;
y_lr_hall_int_min = 141;
y_lr_hall_min = y_lr_hall_int_min + x_y_exter_wall;
z_lr_w_wall = 89;
y_lr_stairs = 72.0625;
y_lr_hall_int_w_entry_wall = 32.4375;
y_lr_hall_w_entry_wall = y_lr_hall_int_w_entry_wall + x_y_exter_wall;
z_lr_floor_to_sep_top = 79.3125;
y_sep_top = 35.25;
z_lr_floor_to_sep_bottom = 56;
z_main_floor_to_sep_top = 35.5625;
y_sep_slope = 35.5625;
y_lr_hall_int_min_plus_hall = y_lr_hall_int_min + y_sep_top + y_sep_slope;
y_lr_hall_entry_wall_min = x_y_exter_wall + y_lr_hall_int_min_plus_hall + y_lr_stairs;
y_lr_n_wall_min = y_lr_ext + x_y_exter_wall;
y_lr_n_exter_wall_max = y_lr_n_wall_min + x_y_exter_wall;
z_hall_slab = 14;
z_hall_e_ceiling = 120;
y_br_ba_min = 13.5;
y_br_ba_base_min = 0;
y_br_ba_ext = 122.75;
y_ba_ext = 55.5;
x_br_ba_ext = 213.8125;
x_br_ext = 150.0625;
z_br_ba_wall_ext = 96;
x_br_door_offset = 32;
x_br_hall_door_offset = 5;
z_door_int_ext = 80;
x_y_door_int_ext = 32;

// key lines
y_main_house_max = y_lr_hall_min;
x_main_house_min = x_y_exter_wall + x_lr_ext;
x_main_house_int_min = x_y_exter_wall + x_lr_ext + x_y_exter_wall;
y_apt_max = y_lr_n_exter_wall_max;
x_apt_max = x_main_house_min + x_y_exter_wall + x_br_ba_ext + x_y_exter_wall;
y_hall = y_apt_max - y_main_house_max;
z_hall_level = z_slab_ext + z_hall_slab;
z_main_level = z_lr_floor_to_sep_top - z_main_floor_to_sep_top; // amount above lowest footing
// this is the z origin to the ceiling of the br ba
z_base_to_br_ba_ceil = z_main_level + z_br_ba_wall_ext;


stair_run = 12;
hall_stair_total_rise = (z_main_level + z_floor_ext) - z_hall_level;

// oriented such that y represents z axis so that it can be extruded for width of walls and rotated 90 along the x 
// to make it upright and positioned
lr_n_s_wall_poly_points = [
  [0, 0],
  [0, z_lr_w_wall], 
  [x_lr_ext, z_lr_e_floor_to_ceil],
  [x_lr_ext, 0]];

module slab() {
  // main slab area under lr
  x_main_slab_ext = x_lr_ext + x_y_exter_wall; //assuming slab only extends under addition exterior walls
  y_main_slab_ext = y_lr_ext + x_y_exter_wall * 2;
  cube([x_main_slab_ext, y_main_slab_ext, z_slab_ext]);
  
  // hall slab area 
  translate([x_main_house_min, y_main_house_max, 0])
    hall_base(z_slab_ext);

  // br/ba slab area
  x_br_start = x_origin + x_lr_ext + x_y_exter_wall;
  y_br_start = y_origin;
  translate([x_br_start, y_br_start, 0]) 
    br_ba_base(z_slab_ext);

}

module hall_base(z_ext) {
  x_hall_ext = x_hall + 2 * x_y_exter_wall;
  y_hall_ext = y_apt_max - y_main_house_max;
  cube([x_hall_ext, y_hall_ext, z_ext]);
}

module hall_slab() {
  translate([x_main_house_min, y_main_house_max, z_slab_ext])
  hall_base(z_hall_slab);
}

 
module lr_hall_sep_wall() {
  // This is a wall along the y axis
  // Create it via polygon in xy plane (using z values in place of x vals), extrude it in 
  // negative z direction to create polyhedron and then rotate -90 deg along x to raise 
  // make it an upright wall.
  x_start = x_origin + x_lr_ext + x_y_exter_wall;
  y_start = y_origin;
  translate([x_start, y_start, z_slab_ext])
    // since we rotated -90 along the y, the wall is shifted by it x length to the negative
    // side of y. We shift it by its x length to place it at the + side of the y axis.
    translate([x_sep_wall, 0, 0])

     // fun animation
     //rotate([0,$t*720,0,0])
     rotate([0,-90,0])
      linear_extrude(height = x_sep_wall)
        polygon([
            [0, 0],
            [z_lr_e_wall, 0], 
            [z_lr_e_wall, y_lr_hall_min],
            [z_lr_floor_to_sep_top, y_lr_hall_min],
            [z_lr_floor_to_sep_top, y_lr_hall_min + y_sep_top],
            [z_lr_floor_to_sep_bottom, y_lr_hall_min + y_sep_top + y_sep_slope],
            [0, y_lr_hall_min + y_sep_top + y_sep_slope]
        ]);

}
  
module lr_hall_sep_entry_wall() {
  // This is a wall along the y axis
  // Create it via polygon in xy plane (using z values in place of x vals), extrude it in 
  // negative z direction to create polyhedron and then rotate -90 deg along x to raise 
  // make it an upright wall.
  x_start = x_origin + x_lr_ext + x_y_exter_wall;
  y_start = y_origin + y_lr_hall_entry_wall_min;
  translate([x_start, y_start, z_slab_ext])
    cube([x_sep_wall, y_lr_hall_w_entry_wall, z_lr_e_wall]);
}

module lr_s_wall() {
  x_start = x_origin + x_y_exter_wall;
  y_start = y_origin;
  translate([x_start, y_start, z_slab_ext])
    // since we rotated -90 along the x, the wall is shifted by it y length to the negative
    // side of x. We shift it by its y length to place it at the + side of the x axis.
    translate([0, x_y_exter_wall, 0])
     //rotate([$t*360,0,0])
     rotate([90,0,0])
      linear_extrude(height = x_y_exter_wall)
        polygon(lr_n_s_wall_poly_points);
}

module lr_n_wall() {
  // same as south wall, shifted up along the y to the n end
  translate([0, y_lr_n_wall_min, 0])
    lr_s_wall();
}

module lr_w_wall() {
  y_lr_exter_wall_ext = y_lr_ext + 2 * x_y_exter_wall;
  translate([0, 0, z_slab_ext])
  cube([x_y_exter_wall, y_lr_exter_wall_ext, z_lr_w_wall]);
}

module lr_hall_stairs() {
  top_stair_run = 5;
  z_bottom_stair = 8;
  z_top_stair = 6;
  y_start = y_main_house_max + y_sep_top + y_sep_slope;
  x_start = x_main_house_min - (stair_run + top_stair_run);
  translate([x_start, y_start, z_slab_ext])
    cube([stair_run, y_lr_stairs, z_bottom_stair]);
  translate([x_start + stair_run, y_start, z_slab_ext])
    cube([top_stair_run, y_lr_stairs, z_bottom_stair + z_top_stair]);
}

module hall_stairs() {
  y_start = y_main_house_max + y_sep_top + y_sep_slope;
  x_start = x_main_house_min + x_y_exter_wall;
  num_stairs = 3;
  stair_rise = hall_stair_total_rise / (num_stairs + 1);
  for(i = [1:1:num_stairs])
    translate([x_start, y_start - (i*stair_run), z_hall_level])
    cube([x_hall, stair_run, stair_rise * i]);
  
  // remaining hall floor
  y_hall_floor_end = y_start - num_stairs*stair_run; 
  y_hall_to_stairs = y_hall_floor_end - y_main_house_max;
  translate([x_start, y_main_house_max, z_hall_level])
    cube([x_hall, y_hall_to_stairs, hall_stair_total_rise]);
}

module hall_e_wall() {
  y_start = y_main_house_max;
  x_start = x_main_house_min + x_y_exter_wall + x_hall;

  translate([x_start, y_start, z_hall_level])
    cube([x_y_exter_wall, y_hall, z_hall_e_ceiling]);
}
  
module br_ba_base(z_ext) {
  x_br_ba_base = x_br_ba_ext + x_y_exter_wall*2;
  // include the space in mudroom that lines up with the exterior of the addition (i.e. 0..y_br_ba_min)
  y_br_ba_base = y_br_ba_base_min + y_br_ba_min + x_y_inter_wall + y_br_ba_ext + x_y_exter_wall;
  cube([x_br_ba_base, y_br_ba_base, z_ext]);
}

module br_ba_floor() {
  x_br_start = x_origin + x_lr_ext + x_y_exter_wall;
  y_br_start = y_origin;
  translate([x_br_start, y_br_start, z_main_level]) 
    br_ba_base(z_floor_ext);
}

module br_ba_s_wall() {
  x_br_start = x_main_house_int_min;
  y_br_start = y_br_ba_min;
  translate([x_br_start, y_br_start, z_main_level]) 
    difference() {
      // wall
      cube([x_br_ext, x_y_inter_wall, z_br_ba_wall_ext]);
      // door
      translate([x_br_door_offset, -1, 0])
        cube([x_y_door_int_ext, x_y_inter_wall + 2, z_door_int_ext]);
    }
}

module br_e_wall() {
  x_start = x_main_house_int_min + x_br_ext;
  y_start = y_br_ba_min;
  y_wall_ext = x_y_inter_wall + y_br_ba_ext;
  y_ba_door_offset = y_wall_ext - 33;
  translate([x_start, y_start, z_main_level]) 
    difference() {
      // wall
      cube([x_y_inter_wall, y_wall_ext, z_br_ba_wall_ext]);
      // door
      translate([-1, y_ba_door_offset, z_origin])
        cube([x_y_inter_wall + 2, x_y_door_int_ext, z_door_int_ext]);
    }
}

module br_ba_e_wall() {
  // wall between main house and garage
  x_start = x_apt_max - x_y_exter_wall;
  y_start = y_origin;
  y_wall_ext = y_lr_hall_min - y_start;
  translate([x_start, y_start, z_origin]) 
    cube([x_y_exter_wall, y_wall_ext, z_base_to_br_ba_ceil]);
}

module br_ba_n_wall() {
  x_start = x_main_house_int_min;
  y_start = y_br_ba_min + x_y_inter_wall + y_br_ba_ext;
  x_wall_ext = x_br_ba_ext;
  // make this wall extend from ground up to ceiling
  translate([x_start, y_start, 0]) 
    difference() {
      // wall
      cube([x_wall_ext, x_y_exter_wall, z_base_to_br_ba_ceil]);
      // door
      translate([x_br_hall_door_offset, -1, z_main_level])
        cube([x_y_door_int_ext, x_y_exter_wall + 2, z_door_int_ext]);

    }
}

module ba_s_wall() {
  x_start = x_main_house_int_min + x_br_ext + x_y_inter_wall;
  y_start = (y_main_house_max - x_y_exter_wall) - (y_ba_ext + x_y_inter_wall);
  x_apt_int_max = x_apt_max - x_y_exter_wall;
  x_wall_ext = x_apt_int_max - x_start;
  translate([x_start, y_start, z_main_level]) 
    cube([x_wall_ext, x_y_inter_wall, z_br_ba_wall_ext]);
}

slab();
hall_slab();
lr_s_wall();
lr_n_wall();
//lr_w_wall();
lr_hall_sep_entry_wall();
lr_hall_sep_wall();
lr_hall_stairs();
hall_stairs();
hall_e_wall();
br_ba_floor();
br_ba_s_wall();
br_e_wall();
br_ba_e_wall();
br_ba_n_wall();
ba_s_wall();