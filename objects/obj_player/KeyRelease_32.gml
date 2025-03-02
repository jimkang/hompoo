function is_a_word(item) {
	if (struct_exists(item, "item_types")) {
		return array_contains(item.item_types, "word");
	}
	return false;
}

var words = array_filter(self.bag, is_a_word);

if (array_length(words) > 0) {
	// TODO: Allow word choice.
	var word = words[0];
	if (struct_exists(word, "text" )) {
		self.speaker.next_speech = word.text;
	}
}