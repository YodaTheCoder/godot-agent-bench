class_name Slow
extends StatusEffect

@export var multiplier := 0.5

func apply_tick(target: Node, delta: float) -> void:
	# Slow effect only affects speed, not health
	# It will be handled by the StatusEffects component
	pass
