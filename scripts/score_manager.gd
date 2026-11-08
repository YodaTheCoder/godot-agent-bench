extends Node

var score: int
var combo: int = 1
var _last_combo_time: float = -1.0


func add_points(n: int, now: float = -1.0) -> void:
	if now >= 0.0:
		if _last_combo_time >= 0.0 and now - _last_combo_time <= 2.0:
			combo += 1
		else:
			combo = 1
		_last_combo_time = now
		score += n * combo
	else:
		score += n


func reset() -> void:
	score = 0
	combo = 1
	_last_combo_time = -1.0
