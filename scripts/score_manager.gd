extends Node

@onready var events: Events = get_node("/root/Events")


var score: int


func _ready() -> void:
	events.enemy_died.connect(add_points)


func add_points(n: int) -> void:
	score += n


func reset() -> void:
	score = 0
