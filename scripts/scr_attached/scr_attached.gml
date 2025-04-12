function scr_bring_attached_things(inst) {
	if (inst.x == inst.xprevious && inst.y == inst.yprevious) {
		//if (object_get_name(inst.object_index) == "obj_box") {
		//	show_debug_message("box same");
		//}
		return;
	}
	
	if (variable_instance_exists(inst, "attached_things")) {
		for (var i = 0; i < array_length(inst.attached_things); i += 1) {
			var thing = inst.attached_things[i];
			//show_debug_message("Moving attachment {0}", object_get_name(thing.object_index));
			var offset_x = thing.xprevious - inst.xprevious;
			var offset_y = thing.yprevious - inst.yprevious;
			thing.x = inst.x + offset_x;
			thing.y = inst.y + offset_y;
		}
	}
}

function attach_thing(inst, thing) {
	thing.is_attachment = true;
	thing.attached_to = weak_ref_create(inst);
	array_push(inst.attached_things, thing);
}

function detach_thing(inst, thing) {
	thing.is_attachment = false;
	thing.attached_to = undefined;
	array_remove(inst.attached_things, thing);
}
