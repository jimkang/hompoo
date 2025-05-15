function scr_bumps(bumper) {
	// If there is no one at the previous x and y, move there via instance_place.
	// If there is, move back to the previous position.

	// Look for collision with instances of obj_collision_parent.
	var colliding_inst = instance_place(bumper.x, bumper.y, [obj_collision_parent]);
	if (colliding_inst) {
		if (struct_exists(colliding_inst, "is_attachment") && colliding_inst.is_attachment) {
			// Collide with the parent of the attachment instead of the attachment.
			if (weak_ref_alive(colliding_inst.attached_to)) {
				//show_debug_message("Collided with attachment {0}", colliding_inst);
				colliding_inst = colliding_inst.attached_to.ref;
			}
		}
		
		if (colliding_inst.is_item) {
			//show_debug_message("It is an item!");
			// TODO: If items ever have attachments, this needs to work on colliding_inst.attached_things.
			if (item_take(bumper, colliding_inst)) {				
				return;
			}
		}
		
		if (colliding_inst.pushable) {
			//show_debug_message("Pushing {0}", object_get_name(colliding_inst.object_index));
			colliding_inst.x += (bumper.x - bumper.xprevious);
			colliding_inst.y += (bumper.y - bumper.yprevious);
			return;
		}
		
		bumper.x = bumper.xprevious;
		bumper.y = bumper.yprevious;
	}
}