self.top_wall = instance_create_layer(self.x, self.y, self.layer, obj_box_top_wall);

self.attached_things = [self.top_wall];

self.set_image_xscale = function (scale) {
	self.image_xscale = scale;
	self.top_wall.image_xscale = scale;
}