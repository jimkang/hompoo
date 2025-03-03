//event_inherited();
self.wants = ["food"];
// Should contain instance ids
self.bag = [];

self.speaker = instance_create_layer(self.x, self.y, self.layer, obj_speaker);

self.attached_things = [self.speaker];

path_start(pth_test, 1, path_action_continue, false);