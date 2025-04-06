function draw_vertical_wall(wall_obj) {
	var non_stretchable_part_height = 8;

	var spr = object_get_sprite(wall_obj.object_index);
	
	var src_height = sprite_get_height(spr) - 2 * non_stretchable_part_height;
	var desired_height = wall_obj.sprite_height - 2 * non_stretchable_part_height;
	var y_scale = desired_height/src_height;
	//show_debug_message("src_height {0}, desired_height {1}, y_scale {2}",
	//	src_height, desired_height, y_scale);

	draw_sprite_part_ext(spr,
		-1,

		// Source from image to draw.
		0,	
		non_stretchable_part_height,
		sprite_get_width(spr),
		src_height,
	
		// Where to draw and at what scale.
		x,
		y + non_stretchable_part_height,
		wall_obj.image_xscale,
		y_scale,

		c_white,
		1
	);
	
	// TODO: Draw corners.
}

function draw_horizontal_wall(wall_obj) {
	var non_stretchable_part_width = 8;
	
	var spr = object_get_sprite(wall_obj.object_index);

	var src_width = sprite_get_width(spr) - 2 * non_stretchable_part_width;	
	// sprite_width already has the scale applied to it.
	var desired_width = wall_obj.sprite_width - 2 * non_stretchable_part_width;
	var x_scale = desired_width/src_width;
	//show_debug_message("src_width {0}, desired_width {1}, y_scale {2}",
	//	src_width, desired_width, y_scale);

	draw_sprite_part_ext(spr,
		-1,

		// Source from image to draw. Non-stretched.
		non_stretchable_part_width,
		0,
		src_width,
		sprite_get_height(spr),
	
		// Where to draw and at what scale.
		x + non_stretchable_part_width,
		y,
		x_scale,
		wall_obj.image_yscale,

		c_white,
		1
	);
}