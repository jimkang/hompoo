//draw_sprite(spr_box_red, -1, x, y);
// Use draw_sprite_stretched to take into account changes to the sprite via
// assignment to self.image_xscale.
draw_sprite_stretched(spr_box_red, -1, x, y,
	spr_box_red.sprite_width, spr_box_red.sprite_height
);