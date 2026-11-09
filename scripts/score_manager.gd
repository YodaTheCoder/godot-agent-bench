extends Node

var score: int


func add_points(n: int) -> void:
	score += n
	emit_signal("score_changed", score)


func reset() -> void:
	score = 0
	emit_signal("score_changed", score)
