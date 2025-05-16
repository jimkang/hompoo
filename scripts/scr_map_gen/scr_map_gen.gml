global.tile_size = 64;
global.max_chamber_width = 20;
global.min_chamber_width = 3;
global.max_chamber_height = 20;
global.min_chamber_height = 3;
global.cardinal_dirs = [[1, 0], [0, 1], [-1, 0], [0, -1]];
global.cardinal_dirs_by_name = {
  "right": [1, 0],
  "down": [0, 1],
  "left": [-1, 0],
  "up": [0, -1]
};
global.opposite_wall_map = {
  "left": "right",
  "right": "left",
  "top": "bottom",
  "bottom": "top"
};
global.dir_to_wall_name_map = {
  "left": "left",
  "right": "right",
  "down": "bottom",
  "up": "top"
};
global.wall_names = struct_get_names(global.opposite_wall_map);

function array_remove(array, value) {
  var index = array_get_index(array, value);
  if (index == -1) {
    return;
  }
  array_delete(array, index, 1);
}

function array_choose(array) {
  var len = array_length(array);
  if (len < 1) {
    return;
  }
  return array[irandom(len - 1)];
}

function is_in_gap(gap, n) {
	if (!gap) {
		return false;
	}
	return n >= gap.start && n < gap.stop;
}

function draw_chamber(chamber, tile_map, floor_tile_data, anti_wall_list) {
	for (var tileX = chamber.left; tileX < chamber.right + 1; ++tileX) {
		for (var tileY = chamber.top; tileY < chamber.bottom + 1; ++tileY) {
			tilemap_set(tile_map, floor_tile_data, tileX, tileY);
		}
	}

	var instances_layer = layer_get_id("Instances_1");

	for (var tileX = chamber.left; tileX <= chamber.right; ++tileX) {
		// Top wall
		if (!anti_wall_list.has([tileX, chamber.top])) {
			instance_create_layer(tileX * global.tile_size , chamber.top * global.tile_size ,
				instances_layer, obj_rock_a);
		} else {
			show_debug_message($"Leaving {[tileX, chamber.top]} alone.");
		}
		// Bottom wall
		if (!anti_wall_list.has([tileX, chamber.bottom])) {
			instance_create_layer(tileX * global.tile_size, chamber.bottom * global.tile_size,
				instances_layer, obj_rock_a);
		} else {
			show_debug_message($"Leaving {[tileX, chamber.bottom]} alone.");
		}
	}

	for (var tileY = chamber.top; tileY <= chamber.bottom; ++tileY) {
		// Left wall
		if (!anti_wall_list.has([chamber.left, tileY])) {
			instance_create_layer(chamber.left * global.tile_size , tileY * global.tile_size ,
				instances_layer, obj_rock_a);
		} else {
			show_debug_message($"Leaving {[chamber.left, tileY]} alone.");
		}
		// Right wall
		if (!anti_wall_list.has([chamber.right, tileY])) {
			instance_create_layer(chamber.right * global.tile_size , tileY * global.tile_size ,
				instances_layer, obj_rock_a);
		} else {
			show_debug_message($"Leaving {[chamber.right, tileY]} alone.");
		}
	}
}

function record_chamber_floor_tiles_positions(floor_tile_positions, chamber) {
	// TODO: Account for gaps and walls.
	for (var tileX = chamber.left + 1; tileX < chamber.right + 1 - 1; ++tileX) {
		for (var tileY = chamber.top + 1; tileY < chamber.bottom + 1 - 1; ++tileY) {
			var hash = variable_get_hash(string(tileX) + "," + string(tileY));
			floor_tile_positions.add([tileX, tileY]);
		}
	}
}

function chamber_collides_with_tiles(floor_tile_positions, chamber) {
	for (var tileX = chamber.left; tileX <= chamber.right; ++tileX) {
		for (var tileY = chamber.top; tileY <= chamber.bottom; ++tileY) {
			if (floor_tile_positions.has([tileX, tileY])) {
				return true;
			}
		}
	}
	return false;
}

// Gap positions need to be in absolute tile positions, not relative to the
// chamber. This way, they can be transferred between chambers.
function create_gap(wall, chamber) {
	var gap = {
		length: choose(1, 1, 1, 2)
	};

	switch (wall) {
		case "left":
		case "right": {
			gap.start = chamber.top + 1;//+ irandom(chamber.bottom - chamber.top - 1);
			break;
		}
		case "top":
		case "bottom": {
			gap.start = chamber.left + 1;//irandom(chamber.right - chamber.left - 1);
			break;
		}
	}
	// stop is not inclusive.
	gap.stop = gap.start + gap.length;
	return gap;
}

