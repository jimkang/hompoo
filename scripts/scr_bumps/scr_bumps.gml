function scr_bumps(bumper) {
	// If there is no one at the previous x and y, move there via instance_place.
	// If there is, move back to the previous position.

	// Look for collision with instances of obj_collision_parent.
	var colliding_inst = instance_place(bumper.x, bumper.y, [obj_collision_parent]);
	if (colliding_inst) {
		if (colliding_inst.is_item) {
			//show_debug_message("It is an item!");
			if (item_take(bumper, colliding_inst)) {
				return;
			}
		}
		
		if (colliding_inst.pushable) {
			show_debug_message("Pushing {0}", object_get_name(colliding_inst.object_index));
			colliding_inst.x += (bumper.x - bumper.xprevious);
			colliding_inst.y += (bumper.y - bumper.yprevious);
		} else {
			bumper.x = bumper.xprevious;
			bumper.y = bumper.yprevious;
		}
	}
}