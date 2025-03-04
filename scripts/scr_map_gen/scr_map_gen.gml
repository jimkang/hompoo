
function scr_map_gen() {
	//var tile_size = 64;
	var floor_tile_index = 2
	
	var tiles_layer = layer_get_id("Tiles_1");
	var tile_map = layer_tilemap_get_id(tiles_layer);
	//var tile_set = tilemap_get_tileset(tile_map);
	var floor_tile_data = floor_tile_index;
	
	for (var tileX = 0; tileX < 10; ++tileX) {
		for (var tileY = 0; tileY < 10; ++tileY) {
			tilemap_set(tile_map, floor_tile_data,
			tileX, tileY);
		}
	}
	
	var instances_layer = layer_get_id("Instances_1");
	instance_create_layer(64, 64, instances_layer, obj_player);
	instance_create_layer(128, 128, instances_layer, obj_garbage);
}
