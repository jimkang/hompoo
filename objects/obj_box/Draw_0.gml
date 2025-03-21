// Use draw_sprite_stretched to take into account changes to the sprite via
// assignment to self.image_xscale.
draw_sprite_stretched(spr_box_lid, -1, x, y,
	self.sprite_width, self.sprite_height
);
