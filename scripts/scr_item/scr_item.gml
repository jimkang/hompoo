enum offscreen {
	x = -100,
	y = -100
};

function item_take(taker, item) {
	if (!struct_exists(taker, "bag")) {
		return false;
	}
	if (!can_take_item(taker, item)) {
		return false;
	}
	item.visible = false;
	//item.x = offscreen.x;
	//item.y = offscreen.y;
	take_item(taker, item);
	return true;
}

function can_take_item(taker, item) {
	// Does it have a bag?
	if (!struct_exists(taker, "bag")) {
		return false;
	}
	
	if (array_contains(taker.bag, item)) {
		//show_debug_message("I already have this item.");
		return false;
	}
	
	// Does it actually want this?	
	if (struct_exists(taker, "wants")) {
		if (array_contains(taker.wants, item.item_name)) {
			return true;
		}
	}
	
	if (struct_exists(taker, "wants_types") && struct_exists(item, "item_types")) {
		var intersection = array_intersection(taker.wants_types, item.item_types);
		if (array_length(intersection) < 1) {
			// Taker doesn't want this type of item.
			return false;
		}
	} else {
		return false;
	}
	
	return true;
}

function take_item(taker, item) {
	if (!(struct_exists(taker, "bag") && struct_exists(taker, "attached_things"))) {
		return;
	}
	
	array_insert(taker.bag, -1, item.id);
	array_insert(taker.attached_things, -1, item.id);
	
	if (struct_exists(taker, "wants")) {
		var item_index = array_get_index(taker.wants, item.item_name);
		if (item_index != -1) {
			array_delete(taker.wants, item_index, 1);
		}
		show_debug_message("bag length: {0}, new item: {1}, wants length: {2}",
			array_length(taker.bag), item.item_name, array_length(taker.wants));
	}
}