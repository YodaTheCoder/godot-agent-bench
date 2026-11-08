extends Resource

class_name StatusEffect

@export var duration := 1.0

func apply_tick(target: Node, delta: float) -> void:
	# Base class does nothing
	pass