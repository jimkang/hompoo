//event_inherited();

if (keyboard_check(vk_left)) {
	self.x -= self.move_rate;
}
if (keyboard_check(vk_right)) {
	self.x += self.move_rate;
}
if (keyboard_check(vk_up)) {
	self.y -= self.move_rate;
}
if (keyboard_check(vk_down)) {
	self.y += self.move_rate;
}

scr_bumps(self);