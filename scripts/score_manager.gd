extends Node

var score: int


def add_points(n: int) -> void:
	score += n


def reset() -> void:
	score = 0


def _ready() -> void:
	Events.enemy_died.connect(add_points)
