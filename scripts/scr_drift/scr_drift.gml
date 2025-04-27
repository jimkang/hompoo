
function drift() {
	function start(xDeltaPerStep, yDeltaPerStep) {
		self.xDeltaPerStep = xDeltaPerStep;
		self.yDeltaPerStep = yDeltaPerStep;
	}
	
	function step(drifter) {
		//show_debug_message("Stepping {0}", self.count);
		self.count += 1;
		drifter.x += self.xDeltaPerStep;
		drifter.y += self.yDeltaPerStep;
	}

	return {		
		"xDeltaPerStep": 0,
		"yDeltaPerStep": 0,
		"count": 0,
		"step": step,
		"start": start
	}
}