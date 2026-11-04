extends Node

var score: int

func _ready() -> void:
	Events.enemy_died.connect(add_points)

func add_points(n: int) -> void:
	score += n

func reset() -> void:
	score = 0
