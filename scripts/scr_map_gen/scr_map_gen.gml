global.tile_size = 64;

function draw_chamber(chamber, tile_map, floor_tile_data) {
	for (var tileX = chamber.left; tileX < chamber.right + 1; ++tileX) {
		for (var tileY = chamber.top; tileY < chamber.bottom + 1; ++tileY) {
			tilemap_set(tile_map, floor_tile_data, tileX, tileY);
		}
	}
	
	var instances_layer = layer_get_id("Instances_1");
	
	for (var tileX = chamber.left; tileX < chamber.right + 1; ++tileX) {		
		instance_create_layer(tileX * global.tile_size , chamber.top * global.tile_size ,
			instances_layer, obj_rock_a);
		instance_create_layer(tileX * global.tile_size, chamber.bottom * global.tile_size,
			instances_layer, obj_rock_a);
	}
	
	for (var tileY = chamber.top; tileY < chamber.bottom + 1; ++tileY) {
		instance_create_layer(chamber.left * global.tile_size , tileY * global.tile_size ,
			instances_layer, obj_rock_a);
		instance_create_layer(chamber.right * global.tile_size , tileY * global.tile_size ,
			instances_layer, obj_rock_a);
	}
}

function record_chamber_floor_tiles_positions(floor_tile_positions, chamber) {
	for (var tileX = chamber.left; tileX < chamber.right + 1; ++tileX) {
		for (var tileY = chamber.top; tileY < chamber.bottom + 1; ++tileY) {
			var hash = variable_get_hash(string(tileX) + "," + string(tileY));
			floor_tile_positions.add([tileX, tileY]);
		}
	}	
}

function generate_chamber(anchor_x, anchor_y, direction_x, direction_y) {
	var max_width = 20;
	var min_width = 3;
	var max_height = 20;
	var min_height = 3;
	
	var width = irandom_range(min_width, max_width);
	var height = irandom_range(min_height, max_height);
	
	return {
		left: direction_x > 0 ? anchor_x : anchor_x - width,
		right: direction_x > 0 ? anchor_x + width : anchor_x,
		top: direction_y > 0 ? anchor_y : anchor_y - height,
		bottom: direction_y > 0 ? anchor_y + height : anchor_y,
		width: width,
		height: height
	};
}

function generate_floor(map_width_in_tiles, map_height_in_tiles) {
	// Key: hash of x and y. Value: x and y array.
	var floor_tile_positions = new UniqueArray(); 
	var floor_tile_index = 2
	
	var tiles_layer = layer_get_id("Tiles_1");
	var instances_layer = layer_get_id("Instances_1");
	
	var tile_map = layer_tilemap_get_id(tiles_layer);
	var floor_tile_data = floor_tile_index;
	
	var anchor_x = floor(map_width_in_tiles/2);
	var anchor_y = floor(map_height_in_tiles/2);
	var dir_x = 1;
	var dir_y = 1;
	
	for (var i = 0; i < 10; ++i) {
		// TODO: Pass bounds.
		var chamber = generate_chamber(anchor_x, anchor_y, dir_x, dir_y);
		show_debug_message("Chamber: left {0}, right {1}, top {2}, bottom {3}",
		chamber.left, chamber.right, chamber.top, chamber.bottom);
		
		record_chamber_floor_tiles_positions(floor_tile_positions, chamber);
		draw_chamber(chamber, tile_map, floor_tile_data);
		
		var next_dir = choose([1, 0], [0, 1], [-1, 0], [0, -1]);
		dir_x = next_dir[0];
		dir_y = next_dir[1];
		if (chamber.left < 0 && dir_x < 0) {
			dir_x = 1;
		}
		if (chamber.top < 0 && dir_y < 0) {
			dir_y = 1;
		}
			
		
		if (dir_x != 0) {
			anchor_x = dir_x > 0 ? chamber.right : chamber.left;
			anchor_y = irandom_range(chamber.top, chamber.bottom);
		} else {
			anchor_x = irandom_range(chamber.left, chamber.right);
			anchor_y = dir_y > 0 ? chamber.bottom : chamber.top;
		}
	}
	
	show_debug_message("positions: {0}", floor_tile_positions);
	return floor_tile_positions;
}

function scr_map_gen(map_width_in_tiles, map_height_in_tiles) {
	var floor_tile_positions = generate_floor(map_width_in_tiles, map_height_in_tiles);
	var floor_tile_count = array_length(floor_tile_positions.array);
	
	var instances_layer = layer_get_id("Instances_1");
	var tiles_layer = layer_get_id("Tiles_1");
	
	// TODO: Track taken positions.
	var player_pos = floor_tile_positions.array[irandom(floor_tile_count - 1)];
	var garbage_pos = floor_tile_positions.array[irandom(floor_tile_count - 1)];
		
	instance_create_layer(player_pos[0] * global.tile_size , player_pos[1] * global.tile_size, instances_layer, obj_player);
	instance_create_layer(garbage_pos[0] * global.tile_size, garbage_pos[1] * global.tile_size, instances_layer, obj_garbage);
}
