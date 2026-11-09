class_name Slow extends StatusEffect

@export var multiplier := 0.5

func apply_tick(target: Node, delta: float) -> void:
	# Base class does nothing - slow is handled by StatusEffects component
	pass