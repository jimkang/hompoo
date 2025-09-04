function is_a_player(inst) {
	return inst.object_index == obj_player;
}

if (is_a_player(other)) {
	other.hp -= 1;
}

// TODO: Figure out where scr_bumps should be called. Here or in step()?
scr_bumps(self);