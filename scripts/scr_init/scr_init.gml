function scr_init() {
	//var random_set_seed();
	//randomise();
	var room_info = room_get_info(room_init);
	scr_map_gen(room_info.width/global.tile_size, room_info.height/global.tile_size);
}
