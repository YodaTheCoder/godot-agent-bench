extends Node

const COMBO_WINDOW := 2.0

var score: int
var combo: int = 1

var _has_last_time := false
var _last_time := 0.0


# Pass `now` (seconds, any monotonic clock) to apply the combo multiplier.
# Omitting it, or passing a negative value, adds `n` unmultiplied and leaves
# the combo state untouched.
func add_points(n: int, now: float = -1.0) -> void:
	if now < 0.0:
		score += n
		return
	if _has_last_time and now - _last_time <= COMBO_WINDOW:
		combo += 1
	else:
		combo = 1
	score += n * combo
	_last_time = now
	_has_last_time = true


func reset() -> void:
	score = 0
	combo = 1
	_has_last_time = false
	_last_time = 0.0
