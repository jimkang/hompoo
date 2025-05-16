//function close_to(value, target, tolerance) {
//	return abs(value - target) <= tolerance;
//}

function drift() {
	function start(xDeltaPerStep, yDeltaPerStep, goalDriftX, goalDriftY) {
		self.xDeltaPerStep = xDeltaPerStep;
		self.yDeltaPerStep = yDeltaPerStep;
		self.goalDriftX = goalDriftX;
		self.goalDriftY = goalDriftY;
		self.stopped = false;
		self.dirX = get_direction(self.xDeltaPerStep);
		self.dirY = get_direction(self.yDeltaPerStep);
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
		if ((self.dirX > 0 ? self.driftedX >= self.goalDriftX : self.driftedX <= self.goalDriftX) &&
			(self.dirY > 0 ? self.driftedY >= self.goalDriftY : self.driftedY <= self.goalDriftY)) {
		
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
		"start": start,
		"dirX": 0,
		"dirY": 0
	}
}