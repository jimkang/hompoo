//event_inherited();
self.wants = ["positive comments"];
// Should contain instance ids
self.bag = [];
path = undefined

self.possible_directions = [
	[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]
];

self.listener = instance_create_layer(self.x, self.y, self.layer, obj_listener);
self.listener.receiver = function(speech) {
	show_debug_message("Tektite heard:" + speech);
}

self.speaker = instance_create_layer(self.x, self.y, self.layer, obj_speaker);
array_push(self.speaker.listeners_to_ignore, self.listener);

self.attached_things = [self.speaker, self.listener];

//path_start(pth_test, 1, path_action_continue, false);