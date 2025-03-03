scr_bring_attached_things(self);

if (array_length(wants) > 0) {
	self.speaker.next_speech = "Hey, I want " + wants[0] + ".";
} else {
	self.speaker.next_speech = "I have no desires. Ahh.";
}
if (!self.path) {
	self.path = path_add();
	path_set_closed(self.path, false);
	path_add_point(self.path, 0, 0, 100);
	var dir = self.possible_directions[irandom_range(0, array_length(self.possible_directions) - 1)];
	path_add_point(self.path, dir[0] * 25, dir[1] * 25, 50);
	path_start(self.path, 4, path_action_stop, false);
	//show_debug_message("Started path {0}", self.path);
}
// TODO: What if it gets stopped while following the path?
