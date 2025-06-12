enum BumpDirective {
	clear,
	blocked,
	hitItem,
	push,
	slip
};

function get_id(inst) {
	return inst.id;
}

function check_bump_at_pos(x1, y1, x2, y2, xDelta, yDelta, bumper, excluded_ids) {
	// Look for collision with instances of obj_collision_parent.
	var col_list = ds_list_create();
	var col_count = collision_rectangle_list(
		x1, y1,
		x2, y2,
		obj_collision_parent,
		false,
		true,
		col_list,
		true
	);
		
	var colliding_inst = undefined;
	array_push(excluded_ids, bumper.id);
	
	if (variable_instance_exists(bumper, "attached_things")) {
		excluded_ids = array_concat(
			excluded_ids, array_map(bumper.attached_things, get_id)
		);
	}
	
	for (var i = 0; i < ds_list_size(col_list); ++i) {
		// Note: Using ids is different from comparing the instances directly.
		if (!array_contains(excluded_ids, col_list[|i].id)) {
			colliding_inst = col_list[|i];
			break;
		}
	}
	
	if (colliding_inst == undefined) {
		return { directive: BumpDirective.clear, bumped: [] };
	}

	ds_list_destroy(col_list);
	
	if (struct_exists(colliding_inst, "is_attachment") && colliding_inst.is_attachment) {
		// Collide with the parent of the attachment instead of the attachment.
		if (weak_ref_alive(colliding_inst.attached_to)) {
			//show_debug_message("Collided with attachment {0}", colliding_inst);
			colliding_inst = colliding_inst.attached_to.ref;
		}
	}
		
	if (colliding_inst.is_item) {
		return { directive: BumpDirective.hitItem, bumped: [colliding_inst] };
	}
		
	if (colliding_inst.pushable) {		
		// What if it's against another collidable?		
		var nextX = colliding_inst.x + xDelta;
		var nextY = colliding_inst.y + yDelta;
		var next_outcome = check_bump_at_pos(
			nextX,
			nextY,
			// sprite_width already has the scale applied to it.
			nextX + colliding_inst.sprite_width,
			nextY + colliding_inst.sprite_height,
			xDelta,
			yDelta,
			colliding_inst,
			excluded_ids
		);

		if (next_outcome.directive == BumpDirective.push) {
			return {
				directive: BumpDirective.push,
				bumped: array_concat([colliding_inst], next_outcome.bumped)
			};
		}
		if (next_outcome.directive != BumpDirective.clear) {
			//show_debug_message("Blocked!");
			return {
				directive: BumpDirective.blocked,
				bumped: array_concat([colliding_inst], next_outcome.bumped)
			};
		}
		
		return { directive: BumpDirective.push, bumped: [colliding_inst] };
	}
	
	if (struct_exists(colliding_inst, "slippable") &&
		colliding_inst.slippable &&
		struct_exists(bumper, "can_slip_by") && bumper.can_slip_by) {

		var slip_tolerance = 8; // TODO get from colliding_inst
		// TODO: Approach should be to see if it is close to a gap. So
		// the idea of a gap needs to be added to a floor tile.
		var hit_obj = collision_rectangle(
			colliding_inst.x + slip_tolerance,
			colliding_inst.y + slip_tolerance,
			colliding_inst.x + colliding_inst.sprite_width - slip_tolerance,
			colliding_inst.y + colliding_inst.sprite_height - slip_tolerance,
			//colliding_inst.x,
			//colliding_inst.y,
			//colliding_inst.x + colliding_inst.sprite_width,
			//colliding_inst.y + colliding_inst.sprite_height,
			bumper,
			true, // Turning on precise collisions is necessary here.
			false
		);
		
		if (hit_obj == noone) {
			show_debug_message(
				"{0} can slip by {1}. Hit rect: {2}, {3}, {4}, {5}\nbumper rect: {6}, {7}, {8}, {9}",
				bumper.id,
				hit_obj,
				colliding_inst.x,
				colliding_inst.y,
				colliding_inst.x + colliding_inst.sprite_width,
				colliding_inst.y + colliding_inst.sprite_height,
				bumper.x,
				bumper.y,
				bumper.sprite_width,
				bumper.sprite_height
			);
			return {
				directive: BumpDirective.slip,
				bumped: [colliding_inst]
			};
		}
	}
			
	return {
		directive: BumpDirective.blocked,
		bumped: [colliding_inst]
	};
}

function scr_bumps(bumper) {
	if (bumper.x == bumper.xprevious && bumper.y == bumper.yprevious) {
		return;
	}

	var bumpOutcome = check_bump_at_pos(
		bumper.x,
		bumper.y,
		bumper.x + bumper.sprite_width,
		bumper.y + bumper.sprite_height,
		bumper.x - bumper.xprevious,
		bumper.y - bumper.yprevious,
		bumper,
		[]
	);

	if (bumpOutcome.directive == BumpDirective.blocked) {
		bumper.x = bumper.xprevious;
		bumper.y = bumper.yprevious;
		// Is the object slippable?
		
	} else if (bumpOutcome.directive == BumpDirective.hitItem) {
		// TODO: If items ever have attachments, this needs to work on
		// colliding_inst.attached_things.
		for (var i = 0; i < array_length(bumpOutcome.bumped); ++i) {
			if (!item_take(bumper, bumpOutcome.bumped[i])) {				
				show_debug_message("Could not take item!");
			}
		}		
	} else if (bumpOutcome.directive == BumpDirective.push) {
		var deltaX = bumper.x - bumper.xprevious;
		var deltaY = bumper.y - bumper.yprevious;
		
		for (var i = 0; i < array_length(bumpOutcome.bumped); ++i) {
			bumpOutcome.bumped[i].x += deltaX;
			bumpOutcome.bumped[i].y += deltaY;
		}
	}
}