function add_gaps_to_chamber(chamber, anchor_pack) {
	var gap_count = choose(1, 1, 1, 1, 2, 2, 2, 3, 3, 4);
	var walls = [];
	array_copy(walls, 0, array_shuffle(global.wall_names),
		0, gap_count);
	
	// Make sure there is a gap at the anchor.
	array_push(chamber.anti_walls, [anchor_pack.anchor_x, anchor_pack.anchor_y]);
	if (chamber.growth_direction[0] != 0) {
		// To the left of the anchor.
		if (irandom(1) == 0) {
			array_push(chamber.anti_walls, [anchor_pack.anchor_x - 1, anchor_pack.anchor_y]);
		}
		// To the right of the anchor.
		if (irandom(1) == 0) {
			array_push(chamber.anti_walls, [anchor_pack.anchor_x + 1, anchor_pack.anchor_y]);
		}
	} else if (chamber.growth_direction[1] != 0) {
		// To the top of the anchor.
		if (irandom(1) == 0) {
			array_push(chamber.anti_walls, [anchor_pack.anchor_x, anchor_pack.anchor_y - 1]);
		}
		// To the bottom of the anchor.
		if (irandom(1) == 0) {
			array_push(chamber.anti_walls, [anchor_pack.anchor_x, anchor_pack.anchor_y + 1]);
		}
	}

	for (var i = 0; i < gap_count; ++i) {
		var wall = walls[i];
		if (wall == anchor_pack.anchor_wall_name) {
			// Already add gaps for this wall.
			continue;
		}
		
		var gap = create_gap(wall, chamber);
		switch (wall) {
			case "left": {
				for (var tileY = gap.start; tileY < gap.stop; ++tileY) {
					show_debug_message($"<!--Adding anti-wall at {[chamber.left, tileY]} for chamber {chamber.left}, {chamber.top}.-->");
					array_push(chamber.anti_walls, [chamber.left, tileY]);
				}
				break;
			}
			case "right": {
				for (var tileY = gap.start; tileY < gap.stop; ++tileY) {
					show_debug_message($"<!--Adding anti-wall at {[chamber.right, tileY]} for chamber {chamber.left}, {chamber.top}.-->");
					array_push(chamber.anti_walls, [chamber.right, tileY]);
				}
				break;
			}
			case "top": {
				for (var tileX = gap.start; tileX < gap.stop; ++tileX) {
					show_debug_message($"<!--Adding anti-wall at {[tileX, chamber.top]} for chamber {chamber.left}, {chamber.top}.-->");
					array_push(chamber.anti_walls, [tileX, chamber.top]);
				}
				break;
			}
			case "bottom": {
				for (var tileX = gap.start; tileX < gap.stop; ++tileX) {
					show_debug_message($"<!--Adding anti-wall at {[tileX, chamber.bottom]} for chamber {chamber.left}, {chamber.top}.-->");
					array_push(chamber.anti_walls, [tileX, chamber.bottom]);
				}
				break;
			}
		}
	}
}

function generate_chamber(direction_x, direction_y,
	map_width_in_tiles, map_height_in_tiles, anchor_pack, anti_wall_list) {

	var width = irandom_range(global.min_chamber_width, global.max_chamber_width);
	var height = irandom_range(global.min_chamber_height, global.max_chamber_height);

	// These are outer width and height. They do include the walls.
	var chamber = {
		width: width,
		height: height,
		growth_direction: [direction_x, direction_y],
		anti_walls: []
	};

	if (direction_x > 0) {
		chamber.left = anchor_pack.anchor_x;
		chamber.right = chamber.left + width;
	} else if (direction_x < 0) {
		chamber.right = anchor_pack.anchor_x;
		chamber.left = chamber.right - width;
	} else {
		var center_of_anchor_wall = anchor_pack.anchor_x - round(width/2);
		chamber.left = center_of_anchor_wall;	
		chamber.right = chamber.left + width;
	}

	if (direction_y > 0) {
		chamber.top = anchor_pack.anchor_y;
		chamber.bottom = chamber.top + height;
	} else if (direction_y < 0) {
		chamber.bottom = anchor_pack.anchor_y;
		chamber.top = chamber.bottom - height;
	} else {
		var center_of_anchor_wall = anchor_pack.anchor_y - round(height/2);
		chamber.top = center_of_anchor_wall;
		chamber.bottom = chamber.top + height;
	}

	if (chamber.left < 0) {
		chamber.left = 0;
	}
	if (chamber.top < 0) {
		chamber.top = 0;
	}
	if (chamber.right > map_width_in_tiles) {
		chamber.right = map_width_in_tiles - 1;
	}
	if (chamber.bottom > map_height_in_tiles) {
		chamber.bottom = map_height_in_tiles - 1;
	}

	// This can happen when we hit the edge of the map.
	if (chamber.right - chamber.left < global.min_chamber_width) {
		return;
	}
	if (chamber.bottom - chamber.top < global.min_chamber_height) {
		return;
	}

	add_gaps_to_chamber(chamber, anchor_pack);
	return chamber;
}

