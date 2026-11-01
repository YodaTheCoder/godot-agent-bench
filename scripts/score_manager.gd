extends Node

var score: int

func add_points(n: int) -> void:
	score += n

func _ready() -> void:
	Events.enemy_died.connect(_on_enemy_died)

func _on_enemy_died(points: int) -> void:
	add_points(points)

func reset() -> void:
	score = 0
