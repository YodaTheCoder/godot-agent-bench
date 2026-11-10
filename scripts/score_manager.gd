extends Node

var score: int
var combo: int = 1

var _previous_call_time: float = -1.0


func add_points(n: int, now: float = -1.0) -> void:
	if now >= 0.0:
		# Timed call
		if _previous_call_time >= 0.0 and now - _previous_call_time <= 2.0:
			# Within 2 seconds of previous call, increase combo
			combo += 1
		else:
			# First call or more than 2 seconds since last call, reset combo
			combo = 1
		
		score += n * combo
		_previous_call_time = now
	else:
		# Untimed call - add points without multiplier
		score += n


func reset() -> void:
	score = 0
	combo = 1
	_previous_call_time = -1.0