// neighbor_chamber is the chamber the current chamber is growing out of.
// The anchors we're creating are for the current chamber.
function get_anchors_for_direction(neighbor_chamber, dir_name) {
	var dir = global.cardinal_dirs_by_name[$ dir_name];
	var dir_x = dir[0];
	var dir_y = dir[1];
	
	var anchor_x;
	var anchor_y;
	var anchor_wall_name = global.opposite_wall_map[$ global.dir_to_wall_name_map[$ dir_name]];
	
	if (dir_x != 0) {
		anchor_x = dir_x > 0 ? neighbor_chamber.right : neighbor_chamber.left;
		if (neighbor_chamber.height > 4) {
			anchor_y = irandom_range(neighbor_chamber.top + 2, neighbor_chamber.bottom - 2);
		} else {
			anchor_y = round((neighbor_chamber.bottom - neighbor_chamber.top)/2);
		}
	} else {
		anchor_y = dir_y > 0 ? neighbor_chamber.bottom : neighbor_chamber.top;
		if (neighbor_chamber.width > 4) {
			anchor_x = irandom_range(neighbor_chamber.left + 2, neighbor_chamber.right - 2);
		} else {
			anchor_x = round((neighbor_chamber.right - neighbor_chamber.left)/2);
		}
	}
	
	return { anchor_x, anchor_y, anchor_wall_name };
}

function generate_floor(map_width_in_tiles, map_height_in_tiles) {
	var floor_tile_positions = new UniqueArray();
	var floor_tile_index = 2;
	var room_count = 1;
	var anti_wall_list = new UniqueArray();

	var tiles_layer = layer_get_id("Tiles_1");
	var instances_layer = layer_get_id("Instances_1");

	var tile_map = layer_tilemap_get_id(tiles_layer);
	var floor_tile_data = floor_tile_index;

	// These variables are not implicitly undefined. A runtime error happens if
	// they referenced without this explicit assignment
	var dir_x = undefined;
	var dir_y = undefined;

	var chambers = [];
	var anchor_pack = {
		anchor_x: floor(map_width_in_tiles/2),
		anchor_y: floor(map_height_in_tiles/2),
		anchor_wall_name: array_choose(global.wall_names)
	};
	var chamber = undefined;

	for (var i = 0; i < room_count; ++i) {
		var valid_dir_names = array_shuffle(struct_get_names(global.cardinal_dirs_by_name));
		var dir_name = undefined;
		
		// This loop tries to generate a chamber that is valid and does not collide
		// with anything.
		repeat (1000) {
			dir_name = array_shift(valid_dir_names);
			if (dir_name == undefined) {
				break;
			}
			var dir = global.cardinal_dirs_by_name[$ dir_name];
			dir_x = dir[0];
			dir_y = dir[1];

			if (chamber) {
				anchor_pack = get_anchors_for_direction(chamber, dir_name);
			}
		
			var new_chamber = generate_chamber(dir_x, dir_y,
				map_width_in_tiles, map_height_in_tiles,
				anchor_pack, anti_wall_list);

			var chamber_collides = false;

			if (new_chamber == undefined) {
				show_debug_message("<!--Could not make chamber at {0}, {1} going {2}, {3}.-->",
					anchor_pack.anchor_x, anchor_pack.anchor_y, dir_x, dir_y);
				continue;
			}

			if (chamber_collides_with_tiles(floor_tile_positions, new_chamber)) {
				show_debug_message("<!--Chamber collides with existing tiles. {0}-->", new_chamber);
				continue;
			}
			
			if (new_chamber.left < global.max_chamber_width) {
			    array_remove(valid_dir_names, "left");
				continue;
			} else if (new_chamber.right > map_width_in_tiles - global.max_chamber_width) {
			    array_remove(valid_dir_names, "right");
				continue;
			}
			if (new_chamber.top < global.max_chamber_height) {
			    array_remove(valid_dir_names, "top");
				continue;
			} else if (new_chamber.bottom > map_height_in_tiles - global.max_chamber_height) {
			    array_remove(valid_dir_names, "down");
				continue;
			}			
						
			// It is now OK to use this chamber as the basis for the next chamber.
			chamber = new_chamber;

			break;
		}

		if (!chamber) {
			show_debug_message("Somehow we got here with no chamber.");
			continue;
		}
		
		//show_debug_message(
		//	"Chamber created: left {0}, top {1}, width: {2}, height: {3} right {4}, bottom {5}, anchor: {6}, {7}, direction: {8}, {9}",
		//	chamber.left, chamber.top, 
		//	chamber.width, chamber.height,
		//	chamber.right, chamber.bottom,			
		//	anchor_pack.anchor_x, anchor_pack.anchor_y,
		//	dir_x, dir_y
		//);
		show_debug_message(
			$"<g>\n{
			""
	}	<rect x=\"{chamber.left}\" y=\"{chamber.top}\" width=\"{chamber.width}\" height=\"{chamber.height}\" stroke=\"#{array_length(chambers)}00\"></rect>\n{
	""
	}	<text x=\"{chamber.left}\" y=\"{chamber.top}\" dx=\"1\" dy=\"1\">{array_length(chambers)}</text>\n{
	""
	}	<circle r=\"0.5\" cx=\"{anchor_pack.anchor_x}\" cy=\"{anchor_pack.anchor_y}\"></circle>\n{
	""
	}	<text x=\"{chamber.left}\" y=\"{chamber.top}\" dx=\"1\" dy=\"3\">Dir: {dir_x}, {dir_y}</text>\n{
	""
	}</g>"
		);

		record_chamber_floor_tiles_positions(floor_tile_positions, chamber);

		array_push(chambers, chamber);
		// Once we know the chamber is good, we can consider its anti-walls to be good.
		anti_wall_list.append(chamber.anti_walls);
	}

	for (var i = 0; i < array_length(anti_wall_list.array); ++i) {
		var pos = anti_wall_list.array[i];
		show_debug_message($"<rect x=\"{pos[0]}\" y=\"{pos[1]}\" width=\"1\" height=\"1\" class=\"anti-wall\"></rect>");
	}
	
	// If you draw as you go, the anti_wall_list won't be complete.
	// So, draw after all of the chambers are generated.	
	for (var i = 0; i < array_length(chambers); ++i) {
		var chamber_to_draw = chambers[i];
		draw_chamber(chamber_to_draw, tile_map, floor_tile_data, anti_wall_list);
	}
	
	return { chambers: chambers, floor_tile_positions: floor_tile_positions };
}

