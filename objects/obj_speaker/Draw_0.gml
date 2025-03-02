//draw_sprite(spr_mouth, -1, self.x, self.y);

if (string_length(current_speech) > 0) {
	draw_set_font(Serif);
	draw_set_color(#221111);
	draw_text_transformed(x, y, current_speech, 0.5, 0.5, 0);
	draw_set_color(#ffffff);
	draw_text_transformed(x + 2, y + 2, current_speech, 0.5, 0.5, 0);
}