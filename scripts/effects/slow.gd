extends StatusEffect

class_name Slow

@export var multiplier := 0.5

func apply_tick(target: Node, delta: float) -> void:
	# Base class does nothing - slow effect is handled by StatusEffects component
	pass