function scr_bring_attached_things(inst) {
	if (variable_instance_exists(inst, "attached_things")) {
		for (var i = 0; i < array_length(inst.attached_things); i += 1) {
			var thing = inst.attached_things[i];
			thing.x = inst.x;
			thing.y = inst.y;
		}
	}
}