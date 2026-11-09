class_name Slow extends StatusEffect

@export var multiplier := 0.5

func apply_tick(target: Node, delta: float) -> void:
	# Slow effect is handled by the StatusEffects component
	# This base implementation does nothing
	pass