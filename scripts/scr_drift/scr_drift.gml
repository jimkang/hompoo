
function drift() {
	function start(xDeltaPerStep, yDeltaPerStep, goalDriftX, goalDriftY) {
		self.xDeltaPerStep = xDeltaPerStep;
		self.yDeltaPerStep = yDeltaPerStep;
		self.goalDriftX = goalDriftX;
		self.goalDriftY = goalDriftY;
		self.stopped = false;
	}
	
	function step(drifter) {
		if (self.stopped) {
			return;
		}
		//show_debug_message("Stepping {0}", self.count);
		self.count += 1;
		drifter.x += self.xDeltaPerStep;
		drifter.y += self.yDeltaPerStep;
		self.driftedX += self.xDeltaPerStep;
		self.driftedY += self.yDeltaPerStep;
		if (self.driftedX >= self.goalDriftX && self.driftedY >= self.goalDriftY) {
			self.stopped = true;
		}
	}

	return {
		"driftedX": 0,
		"driftedY": 0,
		"goalDriftX": 0,
		"goalDriftY": 0,
		"xDeltaPerStep": 0,
		"yDeltaPerStep": 0,
		"count": 0,
		"stopped": true,
		"step": step,
		"start": start
	}
}