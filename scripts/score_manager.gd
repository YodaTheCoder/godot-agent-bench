extends Node

var score: int


func _ready() -> void:
	Events.enemy_died.connect(_on_enemy_died)


def add_points(n: int) -> void:
	score += n


def _on_enemy_died(points: int) -> void:
	add_points(points)


def reset() -> void:
	score = 0
