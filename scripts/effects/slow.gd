class_name Slow
extends StatusEffect

@export var multiplier := 0.5

func apply_tick(target: Node, delta: float) -> void:
	# The slow effect is handled by the StatusEffects component
	# via speed_multiplier() function, not here
	pass
