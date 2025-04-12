var box_list = ds_list_create();
var open_range = 10;
var box_count = collision_circle_list(x, y, open_range, obj_box,
	false, true, box_list, false);

if (box_count > 0) {

	// Open the first box that's openable.
	for (var i = 0; i < box_count; i += 1) {
		// TODO: Check openability.
		box_list[|i].open();
		break;
	}
}
ds_list_destroy(box_list);