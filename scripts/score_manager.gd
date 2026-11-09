extends Node

var score: int


func add_points(n: int) -> void:
	score += n


func reset() -> void:
	score = 0


func _ready() -> void:
	Events.enemy_died.connect(_on_enemy_died)


func _on_enemy_died(points: int) -> void:
	add_points(points)