function scr_map_gen(map_width_in_tiles, map_height_in_tiles) {
	var the_floor = generate_floor(map_width_in_tiles, map_height_in_tiles);
	var floor_tile_count = array_length(the_floor.floor_tile_positions.array);

	var instances_layer = layer_get_id("Instances_1");
	var tiles_layer = layer_get_id("Tiles_1");

	// TODO: Track the taken positions.
	var chamber_count = array_length(the_floor.chambers);
	var taken_positions = new UniqueArray();
	//var objects_to_spawn = [obj_player, obj_garbage, obj_garbage, obj_garbage,
	//	obj_dancer, obj_dancer, obj_food, obj_food, obj_jammer, obj_jammer,
	//	obj_word_yo, obj_word_yo, obj_box, obj_box, obj_box, obj_box, obj_box,
	//	obj_box, obj_box, obj_box, obj_box, obj_box];
	var objects_to_spawn = [obj_player, obj_box, obj_box_left_wall];
	// TODO: Do things chamber by chamber.
	// TODO: Change box dimensions.
	for (var i = 0; i < array_length(objects_to_spawn); ++i) {
		var obj = objects_to_spawn[i];
		var chamber;
		var pos;
		repeat(1000) {
			chamber = the_floor.chambers[irandom(chamber_count - 1)];
			// The edges of the chambers are walls.
			pos = [
				irandom_range(chamber.left + 1, chamber.right - 1),			
				irandom_range(chamber.top + 1, chamber.bottom - 1)
			];
			if (obj == obj_box_left_wall) {
				pos = [70, 60];
			}
			if (!taken_positions.has(pos)) {
				break;
			}
		}
		show_debug_message($"{obj} pos: {pos[0]}, {pos[1]}");
		
		var inst = instance_create_layer(
			pos[0] * global.tile_size,
			pos[1] * global.tile_size,
			instances_layer,
			obj
		);
		
		if (obj == obj_box) {
			inst.set_image_xscale(1.5);
			inst.set_image_yscale(5);
			// TODO: Abstract set up
			var inside_item = instance_create_layer(inst.x, inst.y,
				instances_layer, obj_garbage);
			inst.put_inside(inside_item);
		}
		if (obj == obj_box_left_wall) {
			inst.image_yscale = 5;
		}
		
		taken_positions.add(pos);
	}
}
