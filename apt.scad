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
z_hall_w_ceiling = z_lr_e_wall - z_hall_slab;
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
z_door_exter_ext = 80;
x_y_door_int_ext = 32;
x_y_door_exter_ext = 36;

// key lines
y_main_house_max = y_lr_hall_min;
x_main_house_min = x_y_exter_wall + x_lr_ext;
x_main_house_int_min = x_y_exter_wall + x_lr_ext + x_y_exter_wall;
y_apt_int_max = y_lr_n_wall_min;
y_apt_max = y_lr_n_exter_wall_max;
x_apt_int_max = x_main_house_min + x_y_exter_wall + x_br_ba_ext;
x_apt_max = x_apt_int_max + x_y_exter_wall;
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

module entry_n_wall() {
  // wall
  rotate([90,0,0])
  translate([0, 0, -x_y_exter_wall])
  linear_extrude(height = x_y_exter_wall)
    polygon([
        [0, 0],
        [x_hall, 0], 
        [x_hall, z_hall_e_ceiling],
        [0, z_hall_w_ceiling]
    ]);
}

module entry_n_wall_with_door() {
  x_start = x_main_house_int_min;
  y_start = y_lr_hall_entry_wall_min + 3;
  x_entry_door_offset = 8;

  translate([x_start, y_start, z_hall_level])
    difference() {
      // wall
      entry_n_wall();
      // door
      // -1 and +2 y offsets needed to ensure complete difference taken from rotated wall
      translate([x_entry_door_offset, -1, 0])
        // door without "transom" wall above it (for creating 2d floor plans)
        cube([x_y_door_exter_ext, x_y_exter_wall + 2, z_hall_w_ceiling]);
      //cube([x_y_door_exter_ext, x_y_exter_wall, z_hall_w_ceiling]);
      //cube([x_y_door_exter_ext, x_y_exter_wall + 2, z_door_exter_ext]);
    }
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
        // door without "transom" wall above it (for creating 2d floor plans)
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
        // door without "transom" wall above it (for creating 2d floor plans)
        cube([x_y_inter_wall + 2, x_y_door_int_ext, z_br_ba_wall_ext + 1]);
        // door with "transom" wall above it (full 3d view)
        // cube([x_y_inter_wall + 2, x_y_door_int_ext, z_door_int_ext]);
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
        // door without "transom" wall above it (for creating 2d floor plans)
        cube([x_y_door_int_ext, x_y_exter_wall + 2, z_base_to_br_ba_ceil]);
        // door with transom wall above it
        // cube([x_y_door_int_ext, x_y_exter_wall + 2, z_door_int_ext]);

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

crawlspace_drain_length = 40;
module crawlspace_drain_line() {
  pipe_diam = 4;
  insul = 2;
  x_offset = -(17 + insul + pipe_diam);
  x_start = x_apt_int_max + x_offset;
  y_start = y_origin;
  pipe_length = crawlspace_drain_length;
  z_start_min = 11.625;
  z_start_max = 13;
  z_change = z_start_max - z_start_min;
  angular_slope = atan(z_change / pipe_length);
  translate([x_start, y_start, z_start_min])
    rotate([-(90 - angular_slope), 0, 0])
      cylinder(h=pipe_length, r=pipe_diam/2, $fn=10);

  translate([x_start + 4, y_start + pipe_length, z_origin + 6])
    rotate([90, 0, 0])
    text(str("] ", z_start_max, "\""), size=4);

}
    
module apt_kitchen_drain_line() {
  pipe_diam = 3;
  rough_pipe_ext = 5;
  pipe_length = 208;
  x_start = x_main_house_min - rough_pipe_ext;
  y_start = y_origin + crawlspace_drain_length;
  z_start_min = 13;
  z_start_max = 18;
  z_change = z_start_max - z_start_min;
  angular_slope = atan(z_change / pipe_length);
  translate([x_start, y_start, z_start_max])
    rotate([0, (90 + angular_slope), 0])
      cylinder(h=pipe_length, r=pipe_diam/2, $fn=10);

