move_rate = 4
spr_index = spr_hompoo_down

self.bag = []
self.wants_types = ["word"];
self.pushable = true;
self.listener = instance_create_layer(self.x, self.y, self.layer, obj_listener);
self.listener.receiver = function(speech) {
	//show_debug_message("Link heard:" + speech);
}

self.speaker = instance_create_layer(self.x, self.y, self.layer, obj_speaker);
array_push(self.speaker.listeners_to_ignore, self.listener);

self.attached_things = [self.listener, self.speaker];
