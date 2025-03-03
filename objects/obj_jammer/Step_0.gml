scr_bring_attached_things(self);

if (array_length(wants) > 0) {
	self.speaker.next_speech = "Hey, I want " + wants[0] + ".";
} else {
	self.speaker.next_speech = "I have no desires. Ahh.";
}
// Inherit the parent event
//event_inherited();
