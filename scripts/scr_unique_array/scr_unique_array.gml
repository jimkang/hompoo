function UniqueArray() constructor {
	array = [];
	dict = {};
	
	static add = function(item) {
		var hash = variable_get_hash(json_stringify(item));
		if (struct_exists(dict, hash)) {
			show_debug_message("Already added {0}.", hash);
		} else {
			// What is the point of struct_set_from_hash? How is it different
			// from just passing a hash to struct_set? I guess the hash is a number?
			struct_set_from_hash(dict, hash, item);
			array_push(array, item);
		}
	}
	
	static has = function(item) {
		var hash = variable_get_hash(json_stringify(item));
		return struct_exists_from_hash(dict, hash);
	}
}