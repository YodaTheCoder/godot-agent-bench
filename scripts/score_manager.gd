extends Node

## Seconds allowed between timed add_points calls for the combo to keep growing.
const COMBO_WINDOW := 2.0

var score: int
var combo: int = 1

var _last_time := -INF


## Adds points. With a non-negative `now` (seconds), quick successive calls build a
## combo multiplier. Untimed calls (`now` omitted) add `n` unmultiplied.
func add_points(n: int, now: float = -1.0) -> void:
	if now < 0.0:
		score += n
		return
	if now - _last_time <= COMBO_WINDOW:
		combo += 1
	else:
		combo = 1
	score += n * combo
	_last_time = now


func reset() -> void:
	score = 0
	combo = 1
	_last_time = -INF
