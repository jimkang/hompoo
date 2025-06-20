//event_inherited();
global.centering_adjust_rate = 1;

// centering_axis should be "x" or "y".
function nudge_toward_tile_center(centering_axis) {
	var vOffset = self[$ centering_axis] % global.tile_size;
	if (vOffset == 0) {
		return;
	}
	if (vOffset < global.tile_size/2) {
		// Move toward being centered in the tile that we're in.
		self[$ centering_axis] = self[$ centering_axis] - global.centering_adjust_rate;
		return;
	}
	// Move toward the center of the next tile over.
	self[$ centering_axis] = self[$ centering_axis] + global.centering_adjust_rate;
}

if (keyboard_check(vk_left)) {
	self.x -= self.move_rate;
	self.nudge_toward_tile_center("y");
}
if (keyboard_check(vk_right)) {
	self.x += self.move_rate;
	self.nudge_toward_tile_center("y");
}
if (keyboard_check(vk_up)) {
	self.y -= self.move_rate;
	self.nudge_toward_tile_center("x");
}
if (keyboard_check(vk_down)) {
	self.y += self.move_rate;
	self.nudge_toward_tile_center("x");
}

scr_bumps(self);