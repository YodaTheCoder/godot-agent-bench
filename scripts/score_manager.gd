extends Node

var score: int
signal score_changed(score: int)


func add_points(n: int) -> void:
	score += n
	score_changed.emit(score)


func reset() -> void:
	score = 0
	score_changed.emit(score)
