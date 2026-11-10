extends Node

var score: int
var combo: int = 1
var _last_time: float = -1.0


func add_points(n: int, now: float = -1.0) -> void:
	if now >= 0.0:
		# Timed call
		if _last_time >= 0.0 and now - _last_time <= 2.0:
			combo += 1
		else:
			combo = 1
		
		score += n * combo
		_last_time = now
	else:
		# Untimed call
		score += n


func reset() -> void:
	score = 0
	combo = 1
	_last_time = -1.0
