self.top_wall = instance_create_layer(self.x, self.y, self.layer, obj_box_top_wall);
self.bottom_wall = instance_create_layer(self.x, self.y, self.layer, obj_box_bottom_wall);
self.left_wall = instance_create_layer(self.x, self.y, self.layer, obj_box_left_wall);
self.right_wall = instance_create_layer(self.x, self.y, self.layer, obj_box_right_wall);

thing_init(self);

self.attached_things = [];
attach_thing(self, self.top_wall);
attach_thing(self, self.bottom_wall);
attach_thing(self, self.left_wall);
attach_thing(self, self.right_wall);

global.drift_dist = 48;

self.set_image_yscale = function(scale) {
	self.image_yscale = scale;
	self.bottom_wall.y += self.sprite_height - self.bottom_wall.sprite_height;
	
	self.left_wall.image_yscale = scale;
	self.right_wall.image_yscale = scale;
}

self.set_image_xscale = function(scale) {
	self.image_xscale = scale;
	self.right_wall.x += self.sprite_width - self.right_wall.sprite_width;
	
	self.top_wall.image_xscale = scale;
	self.bottom_wall.image_xscale = scale;
}

self.open = function() {
	show_debug_message("Box opening!");
	// TODO: Which wall are we opening?
	detach_thing(self, self.right_wall);
	detach_thing(self, self.left_wall);
	detach_thing(self, self.top_wall);
	detach_thing(self, self.bottom_wall);
	
	self.right_wall.drift.start(
		0.2, 
		0.0,
		global.drift_dist,
		0
	);
	self.left_wall.drift.start(
		-0.2,
		0.0,
		-global.drift_dist,
		0
	);
	self.top_wall.drift.start(
		0.0,
		-0.2,
		0,
		-global.drift_dist,
	);
	self.bottom_wall.drift.start(
		0.0,
		0.2,
		0,
		global.drift_dist
	);
	instance_destroy(self);
}

self.put_inside = function(thing) {
	attach_thing(self, thing);
}