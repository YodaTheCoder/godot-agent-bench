extends Node

var score: int
var combo: int = 1
var _previous_time: float = -1.0


func add_points(n: int, now: float = -1.0) -> void:
	if now >= 0.0:
		# Timed call
		if _previous_time >= 0.0 and now - _previous_time <= 2.0:
			combo += 1
		else:
			combo = 1
		
		score += n * combo
		_previous_time = now
	else:
		# Untimed call
		score += n


func reset() -> void:
	score = 0
	combo = 1
	_previous_time = -1.0
