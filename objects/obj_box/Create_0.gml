self.top_wall = instance_create_layer(self.x, self.y, self.layer, obj_box_top_wall);
self.bottom_wall = instance_create_layer(self.x, self.y, self.layer, obj_box_bottom_wall);

self.attached_things = [self.top_wall, self.bottom_wall];

self.set_image_xscale = function (scale) {
	self.image_xscale = scale;
	self.top_wall.image_xscale = scale;
	self.bottom_wall.image_xscale = scale;
}

self.set_image_yscale = function (scale) {
	self.image_yscale = scale;
	self.bottom_wall.y += self.sprite_height - self.bottom_wall.sprite_height;
}