  translate([x_start - 25, y_start, z_origin + 7])
    rotate([90, 0, 0])
    text(str(z_start_max, "\" ["), size=9);

  translate([x_start + (pipe_length / 2) - 30, y_start, z_origin + z_start_max + 3])
    rotate([90, 0, 0])
    text(str("<- ", pipe_length, "\" ->"), size=9);
}

module kitchen_components() {
  z_cabinet = 30;
  x_y_cabinet_depth = 24;
  x_y_washer_dryer = 25;
  z_refrigerator = 66;

  x_start = x_main_house_min - x_y_cabinet_depth;
  y_start = x_y_exter_wall;
  spacing = 0.1;

  color([0.9, 0.9, 0.9, 0.3]) {
    translate([x_start, y_start + spacing, z_slab_ext])
      cube([x_y_cabinet_depth, 24, z_cabinet]);
    // sink
    translate([x_start, y_start + 24 + 2*spacing, z_slab_ext]) {
      cube([x_y_cabinet_depth, 30, z_cabinet]);
    }
    // dishwasher
    translate([x_start, y_start + 54 + 3*spacing, z_slab_ext])
      cube([x_y_cabinet_depth, 24, z_cabinet]);
    // cabinets
    translate([x_start, y_start + 78 + 4*spacing, z_slab_ext])
      cube([x_y_cabinet_depth, 30, z_cabinet]);
    // fridge
    translate([x_start, y_start + 108 + 5*spacing, z_slab_ext])
      cube([x_y_cabinet_depth, 24, z_refrigerator]);
    z_washer = 33.5;
    z_dryer= 37;
    //washer
    translate([x_start, y_start + 132 + 6*spacing, z_slab_ext]) 
      cube([x_y_washer_dryer, x_y_washer_dryer, z_washer]);
    translate([x_start, y_start + 132 + 6*spacing, z_slab_ext + z_washer + spacing]) 
      cube([x_y_washer_dryer, x_y_washer_dryer, z_dryer]);
  }

  // labels
  color([0.95, 0.95, 0.95, 0.95]) {
    // sink
    translate([x_start, y_start + 45, z_slab_ext + 5])
    rotate([90, 0, -90])
      text("sink", size=4);
    translate([x_start, y_start + 70, z_slab_ext + 5])
    rotate([90, 0, -90])
      text("d/w", size=4);
    translate([x_start, y_start + 150, z_slab_ext + 5])
    rotate([90, 0, -90])
      text("w/d", size=4);
   }

}

module apt() { 
  // scale([25.4, 25.4, 25.4]) {
  color([0.3, 0.3, 0.3, 0.6]) {
    slab();
    hall_slab();
  }

  color([0.7, 0.7, 0.7, 0.9]) {
    lr_s_wall();
    lr_n_wall();
    lr_w_wall();
  }

  color([0.7, 0.7, 0.7, 0.9]) {
    lr_hall_sep_entry_wall();
    lr_hall_sep_wall();
    lr_hall_stairs();
    hall_stairs();
    hall_e_wall();
  }

  color([0.5, 0.5, 0.5, 0.6])
    br_ba_floor();

  //projection(cut = true)
  // translate([0, 0, -(z_slab_ext+40)])
  color([0.7, 0.7, 0.7, 0.9]) {
    br_ba_s_wall();
    br_e_wall();
    br_ba_e_wall();
    br_ba_n_wall();
    ba_s_wall();
    entry_n_wall_with_door();
  }

  /*
     color([0.8, 0, 0, 0.5])
     crawlspace_drain_line();
     color([0.0, 0.6, 0, 0.7])
     apt_kitchen_drain_line();
   */

  kitchen_components();

}

apt();

/* 
 * Playing around with projected views
 * Below is of kitchen from the west
difference() {
projection(cut = true)
translate([0, 0, x_main_house_min + x_y_exter_wall])
rotate([0, 90, 0])
apt();

projection(cut = true)
translate([0, 0, x_main_house_min - x_y_exter_wall])
rotate([0, 90, 0])
apt();
}
*/



// projection(cut = true)
// translate([0, 0, -(z_slab_ext+30)])
// apt();
// }
