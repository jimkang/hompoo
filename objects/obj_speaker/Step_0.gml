var listener_list = ds_list_create();
var listener_count = collision_circle_list(x, y, speaking_range, obj_listener, false, true, listener_list, false);
//show_debug_message("listener_count: {0}", listener_count);
//show_debug_message(listener_list);


if (array_length(self.listeners_to_ignore) > 0) {
	var eligible_listener_count = 0;
	
	for (var i = 0; i < listener_count; ++i;) {
		var inst = listener_list[|i];
	
		//var names = variable_instance_get_names(inst);
		if (!array_contains(self.listeners_to_ignore, inst)) {
			eligible_listener_count += 1;
		}
		//show_debug_message("listener: {0}, {1}", inst.x, inst.y);
	}
	listener_count = eligible_listener_count;
}

if (listener_count > 0) {
	if (string_length(next_speech) > 0) {
		current_speech = next_speech;
		next_speech = "";
	}
	if (hide_speech_time_source) {
		call_cancel(hide_speech_time_source);
	}
	var hide_speech_callback = function() {
		current_speech = ""
	}

	hide_speech_time_source = call_later(speech_retention_secs, time_source_units_seconds, hide_speech_callback);

	// Send a message to each listener.
	for (var i = 0; i < listener_count; i += 1) {
		listener_list[|i].hear(current_speech);
	}
}
ds_list_destroy(listener_list)