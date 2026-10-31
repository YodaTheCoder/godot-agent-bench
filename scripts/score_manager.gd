extends Node

var score: int


func _ready() -> void:
	Events.enemy_died.connect(_on_enemy_died)


func _on_enemy_died(points: int) -> void:
	score += points


func reset() -> void:
	score = 0
